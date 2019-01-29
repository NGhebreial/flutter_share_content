import 'dart:async';

import 'package:flutter/services.dart';

class FlutterShareContent {
  static const MethodChannel _channel =
      const MethodChannel('flutter_share_content');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> shareContent({String imageUrl, String msg, String title}) async {
    return await _channel.invokeMethod('shareContent',
        <String, dynamic>{
          'path': imageUrl,
          'msg' : msg,
          'title': title
        });
  }

}
