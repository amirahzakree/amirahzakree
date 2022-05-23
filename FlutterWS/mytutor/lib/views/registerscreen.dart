import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mytutor/views/loginscreen.dart';
//import 'package:ndialog/ndialog.dart';
import '../constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key,}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();  
}

class _RegisterScreenState extends State<RegisterScreen> {
  late double screenHeight, screenWidth, ctrlWidth;
  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  String pathAsset = 'assets/images/camera.png';
  // ignore: prefer_typing_uninitialized_variables
  var _image;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _homeAddController = TextEditingController();
  bool _passwordVisible = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    if(screenWidth<=600){
      ctrlWidth = screenWidth;
    }else{
      ctrlWidth = screenWidth * 0.10;
    }
    return Scaffold(
      appBar: AppBar(
          title: const Text('Register New Account',
          style: TextStyle(fontSize: 22)),    
          backgroundColor: Colors.blueGrey[900],
        ),
      body: SingleChildScrollView(
        child: Column (children: [
    Container(
      width: ctrlWidth,
      margin: EdgeInsets.only(top: screenHeight / 6.9),
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 10,
              child: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(25, 25, 20, 30),
                  child: Column(children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                     Card(
              child: GestureDetector(
                  onTap: () => {_takePictureDialog()},
                  child: SizedBox(
                      height: screenHeight / 4.0,
                      width: screenWidth,
                      child: _image == null
                          ? Image.asset(pathAsset)
                          : Image.file(
                              _image,
                              fit: BoxFit.cover,
                            ))),
            ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: (val) => val!.isEmpty || (val.length < 3)
                          ? "Name must be longer than 3"
                          : null,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(focus);
                        },
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(fontSize: 20.0),
                          errorStyle: TextStyle(fontSize: 14.0),
                          icon: Icon(Icons.person),
                          focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 0.5),
                            ))),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: (val) => val!.isEmpty ||
                            !val.contains("@") ||
                            !val.contains(".")
                            ? "Please enter a valid email"
                            : null,
                        focusNode: focus,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(focus1);
                        },
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            errorStyle: TextStyle(fontSize: 14.0),
                            labelStyle: TextStyle(fontSize: 20.0),
                            labelText: 'Email',
                            icon: Icon(Icons.mail),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 0.5),
                            ))),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: (val) => validatePassword(val.toString()),
                      focusNode: focus1,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(focus2);
                      },
                      controller: _passwordController,
                      decoration: InputDecoration(
                          errorStyle: const TextStyle(fontSize: 14.0),
                          labelStyle: const TextStyle(fontSize: 20.0),
                          labelText: 'Password',
                          icon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(width: 0.5),
                          )),
                      obscureText: _passwordVisible,
                    ),
                    TextFormField(
                      style: const TextStyle(),
                      textInputAction: TextInputAction.done,
                      validator: (val) {
                        validatePassword(val.toString());
                        if (val != _passwordController.text) {
                          return "Password do not match";
                        } else {
                          return null;
                        }
                      },
                      focusNode: focus2,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(focus3);
                      },
                      controller: _rePasswordController,
                      decoration: InputDecoration(
                          errorStyle: const TextStyle(fontSize: 14.0),
                          labelText: 'Re-enter Password',
                          labelStyle: const TextStyle(fontSize: 20.0),
                          icon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(width: 0.5),
                          )),
                      obscureText: _passwordVisible,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: (val) => val!.isEmpty || (val.length < 3)
                          ? "Phone number must be longer than 3"
                          : null,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(focus);
                        },
                      controller: _phoneNoController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          labelStyle: TextStyle(fontSize: 20.0),
                          errorStyle: TextStyle(fontSize: 14.0),
                          icon: Icon(Icons.phone),
                          focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 0.5),
                            ))),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: (val) => val!.isEmpty || (val.length < 3)
                          ? "Home address must be longer than 3"
                          : null,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(focus);
                        },
                      controller: _homeAddController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                          labelText: 'Home Address',
                          labelStyle: TextStyle(fontSize: 20.0),
                          errorStyle: TextStyle(fontSize: 14.0),
                          icon: Icon(Icons.home),
                          focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 0.5),
                            ))),  
                    const SizedBox(
                      height: 15,
                    ),      
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                           ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize: Size(screenWidth / 3, 50)),
                            child: const Text('Register',
                            style: TextStyle(fontSize: 17.0, color: Colors.white)),
                            onPressed: _registerAccountDialog,
                                ),
                  ]),
                ]),
              ),
              ),
      )] ),
      ))]),
      )
      );
  }

  String? validatePassword(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter password first';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Mix upper and lowercase letters with number';
      } else {
        return null;
      }
    }
  }

   void _registerAccountDialog() {
    if (!_formKey.currentState!.validate()) {
      
      Fluttertoast.showToast(
        msg: "Please complete registration form first",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 18.0);
        return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Register New Account ",
            style: TextStyle(fontSize: 24.0),
          ),
          content: const Text(
            "Are you sure?",
            style: TextStyle(fontSize: 20.0),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(fontSize: 20.0),
              ),
              onPressed:() {
                Navigator.of(context).pop();
                _registerUserAccount();
              } 
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(fontSize: 20.0),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
   }

  void _registerUserAccount() { 
  FocusScope.of(context).requestFocus(FocusNode()); 
  String _name = _nameController.text;
  String _email = _emailController.text;
  String _password = _passwordController.text;
  String _phoneNo = _phoneNoController.text;
  String _homeAdd = _homeAddController.text;
  // ignore: unused_local_variable
  String base64Image = base64Encode(_image!.readAsBytesSync());

  //FocusScope.of(context).unfocus();
  //ProgressDialog progressDialog = ProgressDialog(context, 
  //message: const Text("Registration in progress.."), 
  //title: const Text("Registering..."));
  //progressDialog.show();

  http.post(Uri.parse(CONSTANTS.server + "/mytutor/php/register_user.php"), 
  body: {
    "user_name": _name, 
    "user_email": _email, 
    "user_pass": _password, 
    "user_phoneNo": _phoneNo, 
    "user_homeAdd": _homeAdd,
    "image": base64Image,
  }).then((response) {
    // ignore: avoid_print
    print(response.body);
    var data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['status'] == 'success') { 
      // ignore: unused_local_variable
      Fluttertoast.showToast(
        msg: "Registration Successful", 
        toastLength: Toast.LENGTH_SHORT, 
        gravity: ToastGravity.BOTTOM, 
        timeInSecForIosWeb: 1, 
        textColor: Colors.red,
        fontSize: 18.0); 
       //progressDialog.dismiss(); 
        Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const LoginScreen()));
        return;
    } else {
        Fluttertoast.showToast(
          msg: "Account already exist.", 
          toastLength: Toast.LENGTH_SHORT, 
          gravity: ToastGravity.BOTTOM, 
          timeInSecForIosWeb: 1, 
          textColor: Colors.red,
          fontSize: 18.0); 
         // progressDialog.dismiss(); 
          return;
    } 
});
}

  _takePictureDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title: const Text(
              "Select from",
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                    onPressed: () => {
                          Navigator.of(context).pop(),
                          _galleryPicker(),
                        },
                    icon: const Icon(Icons.browse_gallery),
                    label: const Text("Gallery")),
                TextButton.icon(
                    onPressed: () =>
                        {Navigator.of(context).pop(), 
                        _cameraPicker()},
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Camera")),
              ],
            ));
      },
    );
  }

 _galleryPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _cropImage();
    }
  }

   _cameraPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _cropImage();
    }
  }

  Future<void> _cropImage() async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: _image!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.blueGrey.shade900,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }
}
  
