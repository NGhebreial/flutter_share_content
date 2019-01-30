import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter_share_content/flutter_share_content.dart';

void main() => runApp(MyApp());

/// StatelessWidget to show the Stateful one
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Share Content example app",
      debugShowCheckedModeBanner: false,
      home: ShareContent(),
    );
  }
}

/// ShareContent to create the state
class ShareContent extends StatefulWidget {
  @override
  _ShareContentState createState() => _ShareContentState();
}

/// Made in in that way to show the modal bottom sheet
class _ShareContentState extends State<ShareContent> {
  File _image;
  TextEditingController _title = new TextEditingController();
  TextEditingController _msg = new TextEditingController();
  BuildContext _context;

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  void getText() {
    showModalBottomSheet(
        context: _context,
        builder: (BuildContext context) {
          return new Container(
            child: new Column(
              children: <Widget>[
                new TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Title",
                    contentPadding:
                        EdgeInsets.only(bottom: 50.0, top: 10.0, left: 12.0),
                  ),
                  controller: _title,
                ),
                new TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Message",
                    contentPadding:
                        EdgeInsets.only(bottom: 150.0, top: 10.0, left: 12.0),
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  controller: _msg,
                )
              ],
            ),
          );
        });
  }

  void share() {
    FlutterShareContent.shareContent(
        imageUrl: _image == null ? null : _image.path,
        msg: _msg.text,
        title: _title.text);
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
        floatingActionButton: FloatingActionButton(
          onPressed: share,
          child: Icon(Icons.share),
        ),
        bottomNavigationBar: BottomAppBar(
            child: Row(
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
        )),
      ),
    );
  }
}
