import 'dart:async';
import 'dart:convert';

import 'package:arena/utils/app_shared_preferances.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';

class ThermalPrinterState {
  final List<Printer> devices;
  final bool scanning;
  final String? error;

  const ThermalPrinterState({
    this.devices = const [],
    this.scanning = false,
    this.error,
  });

  Printer? get connectedPrinter {
    for (final device in devices) {
      if (device.isConnected ?? false) return device;
    }
    return null;
  }

  ThermalPrinterState copyWith({
    List<Printer>? devices,
    bool? scanning,
    String? error,
    bool clearError = false,
  }) {
    return ThermalPrinterState(
      devices: devices ?? this.devices,
      scanning: scanning ?? this.scanning,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class ThermalPrinterService {
  ThermalPrinterService._();

  static final ThermalPrinterService instance = ThermalPrinterService._();

  static const _savedPrinterKey = 'thermal_printer';
  static const Duration _scanTimeoutDuration = Duration(seconds: 10);
  static const _noDevicesMessage =
      'Tidak ada printer ditemukan. Pastikan printer menyala dan dalam mode pairing.';

  final ValueNotifier<ThermalPrinterState> state = ValueNotifier(
    const ThermalPrinterState(),
  );

  StreamSubscription<List<Printer>>? _devicesSubscription;
  StreamSubscription<BleDevice>? _bleScanSubscription;
  Timer? _scanTimeout;
  Timer? _connectivityTimer;
  String? _lastConnectedAddress;
  final Map<String, StreamSubscription<bool>> _bleConnectionSubscriptions = {};

  static const Duration _connectivityInterval = Duration(seconds: 5);

  final List<Printer> _usbDevices = [];
  final Map<String, Printer> _bleDevices = {};

  FlutterThermalPrinter get _plugin => FlutterThermalPrinter.instance;

  Future<void> startScan() async {
    _cancelScanTimeout();
    await _stopScans();
    state.value = state.value.copyWith(scanning: true, clearError: true);

    await _startUSBScan();
    await _startBLEScan();
    _startConnectivityPoll();

    _scanTimeout = Timer(_scanTimeoutDuration, _finishScan);
  }

  Future<void> stopScan() async {
    _cancelScanTimeout();
    _stopConnectivityPoll();
    await _stopScans();
    await _devicesSubscription?.cancel();
    _devicesSubscription = null;
    for (final subscription in _bleConnectionSubscriptions.values) {
      await subscription.cancel();
    }
    _bleConnectionSubscriptions.clear();
    state.value = state.value.copyWith(scanning: false);
  }

  Future<void> _startUSBScan() async {
    await _devicesSubscription?.cancel();
    _devicesSubscription = _plugin.devicesStream.listen((devices) {
      _usbDevices
        ..clear()
        ..addAll(devices.where((d) => d.connectionType == ConnectionType.USB));
      _updateState();
    });
    try {
      await _plugin.getPrinters(connectionTypes: const [ConnectionType.USB]);
    } catch (_) {
    }
  }

  Future<void> _startBLEScan() async {
    await _bleScanSubscription?.cancel();
    _bleScanSubscription = null;
    try {
      final availability = await UniversalBle.getBluetoothAvailabilityState();
      if (availability != AvailabilityState.poweredOn) {
        state.value = state.value.copyWith(
          error: 'Bluetooth mati. Nyalakan Bluetooth dulu.',
        );
        return;
      }

      await UniversalBle.requestPermissions(withAndroidFineLocation: true);

      await _addSystemBleDevices();

      await UniversalBle.startScan(
        platformConfig: PlatformConfig(
          android: AndroidOptions(requestLocationPermission: true),
        ),
      );

      _bleScanSubscription = UniversalBle.scanStream.listen(_addBleDevice);
    } catch (e) {
      final message = e.toString().toLowerCase();
      if (message.contains('permission') || message.contains('denied')) {
        state.value = state.value.copyWith(
          error: 'Izin Bluetooth/lokasi ditolak. Izinkan di pengaturan HP.',
        );
      } else {
        state.value = state.value.copyWith(error: 'Gagal scan Bluetooth: $e');
      }
    }
  }

  Future<void> _addSystemBleDevices() async {
    try {
      final systemDevices = await UniversalBle.getSystemDevices();
      for (final device in systemDevices) {
        _addBleDevice(device);
      }
    } catch (_) {
    }
  }

  void _addBleDevice(BleDevice device) {
    final address = device.deviceId;
    if (address.isEmpty) return;
    final name = (device.name?.trim().isNotEmpty ?? false)
        ? device.name
        : address;
    final printer = Printer(
      address: address,
      name: name,
      connectionType: ConnectionType.BLE,
      isConnected: false,
    );
    _bleDevices[address] = printer;
    _ensureBleConnectionListener(printer);
    _updateState();
  }

  void _updateState() {
    final devices = <Printer>[..._usbDevices, ..._bleDevices.values]
      ..sort((a, b) {
        final aConnected = (a.isConnected ?? false) ? 0 : 1;
        final bConnected = (b.isConnected ?? false) ? 0 : 1;
        if (aConnected != bConnected) return aConnected.compareTo(bConnected);
        return (a.name ?? '').compareTo(b.name ?? '');
      });

    state.value = state.value.copyWith(
      devices: devices,
      scanning: devices.isNotEmpty ? false : state.value.scanning,
    );
  }

  Future<void> _finishScan() async {
    _cancelScanTimeout();
    await _stopScans();
    await _autoReconnectSavedPrinter();
    final current = state.value;
    state.value = current.copyWith(
      scanning: false,
      error:
          current.error ?? (current.devices.isEmpty ? _noDevicesMessage : null),
    );
  }

  Future<void> _stopScans() async {
    await _bleScanSubscription?.cancel();
    _bleScanSubscription = null;
    await _plugin.stopScan();
  }

  void _cancelScanTimeout() {
    _scanTimeout?.cancel();
    _scanTimeout = null;
  }

  void _startConnectivityPoll() {
    _stopConnectivityPoll();
    _connectivityTimer = Timer.periodic(_connectivityInterval, (_) {
      _pollConnectivity();
    });
  }

  void _stopConnectivityPoll() {
    _connectivityTimer?.cancel();
    _connectivityTimer = null;
  }

  Future<void> _pollConnectivity() async {
    final current = state.value.connectedPrinter;
    if (current == null) return;

    try {
      final connected = await _isActuallyConnected(current);
      if (connected) return;

      _markDisconnected(current);
    } catch (_) {
    }
  }

  Future<bool> _isActuallyConnected(Printer printer) async {
    try {
      if (printer.connectionType == ConnectionType.USB) {
        return printer.isConnected ?? true;
      }
      final address = printer.address;
      if (address == null) return false;
      final connectionState = await UniversalBle.getConnectionState(address);
      return connectionState == BleConnectionState.connected;
    } catch (_) {
      return false;
    }
  }

  void _markDisconnected(Printer printer) {
    final address = printer.address;
    if (printer.connectionType == ConnectionType.BLE && address != null) {
      final index = _bleDevices[address];
      if (index != null) {
        _bleDevices[address] = index.copyWith(isConnected: false);
      }
    } else {
      final index = _usbDevices.indexWhere(
        (d) =>
            d.connectionType == printer.connectionType &&
            d.address == printer.address,
      );
      if (index != -1) {
        _usbDevices[index] = _usbDevices[index].copyWith(isConnected: false);
      }
    }
    _updateState();
  }

  Future<bool> ensureConnected() async {
    final current = state.value.connectedPrinter;
    if (current != null) {
      final stillConnected = await _isActuallyConnected(current);
      if (stillConnected) return true;
      _markDisconnected(current);
    }

    await _autoReconnectSavedPrinter();
    return state.value.connectedPrinter != null;
  }

  String? get lastConnectedAddress => _lastConnectedAddress;

  Future<bool> connect(Printer printer) async {
    try {
      final connected = await _plugin.connect(printer);
      if (connected) {
        await _savePrinter(printer);
        _updateConnectedState(printer, true);
        _ensureBleConnectionListener(printer);
      }
      return connected;
    } catch (_) {
      return false;
    }
  }

  Future<void> disconnect(Printer printer) async {
    try {
      await _plugin.disconnect(printer);
      _updateConnectedState(printer, false);
      if (printer.connectionType == ConnectionType.BLE &&
          printer.address != null) {
        final subscription =
            _bleConnectionSubscriptions.remove(printer.address);
        await subscription?.cancel();
      }
    } catch (_) {
    }
  }

  void _ensureBleConnectionListener(Printer printer) {
    if (printer.connectionType != ConnectionType.BLE) return;
    final address = printer.address;
    if (address == null || address.isEmpty) return;
    if (_bleConnectionSubscriptions.containsKey(address)) return;

    _bleConnectionSubscriptions[address] =
        UniversalBle.connectionStream(address).listen(
      (connected) {
        _updateConnectedState(printer, connected);
      },
      onError: (_) {
      },
    );
  }

  void _updateConnectedState(Printer printer, bool connected) {
    if (connected && printer.address != null) {
      _lastConnectedAddress = printer.address;
    }
    final address = printer.address;
    if (printer.connectionType == ConnectionType.BLE &&
        address != null &&
        _bleDevices.containsKey(address)) {
      _bleDevices[address] = _bleDevices[address]!.copyWith(
        isConnected: connected,
      );
    } else {
      final index = _usbDevices.indexWhere(
        (d) =>
            d.connectionType == printer.connectionType &&
            d.address == printer.address,
      );
      if (index != -1) {
        _usbDevices[index] = _usbDevices[index].copyWith(
          isConnected: connected,
        );
      }
    }
    _updateState();
  }

  Future<void> printBytes(List<int> bytes, {bool longData = true}) async {
    final printer = state.value.connectedPrinter;
    if (printer == null) {
      throw Exception('Tidak ada printer yang tersambung');
    }
    try {
      await _plugin.printData(printer, bytes, longData: longData);
    } catch (e) {
      throw Exception('Gagal mencetak: $e');
    }
  }

  Future<void> _autoReconnectSavedPrinter() async {
    final savedJson = await AppSharedPreferances.read(_savedPrinterKey);
    if (savedJson.isEmpty) return;

    try {
      final saved = Printer.fromJson(
        jsonDecode(savedJson) as Map<String, dynamic>,
      );
      final devices = state.value.devices;
      final match = devices.where(
        (device) =>
            device.connectionType == saved.connectionType &&
            device.address == saved.address,
      );

      final current = state.value.connectedPrinter;
      if (current != null) return;
      if (match.isNotEmpty) {
        await connect(match.first);
      }
    } catch (_) {
    }
  }

  Future<void> _savePrinter(Printer printer) async {
    await AppSharedPreferances.write(
      _savedPrinterKey,
      jsonEncode(printer.toJson()),
    );
  }
}
