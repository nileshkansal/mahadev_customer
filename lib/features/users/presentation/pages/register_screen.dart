import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fNameController = TextEditingController();
  final _lNameController = TextEditingController();
  final _numberController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.status == AuthStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.registerData?.message ?? "Registered Successfully")));
      } else if (next.status == AuthStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.error ?? "Something went wrong")));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _fNameController,
                decoration: const InputDecoration(labelText: "First Name"),
                validator: (value) => value!.isEmpty ? "Enter first name" : null,
              ),
              TextFormField(
                controller: _lNameController,
                decoration: const InputDecoration(labelText: "Last Name"),
                validator: (value) => value!.isEmpty ? "Enter last name" : null,
              ),
              TextFormField(
                controller: _numberController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: "Mobile Number"),
                validator: (value) => value!.isEmpty ? "Enter mobile" : null,
              ),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) => value!.isEmpty ? "Enter email" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: state.status == AuthStatus.loading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          ref.read(authProvider.notifier).register(firstName: _fNameController.text, lastName: _lNameController.text, number: _numberController.text, email: _emailController.text);
                        }
                      },
                child: state.status == AuthStatus.loading ? const CircularProgressIndicator(color: Colors.white) : const Text("Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
