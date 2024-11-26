import 'dart:async';

import 'package:Siesta/common_widgets/common_textview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../app_constants/app_color.dart';
import '../../../app_constants/app_images.dart';
import '../../../common_widgets/vertical_size_box.dart';
import '../../../custom_widgets/custom_textfield.dart';

class FindGuideScreenNew extends StatefulWidget {
  const FindGuideScreenNew({super.key});

  @override
  State<FindGuideScreenNew> createState() => _FindGuideScreenNewState();
}

class _FindGuideScreenNewState extends State<FindGuideScreenNew> {
  double screenWidth = 0.0, screenHeight = 0.0;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // filter view
            filterView(),
            UiSpacer.verticalSpace(context: context, space: 0.02),

            // tab view
            tabBarView(),

            // Google Map
            SizedBox(
              height: screenHeight * 0.75,
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget filterView() {
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.04),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // search field & filter view
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                // width: screenWidth * 0.7,
                child: CustomTextField(
                  hintText: "Search by",
                  borderRadius: 50,
                  suffixWidget: Icon(
                    Icons.search,
                    color: AppColor.blackColor,
                  ),
                ),
              ),
              IconButton(
                icon: SvgPicture.asset(AppImages().svgImages.icFilter),
                onPressed: () {},
              )
            ],
          ),
          UiSpacer.verticalSpace(context: context, space: 0.02),

          // Tags
          SizedBox(
            height: screenHeight * 0.045,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: 4,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                    vertical: screenWidth * 0.01,
                    horizontal: screenWidth * 0.03,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: AppColor.appthemeColor,
                  ),
                  child: TextView.mediumText(
                    context: context,
                    text: "Hiking",
                    textSize: 0.016,
                    textAlign: TextAlign.center,
                    textColor: AppColor.whiteColor,
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return UiSpacer.horizontalSpace(context: context, space: 0.02);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget tabBarView(){
    return Container();
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
}
