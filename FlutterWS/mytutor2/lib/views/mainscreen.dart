// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/subject.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Subject> subjectList = <Subject>[];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  var numofpage, curpage = 1;
  var color;
  TextEditingController searchSubCtrller = TextEditingController(); 
  String search ="";

    @override
  void initState() {
    super.initState();
    _loadSubject(1, search);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    if (screenHeight <= 600){
      resWidth = screenHeight;
    } else {
      resWidth = screenWidth * 0.75;
    }
    return Scaffold(     
      appBar : AppBar(
        title: const Text('MYTUTOR'),
        backgroundColor: Colors.blueGrey[900],
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _loadSearchDialog();
             },       
            ),           
        ],
      ),
      body: subjectList.isEmpty
      ? Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)))
       :Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text("List of Subjects Available",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
           const SizedBox(
                height: 15,
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children:
                  List.generate(subjectList.length, (index) {
                    return Card(
                      child: Column(
                        children: [ 
                          Flexible(
                            flex: 6,
                            child: CachedNetworkImage(
                              imageUrl: CONSTANTS.server + 
                              "/mytutor2/assets/images/courses/" + 
                              subjectList[index].subjectId.toString()+'.png',
                              placeholder: (context, url) =>
                               const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                               const Icon(Icons.error),
                            ),
                          ),
                          Flexible(
                            flex: 4,
                            child: Column(
                              children: [
                                Text(subjectList[index].subjectName.toString()),
                                Text("RM"+subjectList[index].subjectPrice.toString()),
                              ])
                          )
                        ])
                    );
  }))
         ),
                  SizedBox(
                    height: 30,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: numofpage,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        if ((curpage-1) == index) {
                          color = Colors.red;
                        } else {
                          color = Colors.black;
                        }
                        return SizedBox(
                          width: 40,
                          child: TextButton(
                            onPressed: () => {_loadSubject(index + 1, search)},
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(color: color),
                            )
                          )
                        );
                      }
                    )
                  )
        ]
      ),
    );
  }
  
  void _loadSubject(int pageno, String _search) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(
      Uri.parse(CONSTANTS.server + "/mytutor2/php/load_subjects.php"),
        body: {'pageno': pageno.toString(),
        'search': _search,
        }).then((response) {
          var jsondata = jsonDecode(response.body);
          print(jsondata);
          if (response.statusCode == 200 && jsondata['status'] == 'success') {
            var extractdata = jsondata['data'];
            numofpage = int.parse(jsondata['numofpage']);

            if (extractdata['subjects'] != null) {
              subjectList = <Subject>[];
              extractdata['subjects'].forEach((v) {
                subjectList.add(Subject.fromJson(v));
              });
              // setState(() {
              // });
            } else {
              titlecenter = "No Subject Available";
            }
              setState(() {});                    
          }
        });
  }
  
  void _loadSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: const Text(
            "Search",
          ),
          content: SizedBox(
            height: screenHeight/5,
            child: Column(
              children: [          
                TextField(
                  controller: searchSubCtrller,
                  decoration: InputDecoration(
                    labelText: 'Search subject',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)
                    )
                  )
                ),
                ElevatedButton(
                  onPressed: (){
                    search = searchSubCtrller.text;
                    Navigator.of(context).pop();
                     _loadSubject(1, search);
                  },               
                child: const Text("Search"),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
                style: TextStyle()
              ),
              onPressed: (){
                Navigator.of(context).pop();
              },)
          ]
        );
      },
    );       
  }
} 
