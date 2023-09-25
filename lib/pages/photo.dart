import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class PhotoSelect extends StatefulWidget {
  String? albumName = '';
  PhotoSelect({super.key,required this.albumName});

  @override
  State<PhotoSelect> createState() => _PhotoSelectState();
}

class _PhotoSelectState extends State<PhotoSelect> {

  String? downloadURL = '';

  Future<bool> getURL() async{
    final pathReference =  FirebaseStorage.instance
        .ref().child('test_movie_1.png');
    print('pathref:$pathReference');
    String url = await pathReference.getDownloadURL() as String;
    downloadURL = url;
    print(downloadURL);
    return true;
  }

  @override
  void initState(){
    super.initState();
    getURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.albumName!),
          
        ),
        body: 
        FutureBuilder(
          future: getURL(),
          builder:(context, snapshot) { 
          if(!(snapshot.hasData)){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        //인디케이트의 모양 혹은 색 설정
                        height: 50.0,
                        width: 50.0,
                        child: CircularProgressIndicator(
                          color: Colors.blueAccent,
                          strokeWidth: 5.0,
                        ),
                      ),
                    ],
                  ),
                ]
              );
          }else{
            return SizedBox(
              child: Image.network('$downloadURL'),
            );
          }
        }
      )
    );
  }
}