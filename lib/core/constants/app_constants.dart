 


import '../../defaults.dart';

class AppConsts {
  AppConsts._();
  static const String appName = 'layer_kit';

  // CHANGE NETWORK IMAGE FOR DISPLAY IN CASE OF NETWORK IMAGE FAILURE
  static const String dummyNetworkImage = 'https://i.pravatar.cc/';

  static const String appStoreUrl = '<app_store_url_here>';
  static const String playStoreUrl = '<play_store_url_here>';

  static String get shareUrl => D.isIOS ? appStoreUrl : playStoreUrl;
}
