import 'dart:io';

import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/custom_widgets/custom_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class CustomVideoThumbnail extends StatefulWidget {
  const CustomVideoThumbnail({super.key});

  @override
  State<CustomVideoThumbnail> createState() => _CustomVideoThumbnailState();
}

class _CustomVideoThumbnailState extends State<CustomVideoThumbnail> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // navigate to play video screen
        Navigator.push(context, MaterialPageRoute(builder: (context) => CustomVideoPlayer(videoUrl: "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4"),));
      },
      child: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: FutureBuilder(
              future: getVideoThumbnail(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Image.file(
                    File(snapshot.data!),
                    fit: BoxFit.cover,
                  );
                } else if (snapshot.hasError) {
                  return SvgPicture.asset(
                      AppImages().svgImages.ivProfilePlaceholder);
                } else {
                  return Shimmer.fromColors(
                    baseColor: AppColor.greyColor500.withOpacity(0.2),
                    highlightColor: AppColor.greyColor500,
                    child: Container(
                      color: AppColor.greyColor500,
                    ),
                  );
                }
              },
            ),
          ),
          Center(
              child: CircleAvatar(
                  backgroundColor: AppColor.greyColor.withOpacity(0.4),
                  child: Icon(
                    Icons.play_arrow,
                    color: AppColor.whiteColor,
                  )))
        ],
      ),
    );
  }

  Future<String?> getVideoThumbnail() async {
    var thumbnailFile = await VideoThumbnail.thumbnailFile(
      video:
          "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.WEBP,
      maxHeight:
          64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 75,
    );

    return thumbnailFile;
  }
}
