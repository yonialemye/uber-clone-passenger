import 'package:flutter/material.dart';
import 'package:uber_clone_passenger/app/exports/pages.dart';

import '../exports/widgets.dart';
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

  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  Future signupPassenger() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_signupFormKey.currentState!.validate()) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: Values.width20, vertical: Values.height40),
              child: Form(
                key: _signupFormKey,
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
                    MyTextField(
                      controller: fullNameController,
                      labelText: 'Full Name',
                      prefixIcon: Icons.person_outline,
                      hintText: 'Enter your full name',
                      keyBoardType: TextInputType.text,
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
                    SizedBox(height: Values.height20),
                    MyTextField(
                      controller: phoneNumberController,
                      prefixIcon: Icons.phone,
                      prefix: '+251 ',
                      labelText: 'Phone',
                      hintText: 'Enter your phone number',
                      keyBoardType: TextInputType.number,
                    ),
                    SizedBox(height: Values.height30),
                    MyElevatedButton(
                      onPressed: signupPassenger,
                      child: const MyText(text: 'Accept & Continue'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have an account? "),
              MyTextButton(onPressed: toLoginPage, text: 'Login here'),
            ],
          ),
        ],
      ),
    );
  }

  void toLoginPage() => Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
}
