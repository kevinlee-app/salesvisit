import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:salesvisit/models/userdata.dart';
import 'package:salesvisit/services/database.dart';

class FunctionsService {

    Future registerWithEmailandPassword(UserData userData) async {
      final HttpsCallable callable = CloudFunctions(app: FirebaseApp.instance, region: 'asia-east2').getHttpsCallable(
          functionName: 'createUserWithEmailAndPassword',
      );

      HttpsCallableResult response;

      try {
        response = await callable.call(<String, dynamic>{
            "email": userData.email,
            "password": userData.password,
        });
        final uid = response.data["uid"];
        if (uid != null) {
          final uid = response.data["uid"];
          await DatabaseService(uid: uid).insertNewUserData(userData);
        }
      } catch (e) {

      }

      return response;
    }
}
