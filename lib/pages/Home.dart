import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:photofolio/pages/albums.dart';
import 'package:photofolio/pages/feedalbum.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}



class _HomeScreenState extends State<HomeScreen> {

  String? albumName= '';
  

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
        body: Center(
          child: Container(
              child: GridView.count(
                crossAxisCount: 2,    //그리드 갯수
                mainAxisSpacing: 3,
                crossAxisSpacing: 1,
                childAspectRatio: 0.90,
                children: [
                  Container(
                    child: Column(
                      children: [
                        SizedBox(
                          
                          child: TextButton(
                          onPressed: ()async{

                            Navigator.push(context, MaterialPageRoute(builder: (context) => AlbumScreen(albumName: 'Model')));
                          },
                          child: Image.asset('assets/images/long.jpg',fit: BoxFit.cover,width: double.infinity,height: 170,),
                          ),
                        ),
                        SizedBox(child: Text('Model',style: TextStyle(fontSize: 14),),height: 20)
                      ]
                    )
                  ),
                  Container(
                    child: Column(
                      children: [
                        SizedBox(
                          
                          child: TextButton(
                          onPressed: ()async{

                            Navigator.push(context, MaterialPageRoute(builder: (context) => FirebaseStorageScreen(albumName: 'Model')));
                          },
                          child: Image.asset('assets/images/night.jpg',fit: BoxFit.cover,width: double.infinity,height: 170,),
                          ),
                        ),
                        SizedBox(child: Text('Night Vision',style: TextStyle(fontSize: 14),),height: 20)
                      ]
                    )
                  ),
                
                  Container(
                    child: Column(
                      children: [
                        SizedBox(
                          child: TextButton(
                          onPressed: (){
                            albumName = 'ABCDEFGHIJKLMN14';
                            Navigator.of(context).push(_createRoute(albumName!));
                          },
                          child: Image.asset('assets/images/Main.jpg',fit: BoxFit.cover,width: 200,height: 175,),
                          ),
                        ),
                        Text('ABCDEFGHIJKLMN14',style: TextStyle(fontSize: 14),)
                      ]
                    )
                  ),
                
                  Container(
                    child: Column(
                      children: [
                        SizedBox(
                          child: TextButton(
                          onPressed: (){
                            Navigator.of(context).push(_createRoute(albumName!));
                          },
                          child: Image.asset('assets/images/Main2.jpg',fit: BoxFit.cover,width: 200,height: 165,),
                          ),
                        ),
                        Text('Album1',style: TextStyle(fontSize: 11),)
                      ]
                    )
                  ),
                
                  Container(
                    child: Column(
                      children: [
                        SizedBox(
                          child: TextButton(
                          onPressed: (){
                            Navigator.of(context).push(_createRoute(albumName!));
                          },
                          child: Image.asset('assets/images/map_2017.png',fit: BoxFit.cover,width: 200,height: 165,),
                          ),
                        ),
                        Text('Album1',style: TextStyle(fontSize: 11),)
                      ]
                    )
                  ),
                
                  Container(
                    child: Column(
                      children: [
                        SizedBox(
                          child: TextButton(
                          onPressed: (){
                            Navigator.of(context).push(_createRoute(albumName!));
                          },
                          child: Image.asset('assets/images/long.jpg',fit: BoxFit.cover,width: 200,height: 165,),
                          ),
                        ),
                        Text('Album1',style: TextStyle(fontSize: 11),)
                      ]
                    )
                  ),
                
                  Container(
                    child: Column(
                      children: [
                        TextButton(
                        onPressed: null,
                        child: Image.asset('assets/images/Main.jpg'),
                        ),
                        Text('Album1',style: TextStyle(fontSize: 11),)
                      ]
                    )
                  ),
                
                  Container(
                    child: Column(
                      children: [
                        TextButton(
                        onPressed: null,
                        child: Image.asset('assets/images/Main.jpg'),
                        ),
                        Text('Album1',style: TextStyle(fontSize: 11),)
                      ]
                    )
                  ),
                
                  Container(
                    child: Column(
                      children: [
                        TextButton(
                        onPressed: null,
                        child: Image.asset('assets/images/Main.jpg'),
                        ),
                        Text('Album1',style: TextStyle(fontSize: 11),)
                      ]
                    )
                  ),
                
                  Container(
                    child: Column(
                      children: [
                        TextButton(
                        onPressed: null,
                        child: Image.asset('assets/images/Main.jpg'),
                        ),
                        Text('Album1',style: TextStyle(fontSize: 11),)
                      ]
                    )
                  ),
                
                  Container(
                    child: Column(
                      children: [
                        TextButton(
                        onPressed: null,
                        child: Image.asset('assets/images/Main.jpg'),
                        ),
                        Text('Album1',style: TextStyle(fontSize: 11),)
                      ]
                    )
                  ),
                  Container(
                    child: Column(
                      children: [
                        TextButton(
                        onPressed: null,
                        child: Image.asset('assets/images/long.jpg'),
                        ),
                        Text('Album1',style: TextStyle(fontSize: 11),)
                      ]
                    )
                  ),
                  Container(
                    child: Column(
                      children: [
                        TextButton(
                        onPressed: null,
                        child: Image.asset('assets/images/Main.jpg'),
                        ),
                        Text('Album1',style: TextStyle(fontSize: 11),)
                      ]
                    )
                  ),
                
                ],
              ),
            ),
        ),
      );
  }
}