# Share content for flutter

[![pub package](https://img.shields.io/pub/v/flutter_share_content.svg)](https://pub.dartlang.org/packages/flutter_share_content)

A simple plugin for Flutter to share content.

This content could be a picture but also a message. Furthermore a title can be added to show in the sharing screen.
 
Every version of Android is supported, included from version 24 and above.
For those devices is mandatory the use of `FileProvider` class in order to grant access 
to the images stored in the phone.

iOS is on the way.


## Installation

First add `flutter_share_content` as a dependency in your `pubsec.yaml`

### Android

Add this in your `build.gradle`

```gradle
dependencies {
    api 'com.android.support:support-v4:27.1.1'
}
```

And this in your `AndroidManifest.xml`

```xml
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>

...

<provider
    android:name="android.support.v4.content.FileProvider"
    android:authorities="${applicationId}.provider"
    android:exported="false"
    android:grantUriPermissions="true">
    <meta-data
        android:name="android.support.FILE_PROVIDER_PATHS"
        android:resource="@xml/filepaths"/>
</provider>
```
Also create `res/filepaths.xml` with this content

```xml
<?xml version="1.0" encoding="utf-8"?>
<paths xmlns:android="http://schemas.android.com/apk/res/android">
<external-path name="external_files" path="."/>
</paths>
```


### Example

```dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter_share_content/flutter_share_content.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Share Content example app",
      debugShowCheckedModeBanner: false,
      home: ShareContent(),
    );
  }
}

class ShareContent extends StatefulWidget {
  @override
  _ShareContentState createState() => _ShareContentState();
}

class _ShareContentState extends State<ShareContent> {
  File _image;
  TextEditingController _title = new TextEditingController();
  TextEditingController _msg =  new TextEditingController();
  TextEditingController _subject = new TextEditingController();
  BuildContext _context;

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  void getText(){
    showModalBottomSheet(context: _context,
        builder:(BuildContext context) {
          return new Container(
            child: new Column(
              children: <Widget>[
                new TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Title",
                    contentPadding: EdgeInsets.only(bottom: 50.0, top: 10.0, left: 12.0),
                  ),

                  controller: _title,
                ),
                new TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Message",
                    contentPadding: EdgeInsets.only(bottom: 150.0, top: 10.0, left: 12.0),
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,

                  controller: _msg,
                )
              ],
            ),
          );
        }
    );
  }

  void share(){
    FlutterShareContent.shareContent(imageUrl: _image == null? null: _image.path,
        msg: _msg.text, title: _title.text);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Share Content example app'),
        ),
        body: new Center(
          child: _image == null
              ? new Text('No image selected.')
              : new Image.file(_image),
        ),
        floatingActionButton:
        FloatingActionButton(onPressed: share, child: Icon(Icons.share),),

        bottomNavigationBar:
        BottomAppBar(
          child:
          Row(
            children: <Widget>[
              new FloatingActionButton(
                onPressed: getImage,
                tooltip: 'Pick Image',
                child: new Icon(Icons.camera_alt),
              ),
              new FloatingActionButton(
                onPressed: getText,
                tooltip: 'Show text',
                child: new Icon(Icons.text_fields),
              ),
            ],
          )

        ),

      ),
    );
  }
}

```

