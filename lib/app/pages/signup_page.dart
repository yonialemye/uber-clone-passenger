import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../exports/helpers.dart';
import '../exports/services.dart';
import '../exports/pages.dart';
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
  String? emailErrorMessage;

  bool isLoading = true;

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
    final status = await checkConnection();
    if (status == Operation.failed) return;
    setState(() => emailErrorMessage = null);
    if (!_signupFormKey.currentState!.validate()) return;
    showLoadingDialog(context: context, text: 'Please wait...');
    final result = await FirebaseServices.signupPassenger(
      fullName: fullNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      phoneNumber: phoneNumberController.text.trim(),
    );
    closeLoadingDialog();

    if (result is String) {
      setState(() => emailErrorMessage = result);
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
                    SizedBox(height: Values.height20),
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
                      hintText: 'Enter your email address',
                      prefixIcon: Icons.email_outlined,
                      keyBoardType: TextInputType.emailAddress,
                      errorMessage: emailErrorMessage,
                    ),
                    SizedBox(height: Values.height20),
                    MyTextField(
                      controller: passwordController,
                      labelText: 'Password',
                      hintText: 'Enter new password',
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
                    SizedBox(height: Values.height20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Values.width20),
                      child: termsAndPrivacy(),
                    ),
                    SizedBox(height: Values.height20),
                    Hero(
                      tag: ButtonsHero.elevated,
                      child: MyElevatedButton(
                        onPressed: signupPassenger,
                        child: const MyText(text: 'Accept & Continue'),
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
              const Text("Already have an account? "),
              MyTextButton(onPressed: toLoginPage, text: 'Login here'),
            ],
          ),
        ],
      ),
    );
  }

  RichText termsAndPrivacy() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'By creating an account, you are agreeing to our\n',
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyText2!.color,
        ),
        children: [
          TextSpan(
            text: 'Terms of Services',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontFamily: 'Bolt-Bold',
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    content: const MyText(text: 'Hero you go a terms'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Values.radius30 - 10),
                    ),
                    actions: [
                      MyElevatedButton(
                        child: const MyText(text: 'I agree'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                );
              },
          ),
          TextSpan(
            text: ' and ',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyText2!.color,
            ),
          ),
          TextSpan(
            text: 'Privacy Policy',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontFamily: 'Bolt-Bold',
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    content: const MyText(text: 'Hero you go a privacy'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Values.radius30 - 10),
                    ),
                    actions: [
                      MyElevatedButton(
                        child: const MyText(text: 'I agree'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                );
              },
          ),
        ],
      ),
    );
  }

  void closeLoadingDialog() => Navigator.of(context).pop();
  void toLoginPage() => Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
  void toHomePage() => Navigator.of(context).pushNamedAndRemoveUntil(
        HomePage.routeName,
        (context) => false,
      );
}
