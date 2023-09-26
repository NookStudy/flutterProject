import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
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
  
  List<String> albums = [
    // 'https://firebasestorage.googleapis.com/v0/b/photofolio-83774.appspot.com/o/nightvision%2Fpexels-well-naves-1829067.jpg?alt=media&token=aafa8cfc-f961-4864-b29f-d827a65a4a1b',
    // 'https://firebasestorage.googleapis.com/v0/b/photofolio-83774.appspot.com/o/nightvision%2Fpexels-jesper-18331707.jpg?alt=media&token=529efbc2-4256-48a7-8027-e42e3dec1441'
  ];

  void getList() async{
    ListResult  albumList = await FirebaseStorage.instance.ref("nightvision/").listAll();
    print(albumList);
      for (final e in albumList.items) {
        logger.d(await e.getDownloadURL());
      }
      List<String> albumsURLs = [];
      for (final e in albumList.items) {
        albumsURLs.add(await e.getDownloadURL());
      }
      setState(() {
        this.albums = albumsURLs;
      });
    logger.d(albumsURLs);
    logger.d(albumsURLs.length);
    logger.d(albumsURLs[0].toString());
  }

  @override
  void initState(){
    super.initState();
    getList();

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
                  // _getFeed(isRefresh: true);
                }),
            const SizedBox(height: 8),
            _button(
                icon: Icons.add_circle_outline_outlined,
                onTap: () async {
                  HapticFeedback.mediumImpact();
                  // Map<String, String>? _images =
                  //     // await _imagePickerToUpload();
                  // if (_images != null) {
                  //   // await _toFirestore(_images);
                  // }
                  setState(() {
                    // _isUpload = false;
                  });
                }),
            const SizedBox(height: 20),
          ],
        ),
      ),
      body: Center( 
        child: (albums.isEmpty)
        ? CircularProgressIndicator()
        : Container(
            child: GridView.builder(
              itemCount: albums.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,    //그리드 갯수
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1,
              ),    
              itemBuilder : (context,index){        
                return GestureDetector(
                  onTap: () async {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PhotoSelect(albumName: widget.albumName,imageURL: albums[index])));
                    HapticFeedback.mediumImpact();
                    // await _deleteFeed(_feed[index]);
                  },
                  child:Container(
                    decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image:NetworkImage(albums[index])
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
            )));
  }

}