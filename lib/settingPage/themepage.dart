import 'package:flutter/material.dart';

ValueNotifier<String> appThemeNotifier = ValueNotifier("Light");
String get appTheme => appThemeNotifier.value;

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? Colors.grey[900]! : const Color.fromARGB(255, 236, 255, 237);
    final cardColor = isDark ? Colors.grey[850]! : Colors.white;
    final shadowColor =
        isDark ? Colors.black : const Color.fromARGB(255, 149, 234, 179);
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          "المظهر",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 56, 114, 64),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SizedBox(height: 10),
          Text(
            "اختر مظهر التطبيق",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          SizedBox(height: 12),
          _themeCard(
            icon: Icons.light_mode,
            title: "الوضع الفاتح",
            subtitle: "Light Mode",
            value: "Light",
            isDark: isDark,
            cardColor: cardColor,
            shadowColor: shadowColor,
          ),
          SizedBox(height: 10),
          _themeCard(
            icon: Icons.dark_mode,
            title: "الوضع الداكن",
            subtitle: "Dark Mode",
            value: "Dark",
            isDark: isDark,
            cardColor: cardColor,
            shadowColor: shadowColor,
          ),
        ],
      ),
    );
  }

  Widget _themeCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required bool isDark,
    required Color cardColor,
    required Color shadowColor,
  }) {
    final bool isSelected = appTheme == value;

    return GestureDetector(
      onTap: () {
        appThemeNotifier.value = value;
        setState(() {});
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? Color.fromARGB(255, 219, 243, 221) : cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSelected
                    ? Color.fromARGB(255, 56, 114, 64)
                    : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(blurRadius: 8, color: shadowColor, offset: Offset(2, 3)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? Color.fromARGB(255, 56, 114, 64)
                        : (isDark ? Colors.grey[700]! : Colors.grey[200]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey[600],
                size: 26,
              ),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color:
                        isSelected
                            ? Color.fromARGB(255, 56, 114, 64)
                            : Colors.black,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                ),
              ],
            ),
            Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Color.fromARGB(255, 56, 114, 64),
                size: 26,
              ),
          ],
        ),
      ),
    );
  }
}
