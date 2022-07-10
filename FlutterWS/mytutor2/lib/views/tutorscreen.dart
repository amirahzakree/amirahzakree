// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
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
  var numofpage, curpage = 1;
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
      resWidth = screenHeight;
    } else {
      resWidth = screenWidth * 0.75;
    }
    return Scaffold(
      appBar : AppBar(
        title: const Text('MYTUTOR'),
        backgroundColor: Colors.blueGrey[900],
        ),
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
                    return InkWell(
                      splashColor: Colors.blueAccent,
                      onTap: ()=> {
                        _loadTutorDetails(index)
                      },
                      child: Card(
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
                      ),
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
                            onPressed: () => {_loadTutors(index + 1)},
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
  
  void _loadTutors(int pageno) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(
      Uri.parse(CONSTANTS.server + "/mytutor2/php/load_tutors.php"),
        body: {'pageno' : pageno.toString()}).then((response) {
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
             // setState(() {});
            } else {
              titlecenter = "No Tutor Available";
            } 
            setState(() {});       
          }
        });
  }
  
  _loadTutorDetails(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "TUTOR PROFILE",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(child: 
          Column(children: [
            CachedNetworkImage(
              imageUrl: CONSTANTS.server + 
              "/mytutor2/assets/images/tutors/" +
              tutorList[index].tutorId.toString() + 
              '.jpg',
              fit: BoxFit.cover,
              width: resWidth,
              placeholder: (context, url) => 
                  const LinearProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error)
              ),
               Text(
                tutorList[index].tutorName.toString(),
                style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold)
              ),
              // const SizedBox(height: 5), 
              // Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              //   Text("Contact:  " + tutorList[index].tutorPhone.toString()),
              //   const SizedBox(height: 10), 
              //   Text("Email:  " + tutorList[index].tutorEmail.toString()),
              //   const SizedBox(height: 10), 
              //   Text("About Me:  " + tutorList[index].tutorDescription.toString()),
              //   const SizedBox(height: 10), 
              //   Text("Subject:  " + tutorList[index].subjectName.toString()),
              // ]
             // )
          ],)),
        );
      }
    );
  }
}