class ChatMessage {
  int id;
  String? statement;
  String? name;
  String createdAt;
  String? createdAgo;
  dynamic document;
  String deviceID;
  MessageStatus status;

  ChatMessage({
    required this.id,
    required this.statement,
    this.name,
    this.document = null,
    required this.createdAt,
    required this.createdAgo,
    required this.deviceID,
    this.status = MessageStatus.sent,
  });

  void update({
    int? id,
    String? statement,
    String? name,
    dynamic document,
    String? createdAt,
    String? createdAgo,
    String? deviceId,
    MessageStatus? status,
  }) async {
    this.id = id??this.id;
    this.statement = statement??this.statement;
    this.name = name??this.name;
    this.document = document??this.document;
    this.createdAt = createdAt??this.createdAt;
    this.createdAgo = createdAgo??this.createdAgo;
    this.deviceID = deviceId??this.deviceID;
    this.status = status??this.status;
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      statement: json['statement'] ?? '',
      name: json['name'],
      document: json['document'],
      createdAt: json['created_at'],
      createdAgo: json['created_ago'],
      deviceID: json['device_id'],
    );
  }
}

enum MessageStatus { sending, sent, failed }
