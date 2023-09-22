
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AlbumScreen extends StatefulWidget {
  
  String? albumName = '';
  AlbumScreen({super.key, required this.albumName});



  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  String? downloadURL = '';

  void printRefs() async{
    final pathReference =  FirebaseStorage.instance
      .ref().child('test_movie_1.png');
    print('pathref:$pathReference');
    String url = await pathReference.getDownloadURL() as String;
    downloadURL = url;
    print(url);
  }
  // Future<String> getUrl() async{ 
  //   // final pathReference =  FirebaseStorage.instance
  //   //   .ref().child('test_movie_1.png');
    
  //   // print(pathReference);
  //   // try {
      
  //   //   downloadURL = await pathReference.getDownloadURL();
  //   // } catch (e) {
  //   //   print(e);
  //   // }
  //   //   print(downloadURL);

  //   await printRefs();
  // }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.albumName!),
          
        ),
        body: Center(
          child: Container(
              child: GridView.count(
                crossAxisCount: 3,    //그리드 갯수
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1,
                children: [
                  ElevatedButton(
                    onPressed: (){
                      printRefs();
                    }, child: Text('print')),
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset('assets/images/Main.jpg'),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Image.network('https://firebasestorage.googleapis.com/v0/b/photofolio-83774.appspot.com/o/test_movie_1.png?alt=media&token=8b3b87b5-dfa4-495b-8048-ffd76936ae6b'),
                    // child: Image.network(downloadURL!),
                  ),
                
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset('assets/images/Main.jpg'),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset('assets/images/Main.jpg'),
                  ),
                ],
              ),
            ),
        ),
      );
  }
}