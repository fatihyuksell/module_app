import 'package:flutter/services.dart';
import 'package:module_app/models/native_communication_credential_model.dart';
import 'package:module_app/utils/enums/method_names.dart';

class NativeCommunicationService {
  NativeCommunicationService._();

  static final NativeCommunicationService instance =
      NativeCommunicationService._();

  final MethodChannel _channel = const MethodChannel(
    'com.example.moduleApp/native',
  );

  Future<NativeCommunicationCredentialModel?> getCredentials() async {
    try {
      final result = await _channel.invokeMethod(
        MethodNames.getCredentials.value,
      );

      if (result == null) return null;

      // Native'den gelen Map'i doğru formata dönüştür
      final Map<String, dynamic> credentials = (result as Map<Object?, Object?>)
          .map((key, value) => MapEntry(key.toString(), value));

      print('Received credentials: $credentials'); // Debug için

      return NativeCommunicationCredentialModel.fromJson(credentials);
    } on PlatformException catch (e) {
      print('Platform Exception: ${e.message}');
      return null;
    } catch (e, stackTrace) {
      print('Native iletişim hatası: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }

  Future<void> exit() async {
    try {
      await _channel.invokeMethod('exit');
    } on PlatformException catch (e) {
      print('Failed to exit: ${e.message}');
    }
  }
}
