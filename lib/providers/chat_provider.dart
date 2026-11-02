import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/message.dart';

class ChatProvider with ChangeNotifier {
  final DatabaseReference _dbRef = FirebaseDatabase.instanceFor(
      app: FirebaseAuth.instance.app,
      databaseURL: "https://coachlink-6ba3f-default-rtdb.firebaseio.com/"
  ).ref("chat_messages");

  List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;

  void listenToMessages() {
    _dbRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        _messages = data.entries.map((entry) {
          return ChatMessage.fromMap(entry.value as Map<dynamic, dynamic>);
        }).toList();
        _messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        notifyListeners();
      } else {
        _messages = [];
        notifyListeners();
      }
    });
  }

  Future<void> sendMessage(String text) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && text.trim().isNotEmpty) {
      try {
        // 1. ندخلو لملف المستخدم باش نجيبو الاسم والتصويرة
        final userRef = FirebaseDatabase.instanceFor(
            app: FirebaseAuth.instance.app,
            databaseURL: "https://coachlink-6ba3f-default-rtdb.firebaseio.com/"
        ).ref("users/${user.uid}");

        final snapshot = await userRef.get();
        String photoUrl = "";
        String fullName = "User"; // قيمة افتراضية إذا مالقاش الاسم

        if (snapshot.exists) {
          final userData = snapshot.value as Map<dynamic, dynamic>;
          photoUrl = userData['profileImage'] ?? "";
          fullName = userData['fullName'] ?? "User"; // هادي هي اللي تجيب الاسم
        }

        // 2. نكريو الميساج بالمعلومات الجديدة
        final newMessage = ChatMessage(
          senderId: user.uid,
          text: text.trim(),
          timestamp: DateTime.now(),
          senderPhotoUrl: photoUrl,
          senderName: fullName, // زدت هاد السطر باش يتبعت الاسم
        );
        
        // 3. نبعثو لـ Firebase
        await _dbRef.push().set(newMessage.toMap());
        
      } catch (e) {
        debugPrint("Error in sendMessage: $e");
      }
    }
  }
}