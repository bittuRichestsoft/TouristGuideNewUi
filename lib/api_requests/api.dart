// import 'package:velocity_x/velocity_x.dart';

// ignore_for_file: constant_identifier_names

class Api {
  static String get baseUrl {
    return "https://indeedtraining.in:5006/";
    //  return "https://indeedtraining.in:2223/"; // FOR CHANGES
    // return "http://192.168.1.16:3003/";
    // return "https://imerzn.com:2525/"; // LIVE BASE URL
  }

  // usertype for api request
  static String guideRoleName = "GUIDE";
  static String travellerRoleName = "TRAVELLER";

  // api urls
  static const register = "user/signup";
  static const login = "user/login";
  static const socialLinks = "user/get-social-links";

  static const forgotPassword = "user/forgot-password";
  static const resetPassword = "user/reset-password";
  static const updateProfileImage = "user/update-profile-image";
  static const guide_sort_by_rating = "user/guide-sort-by-ratings";
  static const guide_detail = "user/find-guide/";
  static const search_guide = "user/search-guide";
  static const sendEnquiry = "user/send-enquiry";
  static const bookYourTrip = "traveller/booking";
  static const myBooking = "traveller/booking-list";
  static const cancelTrip = "traveller/cancel-booking";
  static const travellerRequestItinerary = "traveller/request-itinerary";
  static const travellerRejectItinerary = "traveller/reject-itinerary";
  static const addRatings = "traveller/add-ratings";
  static const itineraryDetail = "traveller/itinerary-detail";
  static const logoutTraveller = "traveller/logout";
  static const deleteTraveller = "traveller/delete-account";
  static const updateTravellerProfile = "traveller/profile";
  static const eligibleMessageUser = "traveller/eligible-message-user";
  static const sendComposeMessage = "traveller/send-compose-message";
  static const inboxUsers = "traveller/inbox-user-list";
  static const sentinboxUsers = "traveller/sent-user-list";
  static const getMessagesThread = "traveller/get-messages";
  static const sendreplyMessage = "traveller/reply-message";
  static const deleteMessage = "traveller/delete-compose-message";
  static const travellerNotification = "traveller/notifications";
  static const readNotification = "traveller/marked-read-notification";

  static const travellerCreateProfile = "traveller/update-profile";
  static const updatePassword = "traveller/update-password";
  static const travellerUpdateNotification = "traveller/update-notification";
  static const travellerInitialPayment =
      "traveller/initial-payment"; // not used
  static const travellerGetProfile = "traveller/get-profile";
  static const travellerTransactionHistory = "traveller/transaction-list";
  static const travellerTransactionView = "traveller/view-transaction";
  static const guideTransactionView = "guide/view-transaction";
  static const paymentApi = "traveller/initial-pay";
  static const withdrawAdvancePayment = "guide/withdraw-amount";
  static const withdrawTotalPayment = "guide/withdraw-all";

  // final paymentApi
  static const finalTravellerPaymentStatusApi = "traveller/final-pay-status";
  static const finalTravellerPaymentApi = "traveller/final-pay";
  static const guideUpdateProfile = "guide/profile";
  static const guideCreateProfile = "guide/update-profile";
  static const guideRecievedBooking = "guide/booking-list";
  static const guideCancelTrip = "guide/cancel-booking";
  static const guideCreateItinerary = "guide/create-itinerary";
  static const guideItineraryDetail = "guide/itinerary-detail";
  static const guideCancelBooking = "guide/cancel-booking";
  static const guideEditItinerary = "guide/edit-itinerary";
  static const guideGalleryImages = "guide/gallery-photos";
  static const guideUploadImages = "guide/gallery-add-photos";
  static const guideUpdateImages = "guide/update-gallery-image";
  static const logoutguide = "guide/logout";
  static const deleteGuide = "guide/delete-account";
  static const updateGuideProfile = "guide/profile";
  static const updatePasswordGuide = "guide/update-password";

