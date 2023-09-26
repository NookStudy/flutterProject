
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:photofolio/pages/photo.dart';

// ignore: must_be_immutable
class AlbumScreen extends StatefulWidget {
  
  String? albumName = '';
  AlbumScreen({super.key, required this.albumName});
  
  List<String> albums = [
    'https://firebasestorage.googleapis.com/v0/b/photofolio-83774.appspot.com/o/nightvision%2Fpexels-well-naves-1829067.jpg?alt=media&token=aafa8cfc-f961-4864-b29f-d827a65a4a1b',
    'https://firebasestorage.googleapis.com/v0/b/photofolio-83774.appspot.com/o/nightvision%2Fpexels-jesper-18331707.jpg?alt=media&token=529efbc2-4256-48a7-8027-e42e3dec1441'
  ];



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
    setState(() {
      downloadURL = url;
    });
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PhotoSelect(albumName: 'Name',imageURL: 'dd',))); 
                    }, child: Text('print')),
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image:AssetImage('assets/images/Main.jpg')
                      )
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image:NetworkImage('https://firebasestorage.googleapis.com/v0/b/photofolio-83774.appspot.com/o/nightvision%2Fpexels-well-naves-1829067.jpg?alt=media&token=aafa8cfc-f961-4864-b29f-d827a65a4a1b')
                        // image:(downloadURL!='')?('$downloadURL'):
                      )
                    ),
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