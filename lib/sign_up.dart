import 'package:flutter/material.dart';

// متغير عالمي يحفظ اسم المستخدم
String currentUserName = "";

class SignUpFields extends StatefulWidget {
  final VoidCallback onBack;
  const SignUpFields({super.key, required this.onBack});

  @override
  State<SignUpFields> createState() => _SignUpFieldsState();
}

class _SignUpFieldsState extends State<SignUpFields> {
  GlobalKey<FormState> formstate = GlobalKey();

  // ← أضف الـ controllers دول
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final emailreg = RegExp(
    r'^[A-Za-z0-9]+@[A-Za-z]+\.com$',
    caseSensitive: false,
  );

  Widget buildTextField(
    String label, {
    bool isPassword = false,
    bool isEmail = false,
    bool isconfirmPassword = false,
    TextInputType? keyboardType,
    TextEditingController? controller,
  }) {
    return SizedBox(
      width: 200,
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value!.isEmpty) return 'الحقل فارغ';
          if (isEmail && !emailreg.hasMatch(value.trim())) {
            return 'ادخل بريد الكتروني صحيح';
          }
          if (isconfirmPassword && value != passwordController.text) {
            return 'كلمة المرور غير متطابقة';
          }
          return null;
        },
        obscureText: isPassword,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Color.fromARGB(255, 185, 185, 185),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white70),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formstate,
        child: Column(
          key: const ValueKey('signup'),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 22),
            const Text(
              'إنشاء حساب جديد',
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            buildTextField('الاسم الأول', controller: firstNameController),
            const SizedBox(height: 15),
            buildTextField('الاسم الأخير', controller: lastNameController),
            const SizedBox(height: 15),
            buildTextField(
              'البريد الإلكتروني',
              keyboardType: TextInputType.emailAddress,
              isEmail: true,
            ),
            const SizedBox(height: 15),
            buildTextField('رقم الهاتف', keyboardType: TextInputType.phone),
            const SizedBox(height: 15),
            buildTextField(
              'كلمة المرور',
              isPassword: true,
              controller: passwordController,
            ),
            const SizedBox(height: 15),
            buildTextField(
              'تأكيد كلمة المرور',
              isPassword: true,
              controller: confirmPasswordController,
              isconfirmPassword: true,
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 18, 112, 65),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 60,
                  vertical: 10,
                ),
              ),
              onPressed: () {
                if (formstate.currentState!.validate()) {
                  // ← هنا بيحفظ الاسم
                  currentUserName =
                      "${firstNameController.text} ${lastNameController.text}";
                  Navigator.of(context).pushReplacementNamed('/home');
                }
              },
              child: const Text('إنشاء حساب'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: widget.onBack,
              child: const Text(
                'رجوع',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}
