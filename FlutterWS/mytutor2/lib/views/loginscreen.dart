import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mytutor2/views/menuScreen.dart';
import 'package:mytutor2/views/registerscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../models/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late double screenHeight, screenWidth, ctrWidth;
  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool remember = false;
  
   @override
  void initState() {
    super.initState();
    loadPref();
  }
  
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    if(screenWidth<=600) {
      ctrWidth = screenWidth;
    } 
    else {
      ctrWidth = screenWidth * 0.75;
    }

    return Scaffold(
      appBar: AppBar(
          title: const Text('MYTUTOR APP'),
          backgroundColor: Colors.blueGrey[900],
        ),
      body: Stack(    
        children: [upperHalf(context), lowerHalf(context)],
      ),
    );
  }

  Widget upperHalf(BuildContext context) {
    return SizedBox(
      height: screenHeight / 1.7,
      width: screenWidth,
      child: Image.asset(
        'assets/images/onlineTutor.jpg',
      fit: BoxFit.cover,
      ),
    );
  }

  Widget lowerHalf(BuildContext context) {
    return Container(
      width: ctrWidth,
      margin: EdgeInsets.only(top: screenHeight / 3.5),  
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: SingleChildScrollView(
          child: Column(
          children: [
            Card(
              elevation: 10,
              child: Container(
                  padding: const EdgeInsets.fromLTRB(25, 10, 20, 25),
                  child: Form(
                    key: _formKey,
                    child: Column(
                        children: [
                          Text(
                            "LOGIN",
                            style: TextStyle(
                              fontSize: ctrWidth * 0.06,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
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
                                  labelStyle: TextStyle(fontSize: 22),
                                  labelText: 'Email',
                                  icon: Icon(
                                    Icons.mail,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                                  const SizedBox(height: 5),
                                   TextFormField(
                            textInputAction: TextInputAction.done,
                            validator: (val) =>
                                val!.isEmpty ? "Please enter your password" : null,
                            focusNode: focus1,
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).requestFocus(focus2);
                            },
                            controller: _passwordController,
                            decoration: const InputDecoration(
                                errorStyle: TextStyle(fontSize: 14.0),
                                labelStyle: TextStyle(fontSize: 22),
                                labelText: 'Password',
                                icon: Icon(
                                  Icons.lock
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                )),
                            obscureText: true,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Checkbox(
                                  value: remember,
                                  onChanged: (bool? value) {
                                    _onRememberMe(value!);
                                  },
                                ),
                                const Flexible(
                                  child: Text('Remember Me  ',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ), 
                                ElevatedButton(
                                  style: 
                                      ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blue.shade600),
                                      fixedSize: MaterialStateProperty.all(Size(screenWidth/3, 47)),
                                      ),
                    
                                  child: const Text('Login',
                                  style: TextStyle(fontSize: 20)),
                                  onPressed: _loginUser,
                                ),
                              ]),
                        ],
                      ),
                    ))),
            const SizedBox(
              height: 18,
            ),
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("Register new account?  ",
                    style: TextStyle(fontSize: 18.0)),
                GestureDetector(
                  onTap: () =>{
                    Navigator.push(context, 
                    MaterialPageRoute(builder: (BuildContext context) => 
                    const RegisterScreen()))
                  },
                  child: const Text(
                    "Register here",
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                    color: Colors.black,
                    offset: Offset(0, 0))
              ], 
            ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        )));
  }

  void _saveRemovePref(bool value) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String email = _emailController.text;
      String password = _passwordController.text;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (value) {
        await prefs.setString('email', email);
        await prefs.setString('pass', password);
        await prefs.setBool('remember', true);
        Fluttertoast.showToast(
            msg: "Preference Stored",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
      } else {
        await prefs.setString('email', '');
        await prefs.setString('pass', '');
        await prefs.setBool('remember', false);
        _emailController.text = "";
        _passwordController.text = "";
        Fluttertoast.showToast(
            msg: "Preference Removed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Preference Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      remember = false;
    }
  }

  void _onRememberMe(bool value) {
    remember = value;
    setState(() {
      if (remember) {
        _saveRemovePref(true);
      } else {
        _saveRemovePref(false);
      }
    });
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    remember = (prefs.getBool('remember')) ?? false;

    if (remember) {
      setState(() {
        _emailController.text = email;
        _passwordController.text = password;
        remember = true;
      });
    }
  }

   void _loginUser() {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      http.post(Uri.parse(CONSTANTS.server + "/mytutor2/php/login_user.php"),
        body: {"email": email, 
              "password": password}).then((response) {
          // ignore: avoid_print
          print(response.body);
          var data = jsonDecode(response.body);
          if (response.statusCode == 200 && data['status'] == 'success') {
          User user = User.fromJson(data['data']);
   
             Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
              Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (content) => MenuScreen(user: user,))
                    );
          }
          else{
             Fluttertoast.showToast(
              msg: "Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
          }
        });
    }
  }
}