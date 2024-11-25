import 'package:Siesta/app_constants/app_color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../app_constants/app_images.dart';

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

  static rectangleNetworkImage(
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
            color: AppColor.appthemeColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: SvgPicture.asset(AppImages().svgImages.ivProfilePlaceholder),
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
}
