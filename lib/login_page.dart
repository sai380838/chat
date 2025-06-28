import 'package:chat/auth_bloc.dart';
import 'package:chat/home_page.dart';
import 'package:chat/register_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('login').tr()),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
            context.go('/home');

          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(controller: emailCtrl, decoration: InputDecoration(labelText: 'email'.tr())),
                TextField(controller: passCtrl, obscureText: true, decoration: InputDecoration(labelText: 'password'.tr())),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(LoginSubmitted(emailCtrl.text, passCtrl.text));
                  },
                  child: Text('login').tr(),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterPage()));
                  },
                  child: Text('signup').tr(),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}


