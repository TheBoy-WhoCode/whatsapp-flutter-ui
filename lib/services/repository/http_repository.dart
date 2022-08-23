import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/enums/http_method_enum.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/models/blockchain_datastore.dart';

import 'package:whatsapp_ui/services/http_service.dart';

final httpRepositoryProvider = Provider<HttpRepository>((ref) {
  final httpService = ref.watch(httpServiceProvider);
  httpService.init();
  return HttpRepository(read: ref.read, httpService: httpService);
});

class HttpRepository {
  final Reader read;
  final HttpService httpService;

  HttpRepository({
    required this.read,
    required this.httpService,
  });

  Future<BlockchainDataStore> storeDataToBlockchain({
    required String message,
    String attachment = 'NONE',
    required String sender,
    required String receiver,
    String isSpam = "false",
  }) async {
    final response = await read(httpServiceProvider)
        .request(endPoint: 'Store', method: Method.POST, params: {
      'message': message,
      'attachment': attachment,
      'sender': sender,
      'reciver': receiver,
      'isSpam': isSpam,
    });
    final result =  BlockchainDataStore.fromMap(response.data);
    return result;
  }
}
