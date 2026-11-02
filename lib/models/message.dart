class ChatMessage {
  final String senderId;
  final String text;
  final DateTime timestamp;
  final String senderPhotoUrl;
  final String senderName; // الحقل الجديد للاسم

  ChatMessage({
    required this.senderId,
    required this.text,
    required this.timestamp,
    this.senderPhotoUrl = "",
    this.senderName = "User", // قيمة افتراضية إذا ما لقاش الاسم
  });

  factory ChatMessage.fromMap(Map<dynamic, dynamic> map) {
    return ChatMessage(
      senderId: map['senderId'] ?? '',
      text: map['text'] ?? '',
      senderPhotoUrl: map['senderPhotoUrl'] ?? '',
      senderName: map['senderName'] ?? 'User', // قراءة الاسم من Firebase
      // استعملت parse هنا لأنك كنتِ تستعملي milliseconds، رديتها مرنة
      timestamp: map['timestamp'] is int 
          ? DateTime.fromMillisecondsSinceEpoch(map['timestamp'])
          : DateTime.tryParse(map['timestamp'].toString()) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'senderPhotoUrl': senderPhotoUrl,
      'senderName': senderName, // إرسال الاسم مع الرسالة
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }
}