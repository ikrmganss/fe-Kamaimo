import 'package:flutter/material.dart';
import 'package:berani_kamaimo/core/theme/app_colors.dart';
import 'package:berani_kamaimo/core/utils/constants.dart';

/// Halaman login admin (M3-1). Pintu: ketik adminBK2025 di search bar beranda.
class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  bool get _canSubmit =>
      _userCtrl.text.trim().isNotEmpty && _passCtrl.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _userCtrl.addListener(_rebuild);
    _passCtrl.addListener(_rebuild);
  }

  void _rebuild() => setState(() {});

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() { _loading = true; _error = null; });
    try {
      await Future.delayed(const Duration(milliseconds: 400)); // ponytail: replace real API saat backend jalan
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppConstants.routeAdminDashboard,
        (r) => false,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() { _loading = false; _error = e.toString(); });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.adminLoginGradient),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: AppColors.shadowCard,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.admin_panel_settings_outlined,
                      size: 48, color: AppColors.pine700),
                  const SizedBox(height: 12),
                  const Text('Admin Login',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary, fontFamily: 'PlusJakartaSans')),
                  const SizedBox(height: 4),
                  const Text('Khusus pengelola Berani Kamaimo',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: AppColors.textTertiary,
                          fontFamily: 'PlusJakartaSans')),
                  const SizedBox(height: 24),
                  Text('Mode admin terbuka',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xD9FFFFFF),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'PlusJakartaSans',
                      )),
                  const SizedBox(height: 4),
                  _field(_userCtrl, 'Username', Icons.person_outline_rounded, false),
                  const SizedBox(height: 12),
                  _field(_passCtrl, 'Password', Icons.lock_outline_rounded, _obscure,
                      suffix: IconButton(
                        icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            size: 20, color: AppColors.textTertiary),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      )),
                  if (_error != null) ...[
                    const SizedBox(height: 10),
                    Text(_error!,
                        style: const TextStyle(fontSize: 12, color: AppColors.error,
                            fontFamily: 'PlusJakartaSans')),
                  ],
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: (!_canSubmit || _loading) ? null : _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.pine700,
                      disabledBackgroundColor: AppColors.surfaceVariant,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _loading
                        ? const SizedBox(width: 18, height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('Login',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700,
                                fontFamily: 'PlusJakartaSans')),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Kembali ke aplikasi',
                        style: TextStyle(fontSize: 12, color: AppColors.textTertiary,
                            fontFamily: 'PlusJakartaSans')),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String hint, IconData icon, bool obscure,
      {Widget? suffix}) {
    return TextField(
      controller: ctrl,
      obscureText: obscure,
      style: const TextStyle(fontSize: 13, fontFamily: 'PlusJakartaSans',
          color: AppColors.textPrimary),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, size: 20, color: AppColors.textTertiary),
        suffixIcon: suffix,
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13, color: AppColors.textTertiary,
            fontFamily: 'PlusJakartaSans'),
        filled: true, fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.pine700)),
      ),
    );
  }
}
