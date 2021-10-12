import 'package:getuiflut/getuiflut.dart';

class GetuiUtils {
  static config() {
    Getuiflut().addEventHandler(
      onReceiveClientId: (String message) async {
        print("flutter onReceiveClientId: $message");
      },
      onReceiveMessageData: (Map<String, dynamic> msg) async {
        print("flutter onReceiveMessageData: $msg");
      },
      onNotificationMessageArrived: (Map<String, dynamic> msg) async {
        print("flutter onNotificationMessageArrived");
      },
      onNotificationMessageClicked: (Map<String, dynamic> msg) async {
        print("flutter onNotificationMessageClicked");
      },
      onRegisterDeviceToken: (String message) async {},
      onReceivePayload: (Map<String, dynamic> message) async {
        print("flutter onReceivePayload: $message");
      },
      onReceiveNotificationResponse: (Map<String, dynamic> message) async {
        print("flutter onReceiveNotificationResponse: $message");
      },
      onAppLinkPayload: (String message) async {},
      onRegisterVoipToken: (String message) async {},
      onReceiveVoipPayLoad: (Map<String, dynamic> message) async {},
    );
  }

  static Future<void> initGetuiSdk() async {
    try {
      Getuiflut.initGetuiSdk;
    } catch (e) {
      e.toString();
    }
  }

  static Future<void> getClientId() async {
    String getClientId;
    try {
      getClientId = await Getuiflut.getClientId;
      print(getClientId);
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<void> getLaunchNotification() async {
    Map info;
    try {
      info = await Getuiflut.getLaunchNotification;
      print(info);
    } catch (e) {
      print(e.toString());
    }
  }
}
