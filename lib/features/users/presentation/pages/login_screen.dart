import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _numberController = TextEditingController();
  final _pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.status == AuthStatus.success && next.loginData != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.loginData?.message ?? "Login Successful!")),
        );
        // TODO: Navigate to Home Screen
      } else if (next.status == AuthStatus.error && next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _numberController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: "Mobile Number"),
                validator: (value) =>
                value!.isEmpty ? "Enter mobile number" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _pinController,
                decoration: const InputDecoration(labelText: "PIN"),
                obscureText: true,
                keyboardType: TextInputType.number,
                validator: (value) =>
                value!.isEmpty ? "Enter your PIN" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: authState.status == AuthStatus.loading
                    ? null
                    : () {
                  if (_formKey.currentState!.validate()) {
                    ref.read(authProvider.notifier).login(
                      number: _numberController.text.trim(),
                      pin: _pinController.text.trim(),
                      latitude: "test",
                      longitude: "test",
                      fcmToken: "test",
                      deviceInfo: "test",
                    );
                  }
                },
                child: authState.status == AuthStatus.loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
