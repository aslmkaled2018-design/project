import 'package:flutter/material.dart';
import '../MyGarden.dart';

class ClearHistoryPage extends StatefulWidget {
  const ClearHistoryPage({super.key});

  @override
  State<ClearHistoryPage> createState() => _ClearHistoryPageState();
}

class _ClearHistoryPageState extends State<ClearHistoryPage> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? Colors.grey[900]! : const Color.fromARGB(255, 236, 255, 237);
    final cardColor = isDark ? Colors.grey[850]! : Colors.white;
    final shadowColor =
        isDark ? Colors.black : const Color.fromARGB(255, 149, 234, 179);
    final textColor = isDark ? Colors.white : Colors.black;
    const greenColor = Color.fromARGB(255, 56, 114, 64);

    final totalScans = myplants.fold(
      0,
      (sum, p) => sum + p.healthRecords.length,
    );

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          "مسح سجل الفحوصات",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: greenColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  blurRadius: 8,
                  color: shadowColor,
                  offset: const Offset(2, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.delete_outline, size: 60, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  "مسح سجل الفحوصات",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "لديك $totalScans فحص مسجل. هل تريد مسحهم جميعاً؟",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[500], fontSize: 14),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              backgroundColor: cardColor,
                              title: Text(
                                "تأكيد المسح",
                                style: TextStyle(color: textColor),
                              ),
                              content: Text(
                                "هل أنت متأكد؟ لا يمكن التراجع عن هذا الإجراء.",
                                style: TextStyle(color: Colors.grey[500]),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("إلغاء"),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      for (final p in myplants) {
                                        p.healthRecords.clear();
                                      }
                                    });
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: greenColor,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        content: const Row(
                                          children: [
                                            Icon(
                                              Icons.check_circle,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              "تم مسح السجل بنجاح",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text("مسح"),
                                ),
                              ],
                            ),
                      );
                    },
                    child: const Text(
                      "مسح كل الفحوصات",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
