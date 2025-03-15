// ignore_for_file: avoid_print

class NativeCommunicationCredentialModel {
  final String token;
  final String flavor;

  NativeCommunicationCredentialModel({
    required this.token,
    required this.flavor,
  });

  factory NativeCommunicationCredentialModel.fromJson(
      Map<String, dynamic> json) {
    try {
      return NativeCommunicationCredentialModel(
        token: json['token']?.toString() ?? '',
        flavor: json['flavor']?.toString() ?? 'dev',
      );
    } catch (e) {
      print('Model parsing error: $e');
      rethrow;
    }
  }
}
