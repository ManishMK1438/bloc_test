import 'dart:io';

import 'package:bloc_test/app_blocs/screen_blocs/content_blocs/upload_reel_bloc/reel_bloc.dart';
import 'package:bloc_test/app_blocs/screen_blocs/content_blocs/upload_reel_bloc/upload_reel_states.dart';
import 'package:bloc_test/app_widgets/loader/app_loader.dart';
import 'package:bloc_test/screens/screen_widgets/upload_reel_screen_widgets/selected_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../app_blocs/screen_blocs/content_blocs/upload_reel_bloc/uplaod_reel_events.dart';
import '../../app_widgets/app_bar.dart';
import '../../app_widgets/buttons/buttons.dart';
import '../../app_widgets/snackbars/app_snackbars.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/decorations/text_field_decoration.dart';
import '../../utils/fonts.dart';
import '../../utils/strings.dart';

class AddShortsScreen extends StatefulWidget {
  AddShortsScreen({super.key});

  @override
  State<AddShortsScreen> createState() => _AddShortsScreenState();
}

class _AddShortsScreenState extends State<AddShortsScreen> {
  final _formKey = GlobalKey<FormState>();

  final _descController = TextEditingController();

  File? _selectedVideo;

  final _picker = ImagePicker();

  File? _thumbnail;

  _fieldsEntered(context) {
    BlocProvider.of<UploadReelBloc>(context).add(ReelFieldEnteredEvent(
        desc: _descController.text.trim(),
        video: _selectedVideo,
        thumbnail: _thumbnail));
  }

  Widget _selectVideoButton(context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppButtons().secondaryButton(
              text: AppStrings.selectVideo,
              onTap: () async {
                XFile? video = await _picker.pickVideo(
                    source: ImageSource.gallery, maxDuration: reelDuration);
                if (video != null) {
                  _selectedVideo = File(video.path);
                  _fieldsEntered(context);
                }
              },
              padding: const EdgeInsets.symmetric(horizontal: 30)),
          const SizedBox(
            height: 10,
          ),
          Text(
            AppStrings.selectVideoToPost,
            style: Fonts().inter(size: 16),
          )
        ],
      ),
    );
  }

  Widget _selectImgContainer() {
    return AspectRatio(
        aspectRatio: 1,
        child: BlocBuilder<UploadReelBloc, UploadReelState>(
          builder: (context, state) {
            print(state.status);
            /*if (state.status == UploadReelStatus.initial) {
              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(defaultRadius),
                    border: Border.all(color: disabledButtonTextColor)),
                child: _selectImgButton(context),
              );
            } else*/
            if (state.status == UploadReelStatus.videoSelected ||
                state.status == UploadReelStatus.valid ||
                state.status == UploadReelStatus.loading) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(defaultRadius),
                child: SelectedVideoPlayerWidget(
                  video: _selectedVideo!,
                ),
              );
            } else {
              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(defaultRadius),
                    border: Border.all(color: disabledButtonTextColor)),
                child: _selectVideoButton(context),
              );
              /*return ClipRRect(
                borderRadius: BorderRadius.circular(defaultRadius),
                child: Image.file(
                  _selectedVideo!,
                  fit: BoxFit.cover,
                ),
              );*/
            }
          },
        ));
  }

  Widget _thumbnailWidget(BuildContext context) {
    return BlocBuilder<UploadReelBloc, UploadReelState>(
        buildWhen: (previous, current) {
      if (current.status == UploadReelStatus.initial) {
        return false;
      } else {
        return true;
      }
    }, builder: (context, state) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
              onPressed: () {
                _picker.pickImage(source: ImageSource.gallery).then((file) {
                  if (file != null) {
                    _thumbnail = File(file.path);
                    _fieldsEntered(context);
                    setState(() {});
                  }
                });
              },
              child: Text(
                AppStrings.addThumbnail,
                style: Fonts().inter(size: 16),
              )),
          if (_thumbnail != null)
            if (state.status != UploadReelStatus.initial)
              SizedBox(
                width: 150,
                height: 75,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    _thumbnail!,
                    fit: BoxFit.fill,
                  ),
                ),
              )
        ],
      );
    });
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
    return BlocConsumer<UploadReelBloc, UploadReelState>(
      listener: (context, state) {
        if (state.status == UploadReelStatus.error) {
          CustomSnackBar().customErrorSnackBar(context, state.error);
        } else if (state.status == UploadReelStatus.success) {
          CustomSnackBar()
              .customSuccessSnackBar(context, AppStrings.postedSuccessfully);
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        if (state.status == UploadReelStatus.initial ||
            state.status == UploadReelStatus.videoSelected ||
            state.status == UploadReelStatus.thumbnailSelected) {
          return AppButtons()
              .primaryButton(text: AppStrings.post, color: secondaryColor);
        } else if (state.status == UploadReelStatus.loading) {
          return const ButtonLoader();
        }
        return AppButtons().primaryButton(
            text: AppStrings.post,
            color: secondaryColor,
            onTap: () {
              BlocProvider.of<UploadReelBloc>(context).add(ReelBtnPressedEvent(
                  desc: _descController.text.trim(),
                  video: _selectedVideo!,
                  thumbnail: _thumbnail));
            });
      },
    );
    return Container();
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
            AppStrings.uploadReel,
            style: Fonts().vigaFont(size: 20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(appPadding),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              _descriptionField(context),
              const SizedBox(
                height: 10,
              ),
              _thumbnailWidget(context),
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
    );
  }
}
