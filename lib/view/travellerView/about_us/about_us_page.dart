import 'package:Siesta/app_constants/app_color.dart';
import 'package:Siesta/app_constants/app_fonts.dart';
import 'package:Siesta/app_constants/app_images.dart';
import 'package:Siesta/app_constants/app_routes.dart';
import 'package:Siesta/app_constants/app_sizes.dart';
import 'package:Siesta/app_constants/app_strings.dart';
import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:Siesta/common_widgets/vertical_size_box.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  double screenWidth = 0.0, screenHeight = 0.0;
  final List<String> imgList = [
    "assets/pngFiles/ivAboutUsBooking.png",
    "assets/pngFiles/ivAboutUsBooking.png",
    "assets/pngFiles/ivAboutUsBooking.png",
  ];

  final CarouselController imageController = CarouselController();
  int _current = 0;



  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarColor: AppColor.appthemeColor),
        centerTitle: true,
        backgroundColor: AppColor.appthemeColor,
        elevation: 0,
        title: TextView.headingWhiteText(
            context: context, text: AppStrings().aboutUs),
        leading: IconButton(
            icon: Icon(
              Icons.close,
              color: AppColor.whiteColor,
            ),
            onPressed: () {
              Navigator.pushNamed(context,AppRoutes.travellerHomePage);
            }),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [imageView(), contentView()],
      ),
    );
  }

  // Image view
  Widget imageView() {
    return Container(
      alignment: Alignment.center,
      child: Image.asset(AppImages().pngImages.ivAboutUsFrame),
    );
  }

  // Content View
  Widget contentView() {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * AppSizes().widgetSize.horizontalPadding,
        vertical: screenWidth * AppSizes().widgetSize.horizontalPadding,
      ),
      children: [
        TextView.headingTextWithAlign(
            text: AppStrings().exploreWorldWithUs,
            context: context,
            alignmentTxt: TextAlign.start),
        UiSpacer.verticalSpace(space: 0.015, context: context),
        TextView.normalText(
            text: AppStrings().aboutUsDummyContent,
            context: context,
            textColor: AppColor.textfieldColor,
            textSize: AppSizes().fontSize.simpleFontSize,
            fontFamily: AppFonts.nunitoMedium),
        UiSpacer.verticalSpace(space: 0.015, context: context),
        Container(
            alignment: Alignment.center,
            color: Colors.transparent,
            child: CarouselSlider(
              carouselController: imageController,
              options: CarouselOptions(
                  autoPlay: false,
                  enlargeCenterPage: true,
                  viewportFraction: 9,

                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
              items: imgList
                  .map((item) =>
                      Center(child: Image.asset(item, fit: BoxFit.fill)))
                  .toList(),
            )),
        UiSpacer.verticalSpace(space: 0.015, context: context),
        Center(
          child: AnimatedSmoothIndicator(
            activeIndex: _current,
            count: imgList.length,
            effect: ExpandingDotsEffect(
                dotHeight: screenHeight * 0.015,
                dotWidth: screenWidth * 0.03,
                activeDotColor: AppColor.appthemeColor,
                dotColor: AppColor.buttonDisableColor),
          ),
        ),

        UiSpacer.verticalSpace(space: 0.015, context: context),
        TextView.normalText(
            text: AppStrings().aboutUsDummyContentSec,
            context: context,
            textColor: AppColor.textfieldColor,
            textSize: AppSizes().fontSize.simpleFontSize,
            fontFamily: AppFonts.nunitoMedium),
      ],
    );
  }



}
