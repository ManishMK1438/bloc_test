import 'package:bloc_test/app_widgets/buttons/buttons.dart';
import 'package:bloc_test/screens/sign_in_screens/sign_up_screen/sign_up_screen.dart';
import 'package:bloc_test/utils/constants.dart';
import 'package:bloc_test/utils/decorations/text_field_decoration.dart';
import 'package:bloc_test/utils/fonts.dart';
import 'package:bloc_test/utils/navigation_file.dart';
import 'package:bloc_test/utils/strings.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Widget _upperText() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppStrings.welcomeBack,
          style: Fonts().inter(size: 40),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(AppStrings.weMissedYou, style: Fonts().inter(size: 16))
      ],
    );
  }

  Widget _loginFields() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _emailController,
            validator: (val) {
              if (_emailController.text.trim().isEmpty ||
                  !_emailController.text.trim().contains("@")) {
                return AppStrings.enterValidEmail;
              } else {
                return null;
              }
            },
            keyboardType: TextInputType.emailAddress,
            decoration: TextFieldDecoration().decoration(labelText: "Email"),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            validator: (val) {
              if (_passwordController.text.trim().isEmpty) {
                return AppStrings.enterValidPassword;
              } else {
                return null;
              }
            },
            keyboardAppearance: Brightness.dark,
            decoration: TextFieldDecoration().decoration(
                labelText: "Password",
                suffixIcon: IconButton(
                    onPressed: () {}, icon: const Icon(Icons.visibility_off))),
          ),
          const SizedBox(
            height: 10,
          ),
          _forgotPasswordButton()
        ],
      ),
    );
  }

  Widget _forgotPasswordButton() {
    return TextButton(
        onPressed: () {},
        child: Text(
          AppStrings.forgotPassword,
          style: Fonts().inter(size: 18, color: errorColor),
        ));
  }

  Widget _goToSignUp(BuildContext context) {
    return Text.rich(TextSpan(
        text: AppStrings.newHere,
        style: Fonts().inter(size: 18),
        children: [
          TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () => AppNavigation.push(
                    context: context, screen: const SignUpScreen()),
              text: AppStrings.register,
              style: Fonts().inter(size: 18, color: primaryColor))
        ]));
  }

  Widget _loginButton() {
    return AppButtons().primaryButton(
        text: AppStrings.login,
        color: secondaryColor,
        onTap: () {
          if (_formKey.currentState!.validate()) {
            print("valid");
          } else {
            print("inValid");
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(appPadding),
            child: Container(
              width: width,
              height: height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _upperText(),
                  _loginFields(),
                  _loginButton(),
                  _goToSignUp(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}