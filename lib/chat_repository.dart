import 'package:chat/chat_message_model.dart';
import 'package:chat/token_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dio/dio.dart';


class ChatRepository {
  final _firestore = FirebaseFirestore.instance;

  String getChatRoomId(String user1, String user2) {
    final sorted = [user1, user2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  Stream<List<ChatMessage>> getMessages(String user1, String user2) {
    final roomId = getChatRoomId(user1, user2);
    return _firestore
        .collection('chats')
        .doc(roomId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ChatMessage.fromJson(doc.data()))
              .toList(),
        );
  }


final _dio = Dio();
final serverKey = '<YOUR_FIREBASE_SERVER_KEY>'; // Get from Firebase console > Project settings > Cloud Messaging tab

Future<void> sendMessage(ChatMessage message, String receiverToken) async {
  final roomId = getChatRoomId(message.sender, message.receiver);
  await _firestore
      .collection('chats')
      .doc(roomId)
      .collection('messages')
      .add(message.toJson());

final receiverToken = await TokenService.getPeerToken();
  if (receiverToken != null) {
    // call FCM push logic (as done earlier)
    // await sendPushNotification(message, receiverToken);
  }
  // Send push notification
  await _dio.post(
    'https://fcm.googleapis.com/fcm/send',
    data: {
      "to": receiverToken,
      "notification": {
        "title": message.sender,
        "body": message.text,
      },
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "sender": message.sender,
        "message": message.text,
      }
    },
    options: Options(headers: {
      'Authorization': 'key=$serverKey',
      'Content-Type': 'application/json',
    }),
  );
}


}
