import 'package:bloc_test/app_blocs/screen_blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:bloc_test/app_blocs/screen_blocs/sign_up_bloc/sign_up_states.dart';
import 'package:bloc_test/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_blocs/screen_blocs/sign_up_bloc/sign_up_events.dart';
import '../../../app_widgets/buttons/buttons.dart';
import '../../../utils/colors.dart';
import '../../../utils/decorations/text_field_decoration.dart';
import '../../../utils/fonts.dart';
import '../../../utils/strings.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cPasswordController = TextEditingController();
  final _numberController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _addDataToBloc(BuildContext context) {
    BlocProvider.of<SignUpBloc>(context).add(SignUpFieldsEnteredEvent(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _numberController.text.trim(),
        password: _passwordController.text.trim(),
        confirmPassword: _cPasswordController.text.trim()));
  }

  Widget _upperText() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppStrings.signUpHere,
          style: Fonts().inter(size: 40),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(AppStrings.detailsAreSafeWithUs, style: Fonts().inter(size: 16))
      ],
    );
  }

  Widget _signUpFields(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      // if(state is )
      return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              onChanged: (val) {
                _addDataToBloc(context);
              },
              controller: _nameController,
              validator: (val) {
                if (_nameController.text.trim().isEmpty) {
                  return AppStrings.fieldCannotBeEmpty;
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.name,
              decoration:
                  TextFieldDecoration().decoration(labelText: AppStrings.name),
            ),
            const SizedBox(
              height: 20,
            ),
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
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
              ],
              controller: _numberController,
              onChanged: (val) {
                _addDataToBloc(context);
              },
              validator: (val) {
                if (_numberController.text.trim().isEmpty) {
                  return AppStrings.fieldCannotBeEmpty;
                } else {
                  return null;
                }
              },
              keyboardType: const TextInputType.numberWithOptions(),
              decoration: TextFieldDecoration()
                  .decoration(labelText: AppStrings.phoneNumber),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
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
                      },
                      icon: const Icon(Icons.visibility_off))),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _cPasswordController,
              obscureText: true,
              onChanged: (val) {
                _addDataToBloc(context);
              },
              validator: (val) {
                if (_cPasswordController.text.trim().isEmpty ||
                    _cPasswordController.text.trim() !=
                        _passwordController.text.trim()) {
                  return AppStrings.enterValidPassword;
                } else {
                  return null;
                }
              },
              keyboardAppearance: Brightness.dark,
              decoration: TextFieldDecoration().decoration(
                  labelText: AppStrings.confirmPassword,
                  suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.visibility_off))),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    });
  }

  Widget _signUpButton(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      if (state is SignUpValidState) {
        return AppButtons().primaryButton(
            text: AppStrings.register,
            color: secondaryColor,
            onTap: () {
              if (_formKey.currentState!.validate()) {
                /*AppNavigation.pushAndRemove(
                    context: context,
                    screen: BlocProvider(
                      create: (context) => TabsBloc(),
                      child: TabsScreen(),
                    ));*/
                print("valid");
              } else {
                print("inValid");
              }
            });
      } else {
        return AppButtons().primaryButton(
            text: AppStrings.register, color: secondaryColor, onTap: null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(appPadding),
          child: SizedBox(
            width: width,
            height: height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _upperText(),
                _signUpFields(context),
                _signUpButton(context)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
