import 'package:flutter/material.dart';
import 'package:arena/components/custom_text.dart';

class QtyButton extends StatelessWidget {
  final int qty;
  final VoidCallback onAdd, onMin;
  final bool enabled;
  final bool isSyncing;

  const QtyButton({
    super.key,
    required this.qty,
    required this.onAdd,
    required this.onMin,
    this.enabled = true,
    this.isSyncing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _btn(Icons.remove, enabled ? onMin : () {}),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(text: '$qty', style: const TextStyle(fontSize: 14)),
              SizedBox(
                width: isSyncing ? 16 : 0,
                height: 14,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: isSyncing
                      ? const Padding(
                          key: ValueKey('syncing'),
                          padding: EdgeInsets.only(left: 6),
                          child: SizedBox(
                            width: 10,
                            height: 10,
                            child: CircularProgressIndicator(strokeWidth: 1.5),
                          ),
                        )
                      : const SizedBox.shrink(key: ValueKey('idle')),
                ),
              ),
            ],
          ),
        ),
        _btn(Icons.add, enabled ? onAdd : () {}),
      ],
    );
  }

  Widget _btn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: enabled ? 1 : 0.4,
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16),
        ),
      ),
    );
  }
}
