import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:Siesta/main.dart';
import 'package:Siesta/utility/globalUtility.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../app_constants/app_fonts.dart';
import '../app_constants/app_images.dart';
import '../app_constants/app_sizes.dart';
import '../app_constants/app_strings.dart';

class CommonImageView {
  static Widget largeSvgImageView({String? imagePath}) =>
      Center(child: SvgPicture.asset(imagePath!));

  static Widget largeAssestImageView({String? imagePath, BuildContext? ctx}) =>
      Center(
          child: Image.asset(
        imagePath!,
        width: MediaQuery.of(ctx!).size.width * 0.5,
        height: MediaQuery.of(ctx).size.height * 0.2,
      ));

  static Widget rectangleNetworkImage(
          {String? imgUrl = '',
          double? height,
          double? width,
          Color? bgColor}) =>
      CachedNetworkImage(
        imageUrl: imgUrl!,
        fit: BoxFit.cover,
        imageBuilder: (context, imageProvider) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: AppColor.appthemeColor,
            // shape: BoxShape.circle,
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        // placeholder: (context, url) => GlobalUtility.showLoader(context),
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: AppColor.greyColor500.withOpacity(0.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: SvgPicture.asset(
              AppImages().svgImages.icPlaceHolder,
              color: AppColor.greyColor,
            ),
          ),
        ),
      );

  static roundNetworkImage(
          {String? imgUrl = '',
          double? height,
          double? width,
          Color? bgColor}) =>
      CachedNetworkImage(
        imageUrl: imgUrl!,
        fit: BoxFit.cover,
        imageBuilder: (context, imageProvider) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: AppColor.appthemeColor,
            shape: BoxShape.circle,
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        // placeholder: (context, url) => GlobalUtility.showLoader(context),
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: AppColor.appthemeColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: SvgPicture.asset(AppImages().svgImages.ivProfilePlaceholder),
          ),
        ),
      );

  static chooseImageDialog(
          {BuildContext? context,
          VoidCallback? onTapGallery,
          VoidCallback? onTapCamera}) =>
      showModalBottomSheet<void>(
        useSafeArea: false,
        context: context!,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(MediaQuery.of(context).size.width *
                AppSizes().widgetSize.largeBorderRadius),
          ),
        ),
        builder: (BuildContext context) {
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
                    visualDensity:
                        const VisualDensity(vertical: 1, horizontal: 4),
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
                    onTap: onTapGallery),
              ),
              UiSpacer.verticalSpace(
                  space: AppSizes().widgetSize.smallPadding, context: context),
              Center(
                child: ListTile(
                    tileColor: AppColor.buttonDisableColor,
                    dense: true,
                    visualDensity:
                        const VisualDensity(vertical: 1, horizontal: 4),
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
                    onTap: onTapCamera),
              ),
              UiSpacer.verticalSpace(
                  space: AppSizes().widgetSize.smallPadding, context: context),
              Center(
                child: ListTile(
                    dense: true,
                    tileColor: AppColor.buttonDisableColor,
                    visualDensity:
                        const VisualDensity(vertical: 1, horizontal: 4),
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
        },
      );

  static Future<String?> pickFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      String extension = pickedFile.path.split('.').last.toLowerCase();
      if (extension == 'jpg' || extension == 'jpeg' || extension == 'png') {
        String imgLocal = pickedFile.path;
        return imgLocal;
      } else {
        GlobalUtility.showToast(navigatorKey.currentContext!,
            "\"$extension\" format isn't supported");
      }
    }
    return null;
  }

  static Future<String?> pickFromCamera() async {
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    if (pickedFile != null) {
      String extension = pickedFile.path.split('.').last.toLowerCase();
      if (extension == 'jpg' || extension == 'jpeg' || extension == 'png') {
        String imgLocal = pickedFile.path;
        return imgLocal;
      } else {
        GlobalUtility.showToast(navigatorKey.currentContext!,
            "\"$extension\" format isn't supported");
      }
    }
    return null;
  }
}
