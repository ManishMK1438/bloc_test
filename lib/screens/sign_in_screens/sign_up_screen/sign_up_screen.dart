import 'package:bloc_test/app_blocs/screen_blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:bloc_test/app_blocs/screen_blocs/sign_up_bloc/sign_up_states.dart';
import 'package:bloc_test/app_widgets/loader/app_loader.dart';
import 'package:bloc_test/app_widgets/snackbars/app_snackbars.dart';
import 'package:bloc_test/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../app_blocs/screen_blocs/sign_up_bloc/sign_up_events.dart';
import '../../../app_blocs/screen_blocs/tabs_bloc/tabs_bloc.dart';
import '../../../app_widgets/buttons/buttons.dart';
import '../../../utils/colors.dart';
import '../../../utils/decorations/text_field_decoration.dart';
import '../../../utils/fonts.dart';
import '../../../utils/navigation_file.dart';
import '../../../utils/strings.dart';
import '../../dashboard_screens/tabs_screen.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _cPasswordController = TextEditingController();

  final _numberController = TextEditingController();

  final _nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _obscure = true;
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
          const SizedBox(height: 20),
          TextFormField(
            controller: _cPasswordController,
            obscureText: _obscure,
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
                    onPressed: () {
                      setState(() {
                        _obscure = !_obscure;
                      });
                    },
                    icon: _obscure
                        ? const FaIcon(FontAwesomeIcons.eyeSlash)
                        : const FaIcon(FontAwesomeIcons.eye))),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _signUpButton(BuildContext context) {
    return BlocConsumer<SignUpBloc, SignUpState>(listener: (context, state) {
      if (state is SignUpSuccessState) {
        AppNavigation.pushAndRemove(
            context: context,
            screen: BlocProvider(
              create: (context) => TabsBloc(),
              child: TabsScreen(),
            ));
        CustomSnackBar()
            .customSuccessSnackBar(context, AppStrings.signedUpSuccessfully);
      } else if (state is SignUpErrorState) {
        CustomSnackBar().customErrorSnackBar(context, state.error);
      }
    }, builder: (context, state) {
      if (state is SignUpInitialState) {
        return AppButtons().primaryButton(
            text: AppStrings.register, color: secondaryColor, onTap: null);
      } else if (state is SignUpLoadingState) {
        return const ButtonLoader();
      } else {
        return AppButtons().primaryButton(
            text: AppStrings.register,
            color: secondaryColor,
            onTap: () {
              if (_formKey.currentState!.validate()) {
                BlocProvider.of<SignUpBloc>(context).add(SignUpBtnPressedEvent(
                    name: _nameController.text.trim(),
                    email: _emailController.text.trim(),
                    phoneNumber: _numberController.text.trim(),
                    password: _passwordController.text.trim(),
                    confirmPassword: _cPasswordController.text.trim()));
                print("valid");
              } else {
                print("inValid");
              }
            });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _numberController.dispose();
    _passwordController.dispose();
    _cPasswordController.dispose();
    super.dispose();
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
