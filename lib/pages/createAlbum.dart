import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:photofolio/backup/feedalbum.dart';

class CreateAlbumPage extends StatefulWidget {
  @override
  _CreateAlbumPageState createState() => _CreateAlbumPageState();
}

class _CreateAlbumPageState extends State<CreateAlbumPage> {
  final TextEditingController _newValueController = TextEditingController();

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
              child: Text('Create Album'),
            ),
          ],
        ),
      ),
    );
  }

  void createAlbum(String newValue) async {
  try {

      /**
       * 
       * 업로드 이미지도 같이 올려야 하므로 imagepicker 추가할 것.
       */




    // Firestore에 새 앨범 데이터 추가
    final albumData = {
      'albumName': newValue, // 새 앨범의 이름 설정
      'thumbnail': true, // 기본적으로 앨범을 썸네일로 설정
      // 다른 필드들도 추가 가능
    };

    final newAlbumRef = await FirebaseFirestore.instance.collection(uid).add(albumData);

    // Firebase Storage에 이미지 업로드 (필요에 따라)
    final imageUploadTask = FirebaseStorage.instance.ref('albums/${newAlbumRef.id}/cover.jpg')
        .putFile(/* 여기에 업로드할 이미지 파일 */);

    final imageSnapshot = await imageUploadTask.whenComplete(() {});

    if (imageSnapshot.state == TaskState.success) {
      // 이미지 업로드 성공
      final imageUrl = await imageSnapshot.ref.getDownloadURL();
      // Firestore에 이미지 URL 업데이트
      await newAlbumRef.update({'imageUrl': imageUrl});
    } else {
      // 이미지 업로드 실패
      // 실패 처리 로직 추가
    }

    // 앨범 생성 성공
    print('앨범 생성 성공');
  } catch (error) {
    // 앨범 생성 중 오류 발생
    print('앨범 생성 중 오류: $error');
  }
}
}