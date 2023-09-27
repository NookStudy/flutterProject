import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdatePage extends StatefulWidget {
  String? albumName = '';
  UpdatePage({super.key, required this.albumName});
  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final TextEditingController _newValueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('수정할 앨범이름을 입력하세요'),
            TextField(
              controller: _newValueController,
              decoration: InputDecoration(labelText: '새 앨범 이름'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // 업데이트 작업 수행
                _updateFirestoreDocument(_newValueController.text);
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateFirestoreDocument (String newValue) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
      .collection('your_collection')
      .where('field_name', isEqualTo: widget.albumName)
      .get();

      // 업데이트할 필드와 값을 포함하는 데이터 맵을 생성합니다.
    final Map<String, dynamic> dataToUpdate = {
      'albumName': newValue,
      // 다른 필드들도 추가할 수 있습니다.
    };

    // 가져온 문서들에 대해 업데이트를 수행합니다.
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
      await doc.reference.update(dataToUpdate);
    }

    print('조건에 맞는 문서들의 특정 필드 업데이트 완료');
  }
  
}