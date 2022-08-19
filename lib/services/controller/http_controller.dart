import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  void storeDataToBlockchain({
    required String message,
    String attachment = 'NONE',
    required String sender,
    required String receiver,
    String isSpam = "false",
  }) {
    httpRepository.storeDataToBlockchain(
      attachment: attachment,
      message: message,
      sender: sender,
      receiver: receiver,
      isSpam: isSpam,
    );
  }
}
