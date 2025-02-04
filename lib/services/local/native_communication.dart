import 'package:flutter/services.dart';
import 'package:module_app/models/native_communication_credential_model.dart';
import 'package:module_app/utils/enums/method_names.dart';

class NativeCommunicationService {
  NativeCommunicationService._();

  static final NativeCommunicationService instance =
      NativeCommunicationService._();

  final MethodChannel _channel = const MethodChannel(
    'com.example.module_app/native',
  );

  Future<void> init() async {
    await _channel.invokeMethod<MethodNames>(MethodNames.init.value);
  }

  Future<NativeCommunicationCredentialModel?> getCredentials() async {
    final credentials = await _channel.invokeMethod<Map<String, dynamic>>(
      MethodNames.getCredentials.value,
    );
    return credentials != null
        ? NativeCommunicationCredentialModel.fromJson(credentials)
        : null;
  }
}
