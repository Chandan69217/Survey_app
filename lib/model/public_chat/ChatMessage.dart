class ChatMessage {
  final int id;
  final String statement;
  final String? name;
  final String createdAt;
  final String createdAgo;
  final String deviceID;

  ChatMessage({
    required this.id,
    required this.statement,
    this.name,
    required this.createdAt,
    required this.createdAgo,
    required this.deviceID,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      statement: json['statement'] ?? '',
      name: json['name'],
      createdAt: json['created_at'],
      createdAgo: json['created_ago'],
      deviceID: json['device_id'],
    );
  }
}