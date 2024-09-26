import 'package:eschool/app/app.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

///[V.1.3.3]
Future<void> main() async {
  await initializeApp();
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print("ttttttttttttttttttttttttttttttttttttttttttttttttt");
  print(fcmToken);
  print("ttttttttttttttttttttttttttttttttttttttttttttttttt");
}
