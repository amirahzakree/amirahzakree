import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/subject.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({Key? key}) : super(key: key);

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  List<Subject> subjectList = <Subject>[];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  var numofpage, currentpage = 1;
  var color;

    @override
  void initState() {
    super.initState();
    _loadSubject(1);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    if (screenHeight <= 600){
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }
    return Scaffold(
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
              itemBuilder: (context, index){
                if ((currentpage-1)==index) {
                  color = Colors.red;
                } else {
                  color = Colors.black;
                }
                return SizedBox(
                  width: 40, 
                  child: TextButton(
                    onPressed: () => {_loadSubject(index+1)},
                    child: Text(
                      (index + 1).toString(),
                      style: TextStyle(color:color),
                    ))
                  );
             },
           )
          )
        ]
      ),
    );
  }
  
  void _loadSubject(int pageno) {
    currentpage = pageno;
    numofpage ?? 1;
    http.post(
      Uri.parse(CONSTANTS.server + "/mytutor2/php/load_subjects.php"),
        body: {'pageno':pageno.toString()}).then((response) {
          var jsondata = jsonDecode(response.body);
         // print(jsondata);
          if (response.statusCode == 200 && jsondata['status'] == 'success') {
            var extractdata = jsondata['data'];
            numofpage = int.parse(jsondata['numofpage']);
            if (extractdata['subjects'] != null) {
              subjectList = <Subject>[];
              extractdata['subjects'].forEach((v) {
                subjectList.add(Subject.fromJson(v));
              });
            }
          
          }
        });
  }
}