import 'package:flutter/material.dart';
import 'package:uber_clone_passenger/app/services/firebase_services.dart';

import '../exports/constants.dart';
import '../exports/pages.dart';
import '../exports/widgets.dart';
import '../helpers/check_connection.dart';
import '../helpers/show_loading_dialog.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login-page';
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  String? emailErrorMessage;
  String? passwordErrorMessage;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future loginPassenger() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final status = await checkConnection();
    if (status == Operation.failed) return;
    setState(() {
      emailErrorMessage = null;
      passwordErrorMessage = null;
    });
    if (!_loginFormKey.currentState!.validate()) return;
    showLoadingDialog(context: context, text: 'Please wait...');
    final result = await FirebaseServices.loginPassenger(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
    closeLoadingDialog();
    if (result is String) {
      if (result == 'Wrong password') {
        setState(() => passwordErrorMessage = result);
      } else {
        setState(() => emailErrorMessage = result);
      }
      return;
    }

    if (result == Operation.success) toHomePage();
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
                key: _loginFormKey,
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
                      hintText: 'Enter your email address',
                      prefixIcon: Icons.email_outlined,
                      keyBoardType: TextInputType.emailAddress,
                      errorMessage: emailErrorMessage,
                    ),
                    SizedBox(height: Values.height20),
                    MyTextField(
                      controller: passwordController,
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: Icons.lock_outline,
                      keyBoardType: TextInputType.visiblePassword,
                      errorMessage: passwordErrorMessage,
                    ),
                    SizedBox(height: Values.height30),
                    Hero(
                      tag: ButtonsHero.elevated,
                      child: MyElevatedButton(
                        onPressed: loginPassenger,
                        child: const MyText(text: 'Continue'),
                      ),
                    ),
                  ],
                ),
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

  void closeLoadingDialog() => Navigator.of(context).pop();
  void toSignupPage() => Navigator.of(context).pushReplacementNamed(SignupPage.routeName);
  void toHomePage() => Navigator.of(context).pushNamedAndRemoveUntil(
        HomePage.routeName,
        (context) => false,
      );
}
