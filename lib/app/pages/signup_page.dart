import 'package:flutter/material.dart';
import 'package:uber_clone_passenger/app/exports/widgets.dart';

import '../exports/constants.dart';

class SignupPage extends StatefulWidget {
  static const String routeName = '/signup-page';
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    phoneNumberController.dispose();
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
                  SizedBox(height: Values.height30),
                  TextFormField(
                    controller: fullNameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: Values.width20,
                        vertical: Values.height10,
                      ),
                      labelText: 'Full Name',
                      hintText: 'Enter your full name',
                      fillColor: Coloors.blueDark.withOpacity(0.08),
                      filled: true,
                      isDense: true,
                    ),
                  ),
                  SizedBox(height: Values.height20),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email_outlined),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: Values.width20,
                        vertical: Values.height10,
                      ),
                      labelText: 'Email',
                      hintText: 'Enter your email address',
                      fillColor: Coloors.blueDark.withOpacity(0.08),
                      filled: true,
                      isDense: true,
                    ),
                  ),
                  SizedBox(height: Values.height20),
                  TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline),
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      fillColor: Coloors.blueDark.withOpacity(0.08),
                      filled: true,
                      isDense: true,
                    ),
                  ),
                  SizedBox(height: Values.height20),
                  TextFormField(
                    controller: phoneNumberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.phone),
                      prefix: const Text('+251 '),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: Values.width20,
                        vertical: Values.height10,
                      ),
                      labelText: 'Phone',
                      hintText: 'Enter your phone number',
                      fillColor: Coloors.blueDark.withOpacity(0.08),
                      filled: true,
                      isDense: true,
                    ),
                  ),
                  SizedBox(height: Values.height30),
                  MyElevatedButton(
                    child: const MyText(text: 'Accept & Continue'),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have an account? "),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  splashFactory: NoSplash.splashFactory,
                ),
                child: const Text('Login here.'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
