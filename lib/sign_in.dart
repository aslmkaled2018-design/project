import 'package:flutter/material.dart';

GlobalKey<FormState> formstate = GlobalKey();
String? saved;
String? savedd;

class Fields extends StatefulWidget {
  final VoidCallback onBack;

  const Fields({super.key, required this.onBack});

  @override
  State<Fields> createState() => _FieldsState();
}

final emailReg = RegExp(r'^[A-Za-z0-9]+@[A-Za-z]+\.com$', caseSensitive: false);

class _FieldsState extends State<Fields> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formstate,
      child: Column(
        key: const ValueKey('signin'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'تسجيل الدخول',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 20),

          Container(
            width: 220,
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'الحقل فارغ';
                }
                if (!emailReg.hasMatch(value.trim())) {
                  return 'هذا المستخدم غير موجود';
                }
                return null;
              },
              onChanged: (value) {
                saved = value;
              },
              decoration: const InputDecoration(
                labelText: 'البريد الإلكتروني',
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 185, 185, 185),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),

          const SizedBox(height: 15),

          Container(
            width: 220,
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'الحقل فارغ';
                }
                return null;
              },
              onChanged: (value) {
                savedd = value;
              },
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'كلمة المرور',
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 185, 185, 185),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),

          const SizedBox(height: 25),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 18, 112, 65),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
            ),
            onPressed: () {
              if (formstate.currentState!.validate()) {
                Navigator.of(context).pushReplacementNamed('/home');
              }
            },
            child: const Text('تسجيل دخول'),
          ),

          const SizedBox(height: 10),

          // ← زر الرجوع
          TextButton(
            onPressed: widget.onBack, // ✅ كده صح
            child: const Text('رجوع', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }
}
