class ChatMessage {
  int id;
  String? statement;
  String? name;
  String createdAt;
  String? createdAgo;
  dynamic document;
  String deviceID;
  MessageStatus status;
  Constituency? constituency;
  AddedBy? addedBy;

  ChatMessage({
    required this.id,
    required this.statement,
    this.name,
    this.document = null,
    required this.createdAt,
    required this.createdAgo,
    required this.deviceID,
    this.status = MessageStatus.sent,
    this.constituency,
    this.addedBy,
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
    Constituency? constituency,
    AddedBy? addedBy,
  }) async {
    this.id = id ?? this.id;
    this.statement = statement ?? this.statement;
    this.name = name ?? this.name;
    this.document = document ?? this.document;
    this.createdAt = createdAt ?? this.createdAt;
    this.createdAgo = createdAgo ?? this.createdAgo;
    this.deviceID = deviceId ?? this.deviceID;
    this.status = status ?? this.status;
    this.constituency = constituency ?? this.constituency;
    this.addedBy = addedBy ?? this.addedBy;
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
      constituency: json['constitunecy'] != null ? Constituency.fromJson(json['constitunecy']):null,
      addedBy: json['add_by'] != null ? AddedBy.fromJson(json['add_by']):null,
    );
  }
}

enum MessageStatus { sending, sent, failed }

class Constituency {
  final int? id;
  final String? name;
  final String? state;
  final Category? category;

  Constituency({this.id, this.name, this.category, this.state});

  factory Constituency.fromJson(Map<String, dynamic> json) {
    return Constituency(
      name: json['name'],
      id: json['id'],
      category: json['category'] != null ? Category.fromJson(json['category']):null,
      state: json['state'],
    );
  }
}

class Category {
  final int? id;
  final String? name;
  Category({this.id, this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id'], name: json['name']);
  }
}

class AddedBy {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? photo;

  AddedBy({this.id, this.name, this.phone, this.email, this.photo});
  factory AddedBy.fromJson(Map<String, dynamic> json) {
    return AddedBy(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone_number'],
      photo: json['photo'],
    );
  }
}
