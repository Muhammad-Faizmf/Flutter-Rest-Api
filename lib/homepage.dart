
// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:restapi/models/postsModel.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  const Homepage({ Key? key }) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  List<PostsModel> postlist = [];
  List<Photos> photolist = [];

  Future<List<PostsModel>> GetPosts() async {
    var res = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));

    var data = jsonDecode(res.body.toString());

    if(res.statusCode == 200){
      // print("data found");
      for(Map x in data){
        postlist.add(PostsModel.fromJson(x));
      }
      return postlist;
    }
    else {
      // print("data NOT found");
      return postlist;
    }
    
  }

  Future<List<Photos>> GetPhotos() async {
    var res = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/photos"));

    var data = jsonDecode(res.body.toString());

    if(res.statusCode == 200){
      for(Map x in data){
        Photos photos = Photos(title: x['title'], id: x['id']);
        photolist.add(photos);
      }
      return photolist;
    }
    else {
      return photolist;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Rest Api Course"),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: GetPosts(),
            builder: (context, snapshot) {
              if(!snapshot.hasData){
                return Center(child: CircularProgressIndicator());
              }
              else {
                return FetchingPosts();
              }
            }
          )
        ],
      ),
    );
  }
  Widget FetchingPosts() {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: postlist.length,
        itemBuilder: (context, index){
          return Card(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(postlist[index].id.toString() + " Title ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(postlist[index].title.toString()),                             
                  SizedBox(height: 5.0),
                  Text("Description",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(postlist[index].body.toString())
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  // Widget FetchingPhotos(){
  //   return Expanded(
  //     child: ListView.builder(
  //       shrinkWrap: true,
  //       itemCount: photolist.length,
  //       itemBuilder: (context, index){
  //         return ListTile(
  //           leading: CircleAvatar(
  //             backgroundColor: Colors.grey,
  //             backgroundImage: NetworkImage("https://i.pinimg.com/originals/d5/b0/4c/d5b04cc3dcd8c17702549ebc5f1acf1a.png"),
  //           ),
  //           title: Text("Note id: " + photolist[index].id.toString()),
  //           subtitle: Text(photolist[index].title.toString()) 
  //         );
  //       }
  //     ),
  //   );
  // }

}

class Photos {
  String title;
  int id;
  
  Photos({required this.title, required this.id});
}