import 'package:flutter/material.dart';
import 'dart:io';
import 'MyGarden.dart';
import 'Care.dart';
import 'Health_record.dart';

class PlantDetailsPage extends StatefulWidget {
  final plant Plant;

  const PlantDetailsPage({super.key, required this.Plant});

  @override
  State<PlantDetailsPage> createState() => _PlantDetailsPageState();
}

class _PlantDetailsPageState extends State<PlantDetailsPage> {
  late TextEditingController notesController;
  late TextEditingController wateringController;
  late TextEditingController locationController;

  @override
  void initState() {
    super.initState();
    notesController = TextEditingController(text: widget.Plant.notes ?? "");
    wateringController = TextEditingController(
      text: widget.Plant.wateringSchedule ?? "",
    );
    locationController = TextEditingController(
      text: widget.Plant.location ?? "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: const Text(
            "ملف النبات",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 56, 114, 64),
        ),
        body: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: Image.file(
                File(widget.Plant.image),
                height: 200,
                width: 360,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.Plant.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              margin: EdgeInsets.all(13),
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TabBar(
                dividerColor: Colors.grey.shade300,
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: const TextStyle(fontSize: 12),
                indicator: BoxDecoration(
                  color: const Color.fromARGB(255, 48, 88, 39),
                  borderRadius: BorderRadius.circular(5),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                tabs: [Tab(text: "الرعاية"), Tab(text: "سجل الصحة")],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  InfoSection(plantData: widget.Plant),
                  HealthRecordSection(Plant: widget.Plant),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
