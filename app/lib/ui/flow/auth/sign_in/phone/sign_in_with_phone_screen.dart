import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInWithPhoneScreen extends ConsumerStatefulWidget {
  const SignInWithPhoneScreen({super.key});

  @override
  ConsumerState<SignInWithPhoneScreen> createState() =>
      _SignInWithPhoneScreenState();
}

class _SignInWithPhoneScreenState extends ConsumerState<SignInWithPhoneScreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}
