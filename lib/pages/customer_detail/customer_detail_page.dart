import 'package:arena/components/icon_button/custom_icon_button_circle.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/models/order/add_order_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomerDetailPage extends StatelessWidget {
  final AddOrderModel order;

  const CustomerDetailPage({super.key, required this.order});

  Widget buildItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: CustomText(
              text: title,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ),

          Expanded(
            flex: 2,
            child: CustomText(
              text: value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCard(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),

          const CustomSpacing(height: 12),

          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF1F1F1),
        surfaceTintColor: const Color(0xFFF1F1F1),
        elevation: 0,

        automaticallyImplyLeading: false,

        leadingWidth: 72,

        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: CustomIconbuttonCircle(
            prefixIcon: Icons.arrow_back,
            backgroundColor: Colors.white,
            iconColor: Colors.black,
            onPressed: () => context.pop(),
          ),
        ),

        title: const CustomText(
          text: "Pelanggan",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildCard("Informasi Customer", [
              buildItem("Nama", order.data?.customerName ?? "-"),

              buildItem("No Hp", order.data?.customerPhone ?? "-"),
            ]),

            const CustomSpacing(height: 16),

            buildCard("Informasi Kendaraan", [
              buildItem("Kendaraan", order.data?.vehicleModel ?? "-"),

              buildItem("Plat Nomor", order.data?.vehiclePlate ?? "-"),
            ]),
          ],
        ),
      ),
    );
  }
}
