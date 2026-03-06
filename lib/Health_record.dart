import 'package:flutter/material.dart';
import 'MyGarden.dart';

class HealthRecordSection extends StatefulWidget {
  final plant Plant;

  const HealthRecordSection({super.key, required this.Plant});

  @override
  State<HealthRecordSection> createState() => _HealthRecordSectionState();
}

class _HealthRecordSectionState extends State<HealthRecordSection> {
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final records = widget.Plant.healthRecords;

    return records.isEmpty
        ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.health_and_safety_outlined,
                size: 60,
                color: Colors.grey[400],
              ),
              SizedBox(height: 10),
              Text(
                'لا يوجد سجلات صحية',
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ],
          ),
        )
        : ListView.separated(
          padding: EdgeInsets.all(16),
          itemCount: records.length,
          separatorBuilder: (_, __) => SizedBox(height: 8),
          itemBuilder: (context, index) {
            final record = records[index];
            return ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: Row(
                          children: [
                            Icon(
                              Icons.coronavirus_outlined,
                              color: Color.fromARGB(255, 56, 114, 64),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'تفاصيل المرض',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 56, 114, 64),
                              ),
                            ),
                          ],
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ' التاريخ: ${_formatDate(record.date)}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              record.treatment,
                              style: TextStyle(fontSize: 15, height: 1.5),
                            ),
                          ],
                        ),
                        actions: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 56, 114, 64),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: Text('إغلاق'),
                          ),
                        ],
                      ),
                );
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              tileColor: Color.fromARGB(255, 236, 255, 237),
              leading: CircleAvatar(
                backgroundColor: Color.fromARGB(255, 56, 114, 64),
                child: Icon(
                  Icons.coronavirus_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              title: Text(
                record.disease.length > 40
                    ? '${record.disease.substring(0, 40)}...'
                    : record.disease,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color.fromARGB(255, 56, 114, 64),
                ),
              ),
              subtitle: Text(
                'التاريخ ${_formatDate(record.date)}',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Colors.grey,
              ),
            );
          },
        );
  }
}
