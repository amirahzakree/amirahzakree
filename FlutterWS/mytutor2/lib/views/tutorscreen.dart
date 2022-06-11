import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mytutor2/constants.dart';
import '../models/tutor.dart';

class TutorScreen extends StatefulWidget {
  const TutorScreen({Key? key}) : super(key: key);

  @override
  State<TutorScreen> createState() => _TutorScreenState();
}

class _TutorScreenState extends State<TutorScreen> {
  List<Tutor> tutorList = <Tutor>[];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  var numofpage, currentpage = 1;
  var color;

    @override
  void initState() {
    super.initState();
    _loadTutors(1);
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
   body: tutorList.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)))
       :Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text("List of Tutors Available",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children:
                  List.generate(tutorList.length, (index) {
                    return Card(
                      child: Column(
                        children: [ 
                          Flexible(
                            flex: 6,
                            child: CachedNetworkImage(
                              imageUrl: CONSTANTS.server + 
                              "/mytutor2/assets/images/tutors/" + 
                              tutorList[index].tutorId.toString()+'.jpg',
                              placeholder: (context, url) =>
                               const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                               const Icon(Icons.error),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Flexible(
                            flex: 4,
                            child: Center(
                            child: Column(
                              children: [
                                Text(tutorList[index].tutorName.toString()),
                              const SizedBox(height: 5),                 
                                Text("Contact: " + tutorList[index].tutorPhone.toString()),
                              const SizedBox(height: 5),
                              ])
                          )
                      )])
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
                    onPressed: () => {_loadTutors(index + 1)},
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
  
  void _loadTutors(int pageno) {
    currentpage = pageno;
    numofpage ?? 1;
    http.post(
      Uri.parse(CONSTANTS.server + "/mytutor2/php/load_tutors.php"),
        body: {'pageno':pageno.toString()}).then((response) {
          var jsondata = jsonDecode(response.body);
          print(jsondata);
          if (response.statusCode == 200 && jsondata['status'] == 'success') {
            var extractdata = jsondata['data'];
            numofpage = int.parse(jsondata['numofpage']);
            if (extractdata['tutors'] != null) {
              tutorList = <Tutor>[];
              extractdata['tutors'].forEach((v) {
                tutorList.add(Tutor.fromJson(v));
              });
            }
          
          }
        });
  }
}