import 'package:bloc_test/app_blocs/screen_blocs/login_bloc/login_bloc.dart';
import 'package:bloc_test/app_blocs/screen_blocs/login_bloc/login_events.dart';
import 'package:bloc_test/app_blocs/screen_blocs/login_bloc/login_states.dart';
import 'package:bloc_test/app_blocs/screen_blocs/tabs_bloc/tabs_bloc.dart';
import 'package:bloc_test/app_widgets/buttons/buttons.dart';
import 'package:bloc_test/app_widgets/loader/app_loader.dart';
import 'package:bloc_test/screens/sign_in_screens/sign_up_screen/sign_up_screen.dart';
import 'package:bloc_test/utils/constants.dart';
import 'package:bloc_test/utils/decorations/text_field_decoration.dart';
import 'package:bloc_test/utils/fonts.dart';
import 'package:bloc_test/utils/navigation_file.dart';
import 'package:bloc_test/utils/strings.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../app_blocs/screen_blocs/sign_up_bloc/sign_up_bloc.dart';
import '../../../app_widgets/snackbars/app_snackbars.dart';
import '../../../utils/colors.dart';
import '../../dashboard_screens/tabs_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool _obscure = true;

  _addDataToBloc(BuildContext context) {
    BlocProvider.of<LoginBloc>(context).add(LoginFieldsEnteredEvent(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    ));
  }

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
            onChanged: (val) {
              _addDataToBloc(context);
            },
            validator: (val) {
              if (_emailController.text.trim().isEmpty ||
                  !_emailController.text.trim().contains("@")) {
                return AppStrings.enterValidEmail;
              } else {
                return null;
              }
            },
            keyboardType: TextInputType.emailAddress,
            decoration:
                TextFieldDecoration().decoration(labelText: AppStrings.email),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscure,
            onChanged: (val) {
              _addDataToBloc(context);
            },
            validator: (val) {
              if (_passwordController.text.trim().isEmpty) {
                return AppStrings.enterValidPassword;
              } else {
                return null;
              }
            },
            keyboardAppearance: Brightness.dark,
            decoration: TextFieldDecoration().decoration(
                labelText: AppStrings.password,
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscure = !_obscure;
                      });
                    },
                    icon: _obscure
                        ? const FaIcon(FontAwesomeIcons.eyeSlash)
                        : const FaIcon(FontAwesomeIcons.eye))),
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
                    context: context,
                    screen: BlocProvider(
                      child: SignUpScreen(),
                      create: (context) => SignUpBloc(),
                    )),
              text: AppStrings.register,
              style: Fonts().inter(size: 18, color: primaryColor))
        ]));
  }

  Widget _loginButton(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(listener: (context, state) {
      if (state is LoginSuccessState) {
        AppNavigation.pushAndRemove(
            context: context,
            screen: BlocProvider(
              create: (context) => TabsBloc(),
              child: TabsScreen(),
            ));
        CustomSnackBar()
            .customSuccessSnackBar(context, AppStrings.loggedInSuccessfully);
      } else if (state is LoginErrorState) {
        CustomSnackBar().customErrorSnackBar(context, state.error);
      }
    }, builder: (context, state) {
      if (state is LoginInitialState) {
        return AppButtons()
            .primaryButton(text: AppStrings.login, color: secondaryColor);
      } else if (state is LoginLoadingState) {
        return const ButtonLoader();
      }
      return AppButtons().primaryButton(
          text: AppStrings.login,
          color: secondaryColor,
          onTap: () {
            if (_formKey.currentState!.validate()) {
              BlocProvider.of<LoginBloc>(context).add(LoginBtnPressedEvent(
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim()));
            } else {}
          });
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
            child: SizedBox(
              width: width,
              height: height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _upperText(),
                  _loginFields(),
                  _loginButton(context),
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
