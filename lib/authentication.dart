import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart' as http;

class Authentication{

   signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    print('google user ${googleUser}');

   if(googleUser != null){
     Map map ={
       'full_name': googleUser.displayName,
       'email': googleUser.email,
       'social_id': googleUser.id,
       'photoUrl': googleUser.photoUrl,
       'serverAuthCode': googleUser.serverAuthCode,
     };
     var res = await http.post(Uri.parse('https://4dc0-119-152-136-49.ngrok.io/auth/user/info'),
         body:  jsonEncode(map)
     );

     var parsedData = json.decode(res.body);
     print('status code ${res.statusCode}');
     print('response body  ${res.body}');
     //if(parsedData['message'] == 'User Created'){
       return 'ok';
    // }
   }



  }

    signInWithFacebook() async {
     // Trigger the sign-in flow
     final LoginResult loginResult = await FacebookAuth.instance.login();

     print('loginResult ${loginResult.accessToken?.token}');

   }


}