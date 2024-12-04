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
  const CustomVideoThumbnail({super.key, required this.videoUrl});
  final String videoUrl;

  @override
  State<CustomVideoThumbnail> createState() => _CustomVideoThumbnailState();
}

class _CustomVideoThumbnailState extends State<CustomVideoThumbnail> {
  final Map<String, String?> _thumbnailCache = {};

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // navigate to play video screen
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CustomVideoPlayer(videoUrl: widget.videoUrl),
            ));
      },
      child: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: FutureBuilder(
              future: getVideoThumbnail(widget.videoUrl),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Image.file(
                    File(snapshot.data!),
                    fit: BoxFit.cover,
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      child: SvgPicture.asset(
                        AppImages().svgImages.icPlaceHolder,
                        color: AppColor.greyColor,
                        width: 100,
                        height: 100,
                      ),
                    ),
                  );
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

  Future<String?> getVideoThumbnail(String videoUrl) async {
    // Check if thumbnail is already cached
    if (_thumbnailCache.containsKey(videoUrl)) {
      return _thumbnailCache[videoUrl];
    }

    // Generate thumbnail and store in cache
    var thumbnailFile = await VideoThumbnail.thumbnailFile(
      video: videoUrl,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.WEBP,
      maxHeight: 64,
      quality: 75,
    );

    _thumbnailCache[videoUrl] = thumbnailFile; // Cache the thumbnail
    return thumbnailFile;
  }
}
