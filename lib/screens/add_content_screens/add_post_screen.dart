import 'dart:io';

import 'package:bloc_test/app_blocs/screen_blocs/content_blocs/post_screen_bloc/post_bloc.dart';
import 'package:bloc_test/app_blocs/screen_blocs/content_blocs/post_screen_bloc/post_events.dart';
import 'package:bloc_test/app_blocs/screen_blocs/content_blocs/post_screen_bloc/post_states.dart';
import 'package:bloc_test/app_widgets/app_bar.dart';
import 'package:bloc_test/app_widgets/buttons/buttons.dart';
import 'package:bloc_test/app_widgets/snackbars/app_snackbars.dart';
import 'package:bloc_test/utils/constants.dart';
import 'package:bloc_test/utils/fonts.dart';
import 'package:bloc_test/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../app_widgets/loader/app_loader.dart';
import '../../utils/colors.dart';
import '../../utils/decorations/text_field_decoration.dart';

class AddPostScreen extends StatelessWidget {
  AddPostScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();
  File? _selectedImg;
  final _picker = ImagePicker();

  _fieldsEntered(context) {
    BlocProvider.of<PostBloc>(context).add(PostFieldEnteredEvent(
        postDesc: _descController.text.trim(), img: _selectedImg));
  }

  Widget _selectImgButton(context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppButtons().secondaryButton(
              text: AppStrings.selectImage,
              onTap: () async {
                XFile? img =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (img != null) {
                  _selectedImg = File(img.path);
                  _fieldsEntered(context);
                }
              },
              padding: const EdgeInsets.symmetric(horizontal: 30)),
          const SizedBox(
            height: 10,
          ),
          Text(
            AppStrings.selectImageToPost,
            style: Fonts().inter(size: 16),
          )
        ],
      ),
    );
  }

  Widget _selectImgContainer() {
    return AspectRatio(
        aspectRatio: 1.5,
        child: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state is PostInitialState) {
              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(defaultRadius),
                    border: Border.all(color: disabledButtonTextColor)),
                child: _selectImgButton(context),
              );
            } else if (state is PostImgSelectedState) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(defaultRadius),
                child: Image.file(
                  _selectedImg!,
                  fit: BoxFit.cover,
                ),
              );
            } else {
              return ClipRRect(
                borderRadius: BorderRadius.circular(defaultRadius),
                child: Image.file(
                  _selectedImg!,
                  fit: BoxFit.cover,
                ),
              );
            }
          },
        ));
  }

  Widget _descriptionField(BuildContext context) {
    return Form(
      key: _formKey,
      child: TextFormField(
        controller: _descController,
        onChanged: (val) {
          _fieldsEntered(context);
        },
        validator: (val) {
          if (_descController.text.trim().isEmpty) {
            return AppStrings.fieldCannotBeEmpty;
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.name,
        maxLines: 5,
        decoration: TextFieldDecoration().decoration(
            labelText: AppStrings.postDesc, borer: InputBorder.none),
      ),
    );
  }

  Widget _postButton() {
    return BlocConsumer<PostBloc, PostState>(
      listener: (context, state) {
        if (state is PostErrorState) {
          CustomSnackBar().customErrorSnackBar(context, state.error);
        } else if (state is PostSuccessState) {
          CustomSnackBar()
              .customSuccessSnackBar(context, AppStrings.postedSuccessfully);
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        if (state is PostInitialState || state is PostImgSelectedState) {
          return AppButtons()
              .primaryButton(text: AppStrings.post, color: secondaryColor);
        } else if (state is PostLoadingState) {
          return const ButtonLoader();
        }
        return AppButtons().primaryButton(
            text: AppStrings.post,
            color: secondaryColor,
            onTap: () {
              BlocProvider.of<PostBloc>(context).add(PostBtnPressedEvent(
                  postDesc: _descController.text.trim(), img: _selectedImg));
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          elevation: 0,
          title: Text(
            AppStrings.createPost,
            style: Fonts().vigaFont(size: 20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(appPadding),
          child: SizedBox(
            width: width,
            height: height,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                _descriptionField(context),
                const SizedBox(
                  height: 30,
                ),
                _selectImgContainer(),
                const SizedBox(
                  height: 60,
                ),
                _postButton()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
