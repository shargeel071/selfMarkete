import 'package:flutter/material.dart';

import 'authentication.dart';
import 'home.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              // side: BorderSide(color: Colors.red)
                            )
                        )
                    ),
                    onPressed: ()async{
                      var res = await Authentication().signInWithGoogle();
                      print('response ${res}');
                      if(res == 'ok'){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));
                      }
                    },
                    child: Center(child: Text("Sign In With Google", style: TextStyle(color: Colors.white)))
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              // side: BorderSide(color: Colors.red)
                            )
                        )
                    ),
                    onPressed: () async {
                      var res = await Authentication().signInWithFacebook();
                      print('response fb ${res}');
                      if(res == 'ok'){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));
                      }
                    },
                    child: Center(child: Text("Sign In With Facebook", style: TextStyle(color: Colors.white)))
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
