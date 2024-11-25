import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_routes.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:Siesta/response_pojo/add_image_response.dart';
import 'package:Siesta/view/all_bottomsheet/upload_images_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:Siesta/view_models/guide_models/guideGalleryModel.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  double screenWidth = 0.0, screenHeight = 0.0;
  List<XFile> uploadImages = [];
  List<ImageSelectionPojo> titleImagesList = [];

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return ViewModelBuilder<GuideGalleryModel>.reactive(
        viewModelBuilder: () => GuideGalleryModel(),
        onViewModelReady: (model) => model.initialised,
        builder: (context, model, child) {
          return Scaffold(
              backgroundColor: AppColor.whiteColor,
              appBar: AppBar(
                systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: AppColor.appthemeColor),
                centerTitle: true,
                backgroundColor: AppColor.appthemeColor,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: AppColor.whiteColor),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, AppRoutes.touristGuideHome);
                    // Navigator.pop(context);
                  },
                ),
                title: TextView.headingWhiteText(
                    text: AppStrings().gallery, context: context),
              ),
              body: model.isBusy == false
                  ? Stack(
                      children: [
                        model.galleryImageList.isNotEmpty
                            ? Padding(
                                padding:
                                    EdgeInsets.only(bottom: screenHeight * 0.1),
                                child: imagesView(model),
                              )
                            : noPhotosView(),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: uploadImagesButton(model),
                        )
                      ],
                    )
                  : SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: CircularProgressIndicator(
                            color: AppColor.appthemeColor),
                      ),
                    ));
        });
  }

  Widget noPhotosView() {
    return Container(
      height: screenHeight * 0.8,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * AppSizes().widgetSize.horizontalPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: SvgPicture.asset(AppImages().svgImages.ivNoGallery),
          ),
          UiSpacer.verticalSpace(
              space: AppSizes().widgetSize.smallPadding, context: context),
          Center(
            child: TextView.normalText(
                textColor: AppColor.appthemeColor,
                textSize: AppSizes().fontSize.headingTextSize,
                fontFamily: AppFonts.nunitoSemiBold,
                text: AppStrings().noPhotosAdded,
                context: context),
          ),
          Center(
            child: TextView.normalText(
                textColor: AppColor.textColorBlack,
                textSize: AppSizes().fontSize.normalFontSize,
                fontFamily: AppFonts.nunitoRegular,
                text: AppStrings().addMorePhotos,
                context: context),
          ),
        ],
      ),
    );
  }

  Widget imagesView(model) {
    return ListView.builder(
        itemCount: model.galleryImageList!.length,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(
            vertical: screenHeight * AppSizes().widgetSize.normalPadding,
            horizontal: screenWidth * AppSizes().widgetSize.horizontalPadding),
        itemBuilder: (context, index) {
          return Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            runAlignment: WrapAlignment.start,
            runSpacing: 10,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: screenWidth * 0.8,
                      child: Text(
                        model.galleryImageList[index].destinationTitle,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height *
                                AppSizes().fontSize.headingTextSize,
                            fontFamily: AppFonts.nunitoBold,
                            color: AppColor.lightBlack,
                            fontWeight: FontWeight.w500),
                      )),
                  GestureDetector(
                    onTap: () {
                      debugPrint(index.toString());
                      showModalBottomSheet(
                        useSafeArea: false,
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(screenWidth *
                                AppSizes().widgetSize.largeBorderRadius),
                          ),
                        ),
                        builder: (BuildContext context) {
                          return Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: UploadImagesSheet(
                                  selIndex: index, modelRef: model));
                        },
                      );
                    },
                    child: SvgPicture.asset(AppImages().svgImages.icEdit),
                  ),
                ],
              ),
              selectedImagesGrid(model.galleryImageList[index].fileUrls)
            ],
          );
        });
  }

  Widget selectedImagesGrid(imagesList) {
    return GridView.count(
        padding: EdgeInsets.only(bottom: screenHeight * 0.01),
        physics: const ScrollPhysics(),
        childAspectRatio: 1.0,
        shrinkWrap: true,
        crossAxisCount: 4,
        crossAxisSpacing: MediaQuery.of(context).size.width * 0.01,
        mainAxisSpacing: MediaQuery.of(context).size.width * 0.01,
        children: List.generate(imagesList.length, (index) {
          return ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(
                MediaQuery.of(context).size.width *
                    AppSizes().widgetSize.smallBorderRadius)),
            child: Image.network(
              imagesList[index].galleryImgUrl,
              fit: BoxFit.cover,
            ),
          );
        }));
  }

  Widget uploadImagesButton(model) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
        child: SizedBox(
          height: screenHeight * 0.06,
          child: TextButton.icon(
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * AppSizes().widgetSize.normalPadding,
                  vertical:
                      screenHeight * AppSizes().widgetSize.verticalPadding),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              alignment: Alignment.center,
              visualDensity: const VisualDensity(horizontal: 4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(
                      screenWidth * AppSizes().widgetSize.largeBorderRadius))),
              backgroundColor: AppColor.appthemeColor,
            ),
            onPressed: () async {
              List<ImageSelectionPojo>? imagesList =
                  await showModalBottomSheet<List<ImageSelectionPojo>>(
                useSafeArea: false,
                context: context,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(
                        screenWidth * AppSizes().widgetSize.largeBorderRadius),
                  ),
                ),
                builder: (BuildContext context) {
                  return Padding(
                      padding: EdgeInsets.only(
                          // purpose of send -1 is diffrenciate whether to add new images or update
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: UploadImagesSheet(selIndex: -1, modelRef: model));
                },
              );
              if (imagesList != null) {
                setState(() {
                  titleImagesList = imagesList;
                });
              }
            },
            icon: Image.asset(
              AppImages().pngImages.icGallery,
              width: AppSizes().widgetSize.iconWidth,
              height: AppSizes().widgetSize.iconHeight,
              color: AppColor.whiteColor,
            ),
            label: TextView.normalText(
                text: AppStrings().addMemories,
                context: context,
                fontFamily: AppFonts.nunitoMedium,
                textSize: AppSizes().fontSize.xsimpleFontSize,
                textColor: AppColor.whiteColor),
          ),
        ));
  }
}
