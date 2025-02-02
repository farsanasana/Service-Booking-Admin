import 'package:admin/features/dashboard/view/admin_dashboard.dart';
import 'package:admin/features/sign_in/controller/auth_controller.dart';
import 'package:admin/utils/constand/ColorsSys.dart';
import 'package:admin/widgets/reusable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SigninForm extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SigninForm({super.key});

  @override
  Widget build(BuildContext context) {
    final authModel = Provider.of<AuthModel>(context);

    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Sign In", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
              SizedBox(height: 20),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Your trusted home service partner is just a login away.',
                      style: TextStyle(fontSize: 18),
                    ),
                    TextSpan(
                      text: ' Welcome back! ',
                      style: TextStyle(
                        fontSize: 20,
                        color: ColorSys.secoundry,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              reusableTextField(
                'Enter Your Email',
                Icons.email_outlined,
                false,
                emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email or username';
                  } else if (!RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              reusableTextField(
                'Enter Your Password',
                Icons.lock_outline,
                true,
                passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              CustomButton(
                context,
                "Sign In",
                () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await authModel.signIn(
                        emailController.text,
                        passwordController.text,
                      );
                      if (authModel.isAuthenticated) {
                        Navigator.pushNamed(context, '/dashbord');
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Invalid credentials or error occurred'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
