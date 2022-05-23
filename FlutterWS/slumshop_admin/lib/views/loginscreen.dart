import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late double screenHeight, screenWidth;
  bool remember = false;
  TextEditingController emailCtrller = TextEditingController();
  TextEditingController passwordCtrller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                      SizedBox(
                          height: screenHeight / 2.5,
                          width: screenWidth,
                          child: Image.asset('assets/images/slumshoplogo.png')),
                      const Text(
                        "Login/Admin",
                        style: TextStyle(fontSize: 24),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: TextField(
                          controller: emailCtrller,
                          decoration: InputDecoration(
                            hintText: "Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                              keyboardType: TextInputType.emailAddress,
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: TextField(
                          controller: passwordCtrller,
                          decoration: InputDecoration(
                            hintText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              ),
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: remember,
                            onChanged:_onRememberMe),
                          const Text("Remember Me")
                        ],
                      ),
                      SizedBox(
                        width: screenWidth,
                        height: 50,
                        child: ElevatedButton(
                          child:const Text("Login"),
                        onPressed: _loginUser,
                      ),
                      )
                    ],
                  ),
                ),
              ],
            ),
        ));
  }
  void _onRememberMe(bool? value) {
    setState(() {
      remember = value !;
    });
  }
  void _loginUser() {
    String _email = emailCtrller.text;
    String _password = passwordCtrller.text;
    print(_email);
    if (_email.isNotEmpty && _password.isNotEmpty) {
      http.post(Uri.parse("http://10.19.78.155/slumshop/php/login_user.php"),
        body: {"email": _email, "password": _password}).then((response) {
          print(response.body);
          if (response.body == "success"){
             Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
              
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
