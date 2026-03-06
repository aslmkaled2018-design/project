import 'package:flutter/material.dart';
import 'MyGarden.dart';

class InfoSection extends StatelessWidget {
  final plant plantData;

  const InfoSection({super.key, required this.plantData});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final subColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
    final cardColor = isDark ? Colors.grey[850]! : Colors.white;

    final List<Map<String, dynamic>> careInfo = [
      {
        'name': 'الري',
        'icon': Icons.water_drop_outlined,
        'value': plantData.watering ?? 'لم يتم التحليل بعد',
      },
      {
        'name': 'الضوء',
        'icon': Icons.wb_sunny_outlined,
        'value': plantData.light ?? 'لم يتم التحليل بعد',
      },
      {
        'name': 'التسميد',
        'icon': Icons.grass,
        'value': plantData.fertilizing ?? 'لم يتم التحليل بعد',
      },
      {
        'name': 'التربة',
        'icon': Icons.terrain_outlined,
        'value': plantData.soil ?? 'لم يتم التحليل بعد',
      },
      {
        'name': 'الرطوبة',
        'icon': Icons.cloud_queue_sharp,
        'value': plantData.humidity ?? 'لم يتم التحليل بعد',
      },
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final item in careInfo)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            color: cardColor,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 243, 210),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    item['icon'],
                    size: 28,
                    color: const Color.fromARGB(255, 203, 159, 27),
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['value'],
                      style: TextStyle(fontSize: 13, color: subColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}
