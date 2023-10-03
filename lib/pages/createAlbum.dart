import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photofolio/backup/feedalbum.dart';
import 'package:photofolio/model/feedmodel.dart';

class CreateAlbumPage extends StatefulWidget {
  @override
  _CreateAlbumPageState createState() => _CreateAlbumPageState();
}

class _CreateAlbumPageState extends State<CreateAlbumPage> {
  final TextEditingController _newValueController = TextEditingController();
   String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Album'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _newValueController,
              decoration: InputDecoration(labelText: '새 앨범 이름'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String newValue = _newValueController.text;
                // createAlbum 함수 호출하여 newValue 전달
                createAlbum(newValue);
              },
              child: Text('Select First Image'),
            ),
          ],
        ),
      ),
    );
  }

  void createAlbum(String newValue) async {
   
    Map<String, String>? _images = await _imagePickerToUpload(newValue);
    if (_images != null) {
      await _toFirestore(_images);
    }
  }

  //이미지피커를 통한 strage 업로드. firestore연동을 위해 url을 리턴
  Future<Map<String, String>?> _imagePickerToUpload(String newValue) async {

    final String _dateTime = DateTime.now().millisecondsSinceEpoch.toString();
    ImagePicker _picker = ImagePicker();
    XFile? _images = await _picker.pickImage(source: ImageSource.gallery);
    if (_images != null) {
      //파이어 스토리지 저장경로
      String _imageRef = "${uid}/$newValue$_dateTime";
      //업로드할 파일의 내부경로
      File _file = File(_images.path);
      //스토리지에 올리고
      await FirebaseStorage.instance.ref(_imageRef).putFile(_file);
      //url 따와서
      final String _urlString =
          await FirebaseStorage.instance.ref(_imageRef).getDownloadURL();
      return {
        "image": _urlString,
        "path": _imageRef,
        "albumname" : newValue
      };
    } else {
      return null;
    }
  }

  //스토리지 url을 스토어에 저장(UPLOAD&CREATE)
  Future<void> _toFirestore(Map<String, String> images) async {
    try {
      DocumentReference<Map<String, dynamic>> _reference =
          FirebaseFirestore.instance.collection("${uid}").doc();
      
          await _reference.set(FeedModel(
          uid: uid,
          docId: _reference.id,
          image: images["image"].toString(),
          path: images["path"].toString(),
          dateTime: Timestamp.now(),
          albumName: images["albumname"].toString(),
          thumbnail: true
        ).toFirestore());
      
      
    } on FirebaseException catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message ?? "")));
    }
  }
}