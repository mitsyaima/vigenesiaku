import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:vigenesia/Screens/MainScreen.dart';
import 'package:vigenesia/Screens/Register.dart';
import '/../Models/Login_Model.dart';
import "package:vigenesia/Constant/const.dart";

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  String? nama;
  String? iduser;

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  Future<LoginModels?> postLogin(String email, String password) async {
    var dio = Dio();
    String baseurl = url;
    LoginModels? model;

    Map<String, dynamic> data = {"email": email, "password": password};
    print("$baseurl/api/login");

    try {
      final Response = await dio.post("$baseurl/api/login/",
          data: data,
          options: Options(headers: {'cotent-type': 'application/json'}));

      print("Respon -> ${Response.data} + ${Response.statusCode}");

      if (Response.statusCode == 200) {
        final loginModel = LoginModels.fromJson(Response.data);
        return loginModel;
      }
    } catch (e) {
      print("Failed To Load $e");
    }
    return null;
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //leading: Icon(Icons.home),
        title: Text('Visi Generasi Indonesia'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Container(
                // color: Colors.redAccent,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Login Area-Security System',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w500),
                      ),
                      // ============ TEXT BOX EMAIL ================
                      SizedBox(height: 50),
                      Center(
                        child: Form(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.3,
                            child: Column(
                              children: [
                                FormBuilderTextField(
                                  name: "email",
                                  cursorColor: Colors.red,
                                  controller: emailController,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 10),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                      ),
                                      labelStyle: TextStyle(color: Colors.red),
                                      labelText: "Email"),
                                ),
                                // ============ TEXT BOX PASWORD ================
                                SizedBox(
                                  height: 20,
                                ),
                                FormBuilderTextField(
                                  obscureText: true,
                                  name: "Password",
                                  controller: passwordController,
                                  cursorColor: Colors.red,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 10),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        borderSide: BorderSide(
                                            color: Colors.red, width: 0.0),
                                      ),
                                      labelText: "Password",
                                      labelStyle: TextStyle(color: Colors.red)),
                                ),
                                // ============ TEXT No Account ================
                                SizedBox(
                                  height: 30,
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Dont have account ?',
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                      TextSpan(
                                        text: ' Sign Up',
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        new Register()));
                                          },
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 40),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.red),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ))),
                                    onPressed: () async {
                                      await postLogin(emailController.text,
                                              passwordController.text)
                                          .then((value) => {
                                                if (value != null)
                                                  {
                                                    setState(() {
                                                      nama = value.data!.nama;
                                                      Navigator.pushReplacement(
                                                          context,
                                                          new MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  new MainScreen(
                                                                      nama:
                                                                          nama!)));
                                                    })
                                                  }
                                                else if (value == null)
                                                  {
                                                    Flushbar(
                                                      message:
                                                          "Check Your Email/Password",
                                                      duration:
                                                          Duration(seconds: 5),
                                                      backgroundColor:
                                                          Colors.redAccent,
                                                      flushbarPosition:
                                                          FlushbarPosition.TOP,
                                                    ).show(context)
                                                  }
                                              });
                                    },
                                    child: Text("Sign In"),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      //awal script textfield email
                    ],
                  ),
                ))),
      ),
    );
  }
}
