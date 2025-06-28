class ChatMessage {
  final String sender;
  final String receiver;
  final String text;
  final DateTime timestamp;

  ChatMessage({
    required this.sender,
    required this.receiver,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'sender': sender,
    'receiver': receiver,
    'text': text,
    'timestamp': timestamp.toIso8601String(),
  };

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      sender: json['sender'],
      receiver: json['receiver'],
      text: json['text'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
