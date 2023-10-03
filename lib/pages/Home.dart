import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:photofolio/model/feedmodel.dart';
import 'package:photofolio/backup/albums.dart';
import 'package:photofolio/backup/feedalbum.dart';
import 'package:photofolio/pages/createAlbum.dart';
import 'package:photofolio/pages/listAlbum.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}



class _HomeScreenState extends State<HomeScreen> {
  Logger logger = new Logger();

  String? albumName= '';
  String uid = FirebaseAuth.instance.currentUser!.uid;


  List<FeedModel> _feed = [];
  
  Future<void> _getAlbumFeed({bool isRefresh = false}) async {
    if (isRefresh) {
      _feed.clear();
    }
      QuerySnapshot<Map<String, dynamic>> _snapshot = await FirebaseFirestore
        .instance
        .collection("${uid}")
        .where("thumbnail", isEqualTo:true )
        .orderBy("albumName", descending: true)
        .get();
    setState(() {
      _feed = _snapshot.docs
          .map((e) => FeedModel.fromFirestore(e.data()))
          .toList();
    });
    logger.d(_feed);
    logger.d(uid);
  }

  @override
  void initState(){
    super.initState();
    _getAlbumFeed();
  }

  Route _createRoute(String albumName) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => AlbumScreen(albumName: albumName,),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Photofolio'),
          
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
                      _getAlbumFeed(isRefresh: true);
                      // _getFeed(isRefresh: true);
                    }),
                const SizedBox(height: 8),
                _button(
                    icon: Icons.add_circle_outline_outlined,
                    onTap: () async {
                      HapticFeedback.mediumImpact();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAlbumPage()));
                      // setState(() {
                      //   _isUpload = false;
                      // });
                    }),
                const SizedBox(height: 20),
              ],
            ),
          ),
        body: Center(
          child: (_feed == null)
      ? CircularProgressIndicator() // _feed가 null이면 로딩 표시
      // : _feed.isEmpty
      //     ? Text('피드가 없습니다.') 
          : Container(
            child: GridView.builder(
              itemCount: _feed.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,    //그리드 갯수
                mainAxisSpacing: 3,
                crossAxisSpacing: 1,
                childAspectRatio: 0.90,
              ),
              itemBuilder :(context, index) {
                return GestureDetector(
                  onTap: () async {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ListAlbumScreen(albumName: _feed[index].albumName,)));
                    HapticFeedback.mediumImpact();
                    // await _deleteFeed(_feed[index]);
                  },
                  onLongPress: () async {
                    HapticFeedback.mediumImpact();
                    // await _deleteFeed(_feed[index]);
                    logger.e('long press');
                  },
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(
                          child: TextButton(
                            onPressed: ()async{
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ListAlbumScreen(albumName: _feed[index].albumName,)));
                            },
                            child: Image.network(
                              _feed[index].image,
                              fit: BoxFit.cover,width: double.infinity,height: 170,
                            ),
                          ),
                        ),
                        SizedBox(child: Text(_feed[index].albumName,style: TextStyle(fontSize: 14),),height: 20)
                      ]
                    )
                  ),
                );
              },
            ),
          ),
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

  Future<void> _deleteAlbum(FeedModel data) async {
    await FirebaseStorage.instance.ref(data.path).delete();
    await FirebaseFirestore.instance
        .collection("feed")
        .doc(data.docId)
        .delete();
    setState(() {
      _feed.remove(data);
    });
  }


 
}