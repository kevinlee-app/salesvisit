import 'package:salesvisit/models/visit.dart';

class UserData {
  String uid;
  String name;
  String email;
  String phone;
  String password;
  int type = 1; //0 = admin, 1 = user;

  bool get isAdmin{
    return type == 0;
  }

  UserData({this.uid, this.name, this.email, this.phone, this.password, this.type});
}