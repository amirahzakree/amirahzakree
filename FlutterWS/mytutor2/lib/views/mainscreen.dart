// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mytutor2/views/cartscreen.dart';
import '../constants.dart';
import '../models/subject.dart';
import '../models/user.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Subject> subjectList = <Subject>[];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  var numofpage, curpage = 1;
  var color;
  int cart = 0;
  TextEditingController searchSubCtrller = TextEditingController(); 
  String search ="";

    @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp){
    _loadSubject(1, search);
    });
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
          TextButton.icon(onPressed: () async {
            await Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (content) => CartScreen(
                            user: widget.user,)));
                _loadSubject(1, search);
                _loadMyCart();
          },
          icon: const Icon(
            Icons.shopping_cart,
            color: Colors.white,
          ),
          label: Text(widget.user.cart.toString(),
          style: const TextStyle(color: Colors.white)),
          )
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
              childAspectRatio: 1/1,
              children:
                  List.generate(subjectList.length, (index) {
                    return Card(
                     // color: Colors.tealAccent,
                      color: const Color.fromARGB(171, 102, 156, 168),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        ),
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
                                Row (
                              children: [
                                Expanded (
                                  flex: 7,
                                  child: Column(children:[
                                Text(subjectList[index].subjectName.toString()),
                                Text("RM"+subjectList[index].subjectPrice.toString()),
                              ])
                          ),
                          Expanded(
                            flex: 3,
                            child: IconButton(
                              onPressed: () {
                                _addtoCartDialog(index);
                              },
                              icon: const Icon(
                                Icons.shopping_cart_rounded))),
                        ])
                  ]))]));
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
                  ),
                  ],
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
  
  void _addtoCart(int index) {
     http.post(
       Uri.parse(CONSTANTS.server + "/mytutor2/php/insert_cart.php"),
       body: {
         "email": widget.user.email.toString(),
         "subid": subjectList[index].subjectId.toString(),
       }).timeout(
         const Duration (seconds: 5),
         onTimeout: (){
           return http.Response(
             'Error', 408);
         },
       ).then((response) {
         print(response.body);
         var jsondata = jsonDecode(response.body);
         if (response.statusCode == 200 && jsondata ['status'] == 'success'){
           print(jsondata['data']['carttotal'].toString());
           setState(() {
             widget.user.cart = jsondata['data']['carttotal'].toString();
           });
         Fluttertoast.showToast(
          msg: "Success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
           timeInSecForIosWeb: 1,
           fontSize: 16.0
         );
        }

       });

  }
  
  void _addtoCartDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
            
          title: const Text (
            "ADD TO CART",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text ("Are you sure you want to add this subject?", style: TextStyle(fontSize: 18.0)),
          actions: <Widget>[
            TextButton (
              child: const Text (
                "YES",
                style: TextStyle(fontSize: 18.0),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                _addtoCart(index);
              },
            ),
            TextButton (
              child: const Text(
                "NO",
                style: TextStyle(fontSize: 18.0),
              ),
              onPressed: (){
                Navigator.of(context).pop();
              })
          ]
        );
      }
    );
  }
  
  void _loadMyCart() {
     http.post(
        Uri.parse(CONSTANTS.server + "/mytutor2/php/load_mycartqty.php"),
        body: {
          "email": widget.user.email.toString(),
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        print(jsondata['data']['carttotal'].toString());
        setState(() {
          widget.user.cart = jsondata['data']['carttotal'].toString();
        });
      }
    });
    
  }
} 
