import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/enums/http_method_enum.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/models/blockchain_datastore.dart';
import 'package:whatsapp_ui/models/forward_message_model.dart';
import 'package:whatsapp_ui/models/get_total_message_count.dart';

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
    final result = BlockchainDataStore.fromMap(response.data);
    return result;
  }

  Future<GetTotalMessageCount> getTotalMessageCount(String id) async {
    final response = await read(httpServiceProvider)
        .request(endPoint: 'senders', method: Method.GET, params: {'id': id});
    final result = GetTotalMessageCount.fromJson(response);
    logger.d(result);
    return result;
  }

  Future<ForwardeMessageModel> forwardMessageToBlockchain({
    required String blockId,
    required String senderId,
    required String receiverId,
  }) async {
    final response = await read(httpServiceProvider)
        .request(endPoint: "forword", method: Method.POST, params: {
      'id': blockId,
      'sender': senderId,
      'reciver': receiverId,
    });
    final result = ForwardeMessageModel.fromJson(response.data);
    // logger.d(result);
    return result;
  }
}