  // MESSAGE CHAT -----
  static const guideEligibleMessageUser = "guide/eligible-message-user";
  static const guideSendComposeMessage = "guide/send-compose-message";
  static const guideInboxUsers = "guide/inbox-user-list";
  static const guideSentinboxUsers = "guide/sent-user-list";
  static const guideGetMessagesThread = "guide/get-messages";
  static const guideSendreplyMessage = "guide/reply-message";
  static const guideDeleteMessage = "guide/delete-compose-message";
  static const travellerSendVoiceMsgApi = "traveller/send-voice-message";
  static const guideSendVoiceMsgApi = "guide/send-voice-message";

  static const guideAvailability = "guide/update-availability";
  static const guideNotification = "guide/notifications";
  static const guideReadNotification = "guide/marked-read-notification";
  static const guideUpdateNotification = "guide/update-notification";
  static const guideGetProfile = "guide/get-profile";
  static const paymentStatusApi = "traveller/initial-pay-status"; // not used
  static const completeGuideApi = "guide/complete-booking";
  static const paymentProceedGuideApi = "guide/process-final-payment";
  static const guideTransactionListApi = "guide/transaction-list";
  static const guideUpdateBankAccountApi = "guide/update-account";
  static const guideGetBankAccountApi = "guide/get-account";
  static const travellerFinalPayment = "traveller/final-payment";
  static const guideRatingReviews = "guide/all-rating-reviews";
  static const getLocation = "user/get-location";
  static const checkWaitingUser = "traveller/check-waiting-user";
  static const waitingListContent = "traveller/get-waiting-list-page-content";
  static const travellerGetPaymentMethodList =
      "traveller/get-payment-methods-list";
  static const travellerSampleGenerateItineraryApi =
      "traveller/generate-sample-itinerary";
  static String termsAndConditions = "${Api.baseUrl}app/terms";
  // static String privacyPolicy = "${Api.baseUrl}app/privacy";
  static String aboutUs = "${Api.baseUrl}about-us";
  static String waitingList = "${Api.baseUrl}waiting-list";

  // For Profile
  static String getActivities = "guide/get-activities";
  static String deleteDocuments = "guide/delete-documents";
  static String updateCoverImage = "guide/update-cover-image";
  static String removeCoverImage = "guide/remove-cover-image";

  // To get listing of gallery, general & experience
  static String getGalleryPosts = "guide/get-gallery-posts";
  static String getGeneralPosts = "guide/get-general-posts";
  static String getExperiencePosts = "guide/get-experience-posts";

  // for gallery, general & experience detail page
  static String getGalleryDetail = "guide/get-gallery-detail";
  static String getPostDetail = "guide/get-post-detail";

  // to like unlike the post
  static String likePost = "guide/like-post";
  static String unLikePost = "guide/unlike-post";
  static String likeGallery = "guide/like-gallery";
  static String unLikeGallery = "guide/unlike-gallery";

  // Create gallery, post
  static String createPost = "guide/create-post";
  static String createGallery = "guide/create-gallery";

  // Update gallery, post
  static String updatePost = "guide/update-post";
  static String updateGallery = "guide/update-gallery";

  // view other guide profile
  static String getOtherGuideProfile = "user/get-guide-profile";

  // follow and unfollow guide
  static String followGuide = "guide/follow-guide";
  static String unFollowGuide = "guide/unfollow-guide";

  // User search experience
  static String searchExperience = "user/search-experience";

  // Traveller book experience
  static String bookExperience = "traveller/book-experience";

  // Accept the booking
  static String acceptBooking = "guide/update-booking";
}

/// -- ---- --- ---- --- STATUS MEAN --- ---- - - - -- ---- - -- ---
// Status = 0 mean -> traveller create
// Status = 1 mean -> traveller cancel
// Status = 2 mean -> accept itinerary
// Status = 3 mean -> cancelled by guide
// Status = 4 mean -> payment success
// Status = 5 mean -> traveller rejected itinerary
// Status = 6 mean -> traveller requested itinerary
// Status = 7 mean -> traveller cancelled after requesting itinerary
// Status = 8 mean -> guide edit an accept
// Status = 9 mean -> guide reject itinerary

// 1,3,5,7,9 status mean booking cancel
