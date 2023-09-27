import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:photofolio/model/feedmodel.dart';
import 'package:photofolio/pages/photo.dart';

class ListAlbumScreen extends StatefulWidget {
  String? albumName = '';
  ListAlbumScreen({super.key, required this.albumName});

  
  @override
  State<ListAlbumScreen> createState() => _ListAlbumScreenState();
}

class _ListAlbumScreenState extends State<ListAlbumScreen> {

  var logger = Logger(
    printer: PrettyPrinter(),
  );

  String uid = FirebaseAuth.instance.currentUser!.uid;

  List<FeedModel> _feed = [];
  bool _isUpload = false;
  
  

  @override
  void initState(){
    super.initState();
    // getList();
    _getFeed();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.albumName!),
      ),
      floatingActionButton: 
      SizedBox(
        height: 120,
        child: Column(
          children: [
            _button(
                icon: Icons.refresh_outlined,
                onTap: () {
                  HapticFeedback.mediumImpact();
                  _getFeed(isRefresh: true);
                }),
            const SizedBox(height: 8),
            _button(
              icon: Icons.add_circle_outline_outlined,
              onTap: () async {
                HapticFeedback.mediumImpact();
                uploadProcess();
                setState(() {
                  _isUpload = false;
                });
              }
            ),
            const SizedBox(height: 8),
            _button(
              icon: Icons.remove_circle_outline_outlined,
              onTap: () async {
                HapticFeedback.mediumImpact();
                deleteDocumentsWithQuery();
                setState(() {
                  _isUpload = false;
                });
              },
            ),
            const SizedBox(height: 8),
            _button(

                icon: Icons.remove_circle_outline_outlined,
                onTap: () async {
                  HapticFeedback.mediumImpact();
                  deleteDocumentsWithQuery();
                  setState(() {
                    _isUpload = false;
                  });
                },

                ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      body: Center( 
        child: (_feed.isEmpty)
        ? CircularProgressIndicator()
            
        : Container(
            child: GridView.builder(
              itemCount:_feed.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,    //그리드 갯수
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1,
              ),    
              itemBuilder : (context,index){        
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PhotoSelect(albumName: widget.albumName,imageURL: _feed[index].image)));
                  },
                  onLongPress: ()async{
                    HapticFeedback.mediumImpact();
                    await _deleteFeed(_feed[index]);
                    logger.d('long press');
                  },
                  child:Container(
                    decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image:NetworkImage(_feed[index].image)
                      )
                    ),
                  ),
                );
              }
            ),
          )
        ),
      );
  }

  Container _button({ required IconData icon, required Function() onTap,}) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(60),
        color: Colors.black45,
      ),
      child: IconButton(
          onPressed: onTap,
          icon: Icon(
            icon,
            color: Colors.white,
          )
      )
    );
  }
   //파이어 스토어를 통한 storage url 가져오기(READ)
  Future<void> _getFeed({bool isRefresh = false}) async {
    if (isRefresh) {
      _feed.clear();
    }
      QuerySnapshot<Map<String, dynamic>> _snapshot = await FirebaseFirestore
        .instance
        .collection("${uid}")
        .where("albumName", isEqualTo: '${widget.albumName}')
        .orderBy("dateTime", descending: true)
        .get();
    setState(() {
      _feed = _snapshot.docs
          .map((e) => FeedModel.fromFirestore(e.data()))
          .toList();
    });
  }

   //이미지피커를 통한 strage 업로드. firestore연동을 위해 url을 리턴
  Future<Map<String, String>?> _imagePickerToUpload() async {
    setState(() {
      _isUpload = true;
    });
    final String _dateTime = DateTime.now().millisecondsSinceEpoch.toString();
    ImagePicker _picker = ImagePicker();
    XFile? _images = await _picker.pickImage(source: ImageSource.gallery);
    if (_images != null) {
      //파이어 스토리지 저장경로
      String _imageRef = "${uid}/${widget.albumName}_$_dateTime";
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
      if (_feed.isEmpty) {
          await _reference.set(FeedModel(
          uid: uid,
          docId: _reference.id,
          image: images["image"].toString(),
          path: images["path"].toString(),
          dateTime: Timestamp.now(),
          albumName: '${widget.albumName}',
          thumbnail: true
        ).toFirestore());
      }else{
        await _reference.set(FeedModel(
          uid: uid,
          docId: _reference.id,
          image: images["image"].toString(),
          path: images["path"].toString(),
          dateTime: Timestamp.now(),
          albumName: '${widget.albumName}',
          thumbnail: false
        ).toFirestore());
      }
    } on FirebaseException catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message ?? "")));
    }
  }


  //파이어 스토어에 연동
  void uploadProcess() async{
    Map<String, String>? _images = await _imagePickerToUpload();
    if (_images != null) {
      await _toFirestore(_images);
    }
  }


  Future<void> _deleteFeed(FeedModel data) async {
    await FirebaseStorage.instance.ref(data.path).delete();
    await FirebaseFirestore.instance
        .collection(uid)
        .doc(data.docId)
        .delete();
    setState(() {
      _feed.remove(data);
    });
  }

  void deleteDocumentsWithQuery() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection(uid)
        .where('albumName', isEqualTo: widget.albumName)
        .get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
      await doc.reference.delete();
    }

    print('조건에 맞는 문서 삭제 완료');
  }


}