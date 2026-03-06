import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/router/app_router.dart';
import '../../providers/auth_provider.dart';

/// Phone login screen
class PhoneLoginScreen extends ConsumerStatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  ConsumerState<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends ConsumerState<PhoneLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _phoneFocusNode = FocusNode();
  bool _isLoading = false;

  // India country code for Bangalore launch
  static const String _countryCode = '+91';

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    // Remove spaces and dashes
    final cleanedNumber = value.replaceAll(RegExp(r'[\s-]'), '');
    if (cleanedNumber.length != 10) {
      return 'Please enter a valid 10-digit phone number';
    }
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(cleanedNumber)) {
      return 'Please enter a valid Indian mobile number';
    }
    return null;
  }

  Future<void> _onContinue() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final cleanedNumber =
        _phoneController.text.replaceAll(RegExp(r'[\s-]'), '');
    final fullPhoneNumber = '$_countryCode$cleanedNumber';

    try {
      await ref.read(phoneAuthProvider.notifier).verifyPhoneNumber(
            fullPhoneNumber,
          );

      // Listen for state changes
      final authState = ref.read(phoneAuthProvider);

      if (authState.status == PhoneAuthStatus.codeSent && mounted) {
        context.go(
          '${AppRoutes.otpVerification}?phone=${Uri.encodeComponent(fullPhoneNumber)}',
          extra: authState.verificationId,
        );
      } else if (authState.status == PhoneAuthStatus.error && mounted) {
        _showError(authState.errorMessage ?? 'An error occurred');
      }
    } catch (e) {
      if (mounted) {
        _showError(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Listen to auth state changes
    ref.listen<PhoneAuthState>(phoneAuthProvider, (previous, next) {
      if (next.status == PhoneAuthStatus.codeSent && mounted) {
        context.go(
          '${AppRoutes.otpVerification}?phone=${Uri.encodeComponent('$_countryCode${_phoneController.text.replaceAll(RegExp(r'[\s-]'), '')}')}',
          extra: next.verificationId,
        );
      } else if (next.status == PhoneAuthStatus.error && mounted) {
        setState(() => _isLoading = false);
        _showError(next.errorMessage ?? 'An error occurred');
      }
    });

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.go(AppRoutes.intro),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(flex: 1),

                // Bold Futuristic Header
                Text(
                  'PHONE\nNUMBER',
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                    letterSpacing: -1.5,
                  ),
                ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1, end: 0),
                
                const SizedBox(height: 16),
                
                Text(
                  'We will send you a verification code to get you started.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.5),
                  ),
                ).animate().fadeIn(delay: 200.ms),
                
                const SizedBox(height: 48),

                // Phone input with Glassmorphic feel
                TextFormField(
                  controller: _phoneController,
                  focusNode: _phoneFocusNode,
                  keyboardType: TextInputType.phone,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                    _PhoneNumberFormatter(),
                  ],
                  validator: _validatePhone,
                  decoration: InputDecoration(
                    hintText: '00000 00000',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 12),
                      child: Text(
                        _countryCode,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                  ),
                ).animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1)),

                const SizedBox(height: 16),

                Text(
                  'By continuing, you agree to our Terms and Privacy Policy',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.3),
                  ),
                ).animate().fadeIn(delay: 600.ms),

                const Spacer(flex: 2),

                // Continue button with Glow
                FilledButton(
                  onPressed: _isLoading ? null : _onContinue,
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('GET CODE'),
                ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.2, end: 0),
                
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Formatter to add spaces in phone number for readability
class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    if (text.isEmpty) return newValue;

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i == 5) buffer.write(' ');
      buffer.write(text[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
