import 'package:flutter/material.dart';
import 'package:uber_clone_passenger/app/exports/pages.dart';

import '../exports/constants.dart';
import '../exports/widgets.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login-page';
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: Values.width20, vertical: Values.height40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Values.height30),
                  MyText(
                    text: 'Create new account, Passenger',
                    fontSize: Values.font20,
                    textColor: Theme.of(context).textTheme.bodyText2!.color,
                  ),
                  SizedBox(height: Values.height20),
                  MyTextField(
                    controller: emailController,
                    labelText: 'Email',
                    prefixIcon: Icons.email_outlined,
                    keyBoardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: Values.height20),
                  MyTextField(
                    controller: passwordController,
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: Icons.lock_outline,
                    keyBoardType: TextInputType.visiblePassword,
                  ),
                  SizedBox(height: Values.height30),
                  MyElevatedButton(
                    child: const MyText(text: 'Continue'),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account yet? "),
              MyTextButton(onPressed: toSignupPage, text: 'Signup here'),
            ],
          ),
        ],
      ),
    );
  }

  void toSignupPage() => Navigator.of(context).pushReplacementNamed(SignupPage.routeName);
}
