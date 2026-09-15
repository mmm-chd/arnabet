import 'package:arena/models/jasa/jasa_list_model.dart';
import 'package:arena/services/jasa/jasa_service.dart';

class JasaRepository {
  final JasaService _service;

  JasaRepository({JasaService? service}) : _service = service ?? JasaService();

  Future<JasaListModel> getServices({String? search}) =>
      _service.getServices(search: search);

  Future<void> addService({required String name, required int price}) =>
      _service.addService(name: name, price: price);

  Future<void> updateService({
    required int id,
    required String name,
    required int price,
  }) => _service.updateService(id: id, name: name, price: price);

  Future<void> deleteService({required int id}) =>
      _service.deleteService(id: id);
}
