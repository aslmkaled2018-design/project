import 'dart:io';

import 'package:flutter/material.dart';
import 'services/api_service.dart';

String currentUserName = "";
File? userProfileImage;

// متغير عالمي بيحفظ اسم المستخدم — بيتحدث من login وregister

class SignUpFields extends StatefulWidget {
  final VoidCallback onBack;
  const SignUpFields({super.key, required this.onBack});

  @override
  State<SignUpFields> createState() => _SignUpFieldsState();
}

class _SignUpFieldsState extends State<SignUpFields> {
  final GlobalKey<FormState> formstate = GlobalKey();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLoading = false;

  final emailreg = RegExp(
    r'^[A-Za-z0-9]+@[A-Za-z]+\.com$',
    caseSensitive: false,
  );

  Future<void> handleRegister() async {
    if (!formstate.currentState!.validate()) return;

    setState(() => isLoading = true);

    final result = await ApiService.register(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      phone: phoneController.text.trim(),
    );

    setState(() => isLoading = false);

    if (!mounted) return;

    if (result['success']) {
      // ← بنحفظ الاسم بعد التسجيل
      currentUserName =
          '${firstNameController.text.trim()} ${lastNameController.text.trim()}';
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'فشل إنشاء الحساب'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget buildTextField(
    String label, {
    bool isPassword = false,
    bool isEmail = false,
    bool isConfirmPassword = false,
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
            return 'ادخل بريد إلكتروني صحيح';
          }
          if (isConfirmPassword && value != passwordController.text) {
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
            const SizedBox(height: 22),
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
              controller: emailController,
            ),
            const SizedBox(height: 15),
            buildTextField(
              'رقم الهاتف',
              keyboardType: TextInputType.phone,
              controller: phoneController,
            ),
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
              isConfirmPassword: true,
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
              onPressed: isLoading ? null : handleRegister,
              child:
                  isLoading
                      ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : const Text('إنشاء حساب'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: widget.onBack,
              child: const Text(
                'رجوع',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}
