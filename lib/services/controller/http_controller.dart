import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/models/blockchain_datastore.dart';
import 'package:whatsapp_ui/models/forward_message_model.dart';
import 'package:whatsapp_ui/models/get_total_message_count.dart';
import 'package:whatsapp_ui/services/http_service.dart';

import 'package:whatsapp_ui/services/repository/http_repository.dart';

final httpControllerProvider = Provider<HttpController>((ref) {
  final httpRepository = ref.watch(httpRepositoryProvider);
  // final httpSerivce = ref.watch(httpServiceProvider);
  // httpSerivce.init();
  return HttpController(httpRepository: httpRepository);
});

class HttpController {
  final HttpRepository httpRepository;
  HttpController({
    required this.httpRepository,
  });

  Future<BlockchainDataStore> storeDataToBlockchain({
    required String message,
    String attachment = 'NONE',
    required String sender,
    required String receiver,
    String isSpam = "false",
  }) async {
    final response = await httpRepository.storeDataToBlockchain(
      attachment: attachment,
      message: message,
      sender: sender,
      receiver: receiver,
      isSpam: isSpam,
    );
    return response;
  }

  Future<ForwardeMessageModel> forwardMessageToBlockchain({
    required String blockId,
    required String senderId,
    required String receiverId,
  }) async {
    final response = await httpRepository.forwardMessageToBlockchain(
      blockId: blockId,
      senderId: senderId,
      receiverId: receiverId,
    );
    return response;
  }

  // Future<GetTotalMessageCount> getTotalMessageCount(String id) async{

  // }
}
