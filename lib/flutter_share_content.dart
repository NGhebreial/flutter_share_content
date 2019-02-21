import 'dart:async';

import 'package:flutter/services.dart';

class FlutterShareContent {
  static const MethodChannel _channel =
      const MethodChannel('flutter_share_content');

  /// Could receive [imageUrl] as a path of the image that is going to be shared
  /// [msg] is the message to send with the image
  /// [title] is the title to show in the sharing window, by default is "Share to"
  static Future<void> shareContent(
      {String imageUrl, String msg, String title}) async {
    return await _channel.invokeMethod('shareContent',
        <String, dynamic>{'path': imageUrl, 'msg': msg, 'title': title});
  }
}
