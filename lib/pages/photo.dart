import 'package:flutter/material.dart';

class PhotoSelect extends StatefulWidget {
  String? albumName = '';
  String? imageURL ='';
  PhotoSelect({super.key,required this.albumName,required this.imageURL});

  @override
  State<PhotoSelect> createState() => _PhotoSelectState();
}

class _PhotoSelectState extends State<PhotoSelect> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.albumName!),
    ),
      body: Container(
        width: double.infinity,
        child: Image.network(widget.imageURL!),
      )
    );
  }
}