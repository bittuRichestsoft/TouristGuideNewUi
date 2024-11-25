// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:io';
import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/app_constants/textfield_decoration.dart';
import 'package:Siesta/common_widgets/common_button.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:Siesta/response_pojo/add_image_response.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:stacked/stacked.dart';
import 'package:Siesta/view_models/guide_models/guideGalleryModel.dart';

class UploadImagesSheet extends StatefulWidget {
  UploadImagesSheet({Key? key, int? selIndex, dynamic modelRef})
      : super(key: key) {
    sel_index = selIndex;
    model_Ref = modelRef;
    debugPrint('sel_indexsel_indexsel_index${sel_index}');
  }
  int? sel_index;
  dynamic model_Ref;
  @override
  State<UploadImagesSheet> createState() => _UploadImagesSheetState();
}

class _UploadImagesSheetState extends State<UploadImagesSheet> {
  final ImagePicker picker = ImagePicker();
  List<XFile> selectedImageFile = [];
  bool isButtonEnable = false;
  TextEditingController titleController = TextEditingController();
  List<ImageSelectionPojo> imageSelectionList = [];
  var imgList = [];
  var imageToDelete = [];
  int? title_id;
  void initState() {
    super.initState();
    if (widget.sel_index != -1) {
      titleController.text =
          widget.model_Ref.galleryImageList[widget.sel_index].destinationTitle;
      imgList = widget.model_Ref.galleryImageList[widget.sel_index].fileUrls;
      title_id =
          widget.model_Ref.galleryImageList[widget.sel_index].fileUrls[0].id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GuideGalleryModel>.reactive(
        viewModelBuilder: () => GuideGalleryModel(),
        onViewModelReady: (model) => model.initialised,
        builder: (context, model, child) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(MediaQuery.of(context).size.width *
                AppSizes().widgetSize.horizontalPadding),
            children: [
              Center(
                child: Container(
                  height: 4,
                  width: 50,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(5)),
                ),
              ),
              UiSpacer.verticalSpace(
                  space: AppSizes().widgetSize.normalPadding, context: context),
              Center(
                  child: TextView.normalText(
                      context: context,
                      fontFamily: AppFonts.nunitoSemiBold,
                      textSize: AppSizes().fontSize.headingTextSize,
                      textColor: AppColor.lightBlack,
                      text: AppStrings().uploadImages)),
              UiSpacer.verticalSpace(
                  space: AppSizes().widgetSize.normalPadding, context: context),
              Divider(
                color: AppColor.disableColor,
              ),
              UiSpacer.verticalSpace(
                  space: AppSizes().widgetSize.mediumPadding, context: context),
              addTitleField(),
              UiSpacer.verticalSpace(
                  space: AppSizes().widgetSize.smallPadding, context: context),
              TextView.normalText(
                  context: context,
                  fontFamily: AppFonts.nunitoMedium,
                  textSize: AppSizes().fontSize.simpleFontSize,
                  textColor: AppColor.lightBlack,
                  text: AppStrings().uploadImages),
              UiSpacer.verticalSpace(
                  space: AppSizes().widgetSize.smallPadding, context: context),
              addImagesView(),
              UiSpacer.verticalSpace(
                  space: AppSizes().widgetSize.normalPadding, context: context),
              imgList.isNotEmpty
                  ? uploadedImagesGrid(widget.model_Ref)
                  : const SizedBox(),
              UiSpacer.verticalSpace(
                  space: AppSizes().widgetSize.normalPadding, context: context),
              selectedImageFile.isNotEmpty
                  ? selectedImagesGrid()
                  : const SizedBox(),
              UiSpacer.verticalSpace(
                  space: AppSizes().widgetSize.smallPadding, context: context),
              uploadButton(model),
            ],
          );
        });
  }

  Widget addTitleField() {
    return SizedBox(
      child: TextFormField(
        controller: titleController,
        maxLength: 200,
        onChanged: (value) {
          setState(() {
            if (value.replaceAll(" ", "") == "" && selectedImageFile.isEmpty) {
              isButtonEnable = false;
            } else if (value.replaceAll(" ", "") != "" &&
                selectedImageFile.isNotEmpty) {
              isButtonEnable = true;
            } else {
              isButtonEnable = false;
            }
          });
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == "" || value == null) {
            isButtonEnable = false;
            return "Please enter tittle";
          } else if (value.trim().isEmpty) {
            isButtonEnable = false;
            return AppStrings().blankSpace;
          }
          return null;
        },
        textAlignVertical: TextAlignVertical.center,
        textCapitalization: TextCapitalization.sentences,
        textAlign: TextAlign.start,
        style: TextStyle(
            color: AppColor.lightBlack,
            fontFamily: AppFonts.nunitoRegular,
            fontSize: MediaQuery.of(context).size.height *
                AppSizes().fontSize.simpleFontSize),
        decoration: TextFieldDecoration.simpletextFieldDecoration(
            context, AppStrings().addTitle, false),
        enableInteractiveSelection: true,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget addImagesView() {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet<void>(
          useSafeArea: false,
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(MediaQuery.of(context).size.width *
                  AppSizes().widgetSize.largeBorderRadius),
            ),
          ),
          builder: (BuildContext context) {
            return showImagePicker();
          },
        );
      },
      child: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          decoration: DottedDecoration(
            color: AppColor.hintTextColor,
            shape: Shape.box,
            borderRadius: BorderRadius.circular(2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.height * 0.05,
                  decoration: BoxDecoration(
                      color: AppColor.shadowLocation, shape: BoxShape.circle),
                  child: Image.asset(
                    AppImages().pngImages.icUpload,
                    fit: BoxFit.cover,
                    width: AppSizes().widgetSize.iconWidth,
                    height: AppSizes().widgetSize.iconHeight,
                  )),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                      text: AppStrings().clickToUpload,
                      style: TextStyle(
                          fontFamily: AppFonts.nunitoSemiBold,
                          color: AppColor.appthemeColor,
                          fontSize: MediaQuery.of(context).size.height *
                              AppSizes().fontSize.normalFontSize)),
                  TextSpan(
                      text: AppStrings().dragDrop,
                      style: TextStyle(
                          fontFamily: AppFonts.nunitoSemiBold,
                          color: AppColor.dontHaveTextColor,
                          fontSize: MediaQuery.of(context).size.height *
                              AppSizes().fontSize.normalFontSize),
                      recognizer: TapGestureRecognizer()..onTap = () {}),
                  TextSpan(
                      text: "\n${AppStrings().pngJpg}",
                      style: TextStyle(
                          fontFamily: AppFonts.nunitoRegular,
                          color: AppColor.dontHaveTextColor,
                          fontSize: MediaQuery.of(context).size.height *
                              AppSizes().fontSize.xsimpleFontSize),
                      recognizer: TapGestureRecognizer()..onTap = () {}),
                ]),
              )
            ],
          )),
    );
  }

  Widget uploadButton(model) {
    return widget.sel_index == -1
        ? isButtonEnable == false
            ? CommonButton.commonBoldTextButton(
                context: context,
                text: AppStrings().uploadText,
                onPressed: () {})
            : model.isBusy == false
                ? CommonButton.commonThemeColorButton(
                    context: context,
                    text: AppStrings().uploadText,
                    onPressed: () {
                      ImageSelectionPojo imageSelectionPojo =
                          ImageSelectionPojo(
                              file: selectedImageFile,
                              title: titleController.text.toString());
                      imageSelectionList.add(imageSelectionPojo);
                      debugPrint(imageSelectionList.toString());
                      model.uploadGuidePhoto(context, imageSelectionList);
                    })
                : SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: Center(
                      child: CircularProgressIndicator(
                          color: AppColor.appthemeColor),
                    ),
                  )
        : model.isBusy == false
            ? CommonButton.commonThemeColorButton(
                context: context,
                text: AppStrings().updateText,
                onPressed: () {
                  ImageSelectionPojo imageSelectionPojo = ImageSelectionPojo(
                      file: selectedImageFile,
                      title: titleController.text.toString());
                  imageSelectionList.add(imageSelectionPojo);
                  debugPrint(imageSelectionList.toString());
                  debugPrint(imageToDelete.toString());
                  debugPrint(
                      "titleController.texttitleController.text${titleController.text}");
                  debugPrint("title_idtitle_id${title_id.toString()}");

                  if (titleController.text != "") {
                    model.updateGuidePhoto(context, imageSelectionList,
                        title_id, titleController.text, imageToDelete);
                  } else {
                    GlobalUtility.showToastBottom(
                        context, "Please enter tittle ");
                  }
                })
            : SizedBox(
                width: MediaQuery.of(context).size.width * 0.1,
                child: Center(
                  child:
                      CircularProgressIndicator(color: AppColor.appthemeColor),
                ),
              );
  }

  Widget selectedImagesGrid() {
    return GridView.count(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.00),
        physics: const ScrollPhysics(),
        childAspectRatio: 1.1,
        shrinkWrap: true,
        crossAxisCount: 4,
        crossAxisSpacing: MediaQuery.of(context).size.width * 0.015,
        mainAxisSpacing: MediaQuery.of(context).size.width * 0.015,
        children: List.generate(selectedImageFile.length, (index) {
          return Container(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(3),
                  height: 120,
                  width: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(
                        MediaQuery.of(context).size.width *
                            AppSizes().widgetSize.smallBorderRadius)),
                    child: SizedBox(
                      height: 170,
                      width: 170,
                      child: Image.file(
                        File(selectedImageFile[index].path.toString()),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Positioned(
                    right: 10,
                    child: GestureDetector(
                      onTap: () => {
                        debugPrint(selectedImageFile[index].path.toString()),
                        imageToDelete
                            .add(selectedImageFile[index].path.toString()),
                        debugPrint(imageToDelete.toString()),
                        setState(() {
                          selectedImageFile.removeAt(index);
                          if (selectedImageFile.isEmpty) {
                            isButtonEnable = false;
                          }
                        })
                      },
                      child: Center(
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Image.asset(AppImages().pngImages.closeCircle),
                        ),
                      ),
                    ))
              ],
            ),
          );
        }));
  }

  Widget uploadedImagesGrid(model) {
    return GridView.count(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.00),
        physics: const ScrollPhysics(),
        childAspectRatio: 1.1,
        shrinkWrap: true,
        crossAxisCount: 4,
        crossAxisSpacing: MediaQuery.of(context).size.width * 0.015,
        mainAxisSpacing: MediaQuery.of(context).size.width * 0.015,
        children: List.generate(imgList.length, (index) {
          return Container(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(3),
                  height: 120,
                  width: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(
                        MediaQuery.of(context).size.width *
                            AppSizes().widgetSize.smallBorderRadius)),
                    child: SizedBox(
                      height: 170,
                      width: 170,
                      child: Image.network(
                        imgList[index].galleryImgUrl,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Positioned(
                    right: 10,
                    child: GestureDetector(
                      onTap: () => {
                        debugPrint(imgList[index].id.toString()),
                        imageToDelete.add(imgList[index].id),
                        debugPrint(imageToDelete.toString()),
                        setState(() {
                          imgList.removeAt(index);
                        })
                      },
                      child: Center(
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Image.asset(AppImages().pngImages.closeCircle),
                        ),
                      ),
                    ))
              ],
            ),
          );
          // ClipRRect(
          //   borderRadius: BorderRadius.all(Radius.circular(
          //       MediaQuery.of(context).size.width *
          //           AppSizes().widgetSize.smallBorderRadius)),
          //   child: Image.network(
          //     widget.model_Ref.galleryImageList[widget.sel_index].fileUrls[index].galleryImgUrl,
          //     fit: BoxFit.fill,
          //   ),
          // );
        }));
  }

  Widget showImagePicker() {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.all(MediaQuery.of(context).size.height *
          AppSizes().widgetSize.horizontalPadding),
      children: [
        Text(
          AppStrings().selectOption,
          style: TextStyle(
              fontFamily: AppFonts.nunitoBold,
              color: AppColor.appthemeColor,
              fontSize: MediaQuery.of(context).size.height *
                  AppSizes().fontSize.headingTextSize),
          textAlign: TextAlign.center,
        ),
        UiSpacer.verticalSpace(
            space: AppSizes().widgetSize.smallPadding, context: context),
        Divider(
          color: AppColor.disableColor,
        ),
        UiSpacer.verticalSpace(
            space: AppSizes().widgetSize.smallPadding, context: context),
        Center(
          child: ListTile(
              tileColor: AppColor.buttonDisableColor,
              dense: true,
              minVerticalPadding: 5.0,
              visualDensity: const VisualDensity(vertical: 1, horizontal: 4),
              leading: Image.asset(
                AppImages().pngImages.icGallery,
                width: AppSizes().widgetSize.iconWidth,
                height: AppSizes().widgetSize.iconHeight,
              ),
              title: Text(
                AppStrings().chooseFromGallery,
                style: TextStyle(
                    fontFamily: AppFonts.nunitoSemiBold,
                    color: AppColor.appthemeColor,
                    fontSize: MediaQuery.of(context).size.height *
                        AppSizes().fontSize.normalFontSize),
              ),
              onTap: () {
                Navigator.pop(context);
                openGallery();
              }),
        ),
        UiSpacer.verticalSpace(
            space: AppSizes().widgetSize.smallPadding, context: context),
        Center(
          child: ListTile(
              tileColor: AppColor.buttonDisableColor,
              dense: true,
              visualDensity: const VisualDensity(vertical: 1, horizontal: 4),
              leading: Icon(
                Icons.photo_camera,
                color: AppColor.appthemeColor,
              ),
              title: Text(
                AppStrings().chooseFromCamera,
                style: TextStyle(
                    fontFamily: AppFonts.nunitoSemiBold,
                    color: AppColor.appthemeColor,
                    fontSize: MediaQuery.of(context).size.height *
                        AppSizes().fontSize.normalFontSize),
              ),
              onTap: () {
                Navigator.pop(context);
                openCamera();
              }),
        ),
        UiSpacer.verticalSpace(
            space: AppSizes().widgetSize.smallPadding, context: context),
        Center(
          child: ListTile(
              dense: true,
              tileColor: AppColor.buttonDisableColor,
              visualDensity: const VisualDensity(vertical: 1, horizontal: 4),
              leading: Icon(
                Icons.clear,
                color: AppColor.appthemeColor,
              ),
              title: Text(
                AppStrings().cancelText,
                style: TextStyle(
                    fontFamily: AppFonts.nunitoSemiBold,
                    color: AppColor.appthemeColor,
                    fontSize: MediaQuery.of(context).size.height *
                        AppSizes().fontSize.normalFontSize),
              ),
              onTap: () {
                Navigator.pop(context);
              }),
        ),
      ],
    );
  }

  openGallery() async {
    List<XFile>? imagesList = await picker.pickMultiImage(imageQuality: 100);
    if (imagesList.isNotEmpty) {
      if (imagesList.length > 30) {
        GlobalUtility.showToastBottom(
            context, "Please select images less than 30");
      } else {
        setState(() {
          selectedImageFile = imagesList.toSet().toList();
          if (titleController.text.replaceAll(" ", "") != "" &&
              selectedImageFile.isNotEmpty) {
            isButtonEnable = true;
          } else {
            isButtonEnable = false;
          }
        });
      }
    }
  }

  openCamera() async {
    XFile? photo = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      selectedImageFile.add(photo!);
      if (titleController.text.replaceAll(" ", "") != "" &&
          selectedImageFile.isNotEmpty) {
        isButtonEnable = true;
      } else {
        isButtonEnable = false;
      }
    });
  }

  bool validate(model) {
    String title = model.titleController.text;
    if (title == "") {
      GlobalUtility.showToastBottom(context, AppStrings().enterTitle);
      return false;
    }
    return true;
  }
}
