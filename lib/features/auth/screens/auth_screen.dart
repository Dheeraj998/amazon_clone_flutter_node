import 'package:amazon_clone/common/widgets/bottom_bar.dart';
import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/common/widgets/custom_textfield.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';

enum Auth {
  signin,
  signup,
}

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Auth _auth = Auth.signup;
  final _signupFormKey = GlobalKey<FormState>();
  final _signinFormKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passWordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final AuthService authService = AuthService();

  void signUpUser() {
    authService.signUpUser(
        context: context,
        email: _emailController.text,
        password: _passWordController.text,
        name: _nameController.text);
  }

  void signInUser(BuildContext context) {
    authService.signInUser(
        context: context,
        email: _emailController.text,
        password: _passWordController.text);
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passWordController.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.greyBackgroundCOlor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text(
                  'welcome',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                ListTile(
                  tileColor: _auth == Auth.signup
                      ? GlobalVariables.backgroundColor
                      : GlobalVariables.greyBackgroundCOlor,
                  title: const Text(
                    'create account',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  leading: Radio(
                      activeColor: GlobalVariables.secondaryColor,
                      value: Auth.signup,
                      groupValue: _auth,
                      onChanged: (Auth? val) {
                        setState(() {
                          _auth = val!;
                        });
                      }),
                ),
                if (_auth == Auth.signup)
                  Form(
                    key: _signupFormKey,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: GlobalVariables.backgroundColor,
                      child: Column(
                        children: [
                          CustomTextField(
                              controller: _nameController, hintText: " Name"),
                          const SizedBox(height: 10),
                          CustomTextField(
                              controller: _emailController, hintText: " Email"),
                          const SizedBox(height: 10),
                          CustomTextField(
                              controller: _passWordController,
                              hintText: " Password"),
                          const SizedBox(height: 10),
                          CustomButton(
                              text: "signup",
                              onTap: () {
                                if (_signupFormKey.currentState!.validate()) {
                                  signUpUser();
                                }
                              })
                        ],
                      ),
                    ),
                  ),
                ListTile(
                  title: const Text(
                    'SignIn',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  leading: Radio(
                      activeColor: GlobalVariables.secondaryColor,
                      value: Auth.signin,
                      groupValue: _auth,
                      onChanged: (Auth? val) {
                        setState(() {
                          _auth = val!;
                        });
                      }),
                ),
                if (_auth == Auth.signin)
                  Form(
                    key: _signinFormKey,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: GlobalVariables.backgroundColor,
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          CustomTextField(
                              controller: _emailController, hintText: " Email"),
                          const SizedBox(height: 10),
                          CustomTextField(
                              controller: _passWordController,
                              hintText: " Password"),
                          const SizedBox(height: 10),
                          CustomButton(
                              text: "signin",
                              onTap: () {
                                if (_signinFormKey.currentState!.validate()) {
                                  signInUser(context);
                                }
                              })
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
