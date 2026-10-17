import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:project1/core/network/api_client.dart';
import 'package:project1/core/utils/app_colors.dart';
import 'package:project1/core/utils/function/user_session.dart';
import 'package:project1/features/auth/data/models/user_model.dart';
import 'package:project1/features/auth/data/services/auth_service.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _service = AuthService(ApiClient());
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  late Future<UserModel> _profile;
  bool _initialized = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _profile = _service.me();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final user = await _service.updateProfile(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phone: _phoneController.text.trim(),
      );
      if (!mounted) return;
      UserSession.setUser(user);
      setState(() => _profile = Future.value(user));
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم تحديث الملف الشخصي.')));
    } on DioException catch (error) {
      if (!mounted) return;
      final message = error.response?.data?['message'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message is String ? message : 'تعذر حفظ التغييرات. حاول مجدداً.',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
        backgroundColor: AppColors.backgroundColor,
        foregroundColor: AppColors.textColor,
        elevation: 0,
      ),
      body: FutureBuilder<UserModel>(
        future: _profile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('تعذر تحميل الملف الشخصي.'),
                  TextButton(
                    onPressed: () => setState(() => _profile = _service.me()),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          final user = snapshot.data!;
          if (!_initialized) {
            _firstNameController.text = user.firstName;
            _lastNameController.text = user.lastName;
            _phoneController.text = user.phone;
            _emailController.text = user.email;
            _initialized = true;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _field(
                    controller: _firstNameController,
                    label: 'الاسم الأول',
                  ),
                  const SizedBox(height: 12),
                  _field(
                    controller: _lastNameController,
                    label: 'الاسم الأخير',
                  ),
                  const SizedBox(height: 12),
                  _field(
                    controller: _emailController,
                    label: 'البريد الإلكتروني',
                    readOnly: true,
                  ),
                  const SizedBox(height: 12),
                  _field(
                    controller: _phoneController,
                    label: 'رقم الهاتف',
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('حفظ التغييرات'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    bool readOnly = false,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      validator: readOnly
          ? null
          : (value) => value == null || value.trim().isEmpty
                ? 'هذا الحقل مطلوب'
                : null,
    );
  }
}
