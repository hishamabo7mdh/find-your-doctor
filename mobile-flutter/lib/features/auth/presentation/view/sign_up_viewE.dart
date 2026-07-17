import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpViewE extends StatefulWidget {
  const SignUpViewE({super.key});

  @override
  State<SignUpViewE> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpViewE> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2DB9B0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Logo
              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_add_alt_1,
                  size: 50,
                  color: Color(0xff2DB9B0),
                ),
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "إنشاء حساب",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Name
                    const Text("الاسم الكامل"),
                    const SizedBox(height: 5),
                    TextField(
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: "أدخل اسمك الكامل",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Email
                    const Text("البريد الإلكتروني"),
                    const SizedBox(height: 5),
                    TextField(
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: "example@gmail.com",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Phone
                    const Text("رقم الهاتف"),
                    const SizedBox(height: 5),
                    TextField(
                      keyboardType: TextInputType.phone,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: "05xxxxxxxx",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.phone_outlined),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Password
                    const Text("كلمة المرور"),
                    const SizedBox(height: 5),
                    TextField(
                      obscureText: true,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: "********",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: const Icon(Icons.visibility_outlined),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Confirm Password
                    const Text("تأكيد كلمة المرور"),
                    const SizedBox(height: 5),
                    TextField(
                      obscureText: true,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: "********",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.lock_reset_outlined),
                        suffixIcon: const Icon(Icons.visibility_outlined),
                      ),
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Checkbox(
                          value: false,
                          onChanged: (value) {},
                        ),
                        const Expanded(
                          child: Text(
                            "أوافق على الشروط والأحكام",
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(

                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff2DB9B0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "إنشاء حساب",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    const Center(
                      child: Text("أو إنشاء حساب بواسطة"),
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.g_mobiledata),
                            label: const Text("Google"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.apple),
                            label: const Text("Apple"),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Center(
                      child: TextButton(
                        onPressed: () {context.go('/');},
                        child: const Text(
                          "لديك حساب بالفعل؟ تسجيل الدخول",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}