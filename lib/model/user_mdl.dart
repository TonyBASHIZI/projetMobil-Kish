import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zakuuza/model/api.dart';

class Users{
  final String id;
  final String fullname, email, username,password,telephone;

  Users({this.id, this.fullname, this.email, this.username, this.password, this.telephone});

  factory Users.fromJson(Map<String,dynamic> jsonData){
    return new Users(
      id : jsonData['code_client'],
      fullname : jsonData['nom'],
      email : jsonData['email'],
      username : jsonData['username'],
      password : jsonData['pwd'],
      telephone : jsonData['tel'],
    );
  }

  static Future createProfile(Users user) async{
  final jsonEndPoint = BaseUrl.signin;

  await http.post(jsonEndPoint,body: {
    "nom":user.fullname,
    "email":user.email,
    "username":user.username,
    "pwd":user.password,
    "tel":user.telephone
  }).then((http.Response response){
    final res = response.body;
    final statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("error while fetching data");
    } else{
      return json.decode(res);
    }
  });
}
}
