import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project/sign_up.dart';
import 'MyGarden.dart';
import 'PlantDetailsPage.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Set<int> doneTasks = {};

  List<Map<String, dynamic>> getTodayTasks() {
    List<Map<String, dynamic>> tasks = [];
    final today = DateTime.now();
    for (final p in myplants) {
      for (final record in p.healthRecords) {
        if (record.date.year == today.year &&
            record.date.month == today.month &&
            record.date.day == today.day) {
          tasks.add({
            'plantName': p.name,
            'plantImage': p.image,
            'disease': record.disease,
            'treatment': record.treatment,
            'plant': p,
          });
        }
      }
    }
    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? Colors.grey[900]! : const Color.fromARGB(255, 236, 255, 237);
    final cardColor = isDark ? Colors.grey[850]! : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final shadowColor =
        isDark ? Colors.black : const Color.fromARGB(255, 149, 234, 179);
    const greenColor = Color.fromARGB(255, 56, 114, 64);

    final recentPlants =
        myplants.length <= 5 ? myplants : myplants.sublist(myplants.length - 5);
    final tasks = getTodayTasks();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: greenColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'الرئيسية',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    color: shadowColor,
                    offset: const Offset(2, 3),
                  ),
                ],
              ),
              child: ListTile(
                title: Text(
                  'مرحبا $currentUserName',
                  style: TextStyle(
                    fontSize: 26,
                    color: greenColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  tasks.isEmpty
                      ? 'مفيش مهام النهارده'
                      : 'لديك ${tasks.length} مهمة للعناية بنباتاتك اليوم',
                  style: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[700],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            _sectionTitle("مهام اليوم", textColor),

            // الجزء المهم فقط اللي اتعدل 👇
            // الجزء المهم فقط اللي اتعدل 👇
            tasks.isEmpty
                ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'مفيش مهام النهارده، نباتاتك بخير!',
                    style: TextStyle(color: Colors.grey[500], fontSize: 14),
                  ),
                )
                : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    // 👇 السطر ده بيخفي التاسك لو اتعمل Done
                    if (doneTasks.contains(index)) {
                      return const SizedBox();
                    }

                    final task = tasks[index];

                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: shadowColor,
                            offset: const Offset(2, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(task['plantImage']),
                            width: 55,
                            height: 55,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          task['plantName'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.coronavirus_outlined,
                                  size: 14,
                                  color: Colors.red,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    task['disease'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.healing,
                                  size: 14,
                                  color: greenColor,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    task['treatment']
                                        .toString()
                                        .split('\n')
                                        .first,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: greenColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // 👇 الزرار اتعدل
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: greenColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              doneTasks.add(index); // يخفي التاسك
                            });
                          },
                          child: const Text(
                            'تم',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    );
                  },
                ),

            const SizedBox(height: 15),
            _sectionTitle("حديقتي", textColor),

            myplants.isEmpty
                ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'حديقتك فارغة لسه!',
                    style: TextStyle(color: Colors.grey[500], fontSize: 14),
                  ),
                )
                : SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    right: 15,
                    left: 15,
                    bottom: 20,
                  ),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        recentPlants.map((p) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: GestureDetector(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PlantDetailsPage(Plant: p),
                                  ),
                                );
                                setState(() {});
                              },
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: greenColor,
                                        width: 3,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundImage: FileImage(File(p.image)),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    p.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, Color textColor) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 18, bottom: 8),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
