import 'dart:convert';

class BlockchainDataStore {
  final int code;
  final String message;
  final int id;
  BlockchainDataStore({
    required this.code,
    required this.message,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'message': message,
      'id': id,
    };
  }

  factory BlockchainDataStore.fromMap(Map<String, dynamic> map) {
    return BlockchainDataStore(
      code: map['code']?.toInt() ?? 0,
      message: map['message'] ?? '',
      id: map['id']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory BlockchainDataStore.fromJson(String source) => BlockchainDataStore.fromMap(json.decode(source));
}
