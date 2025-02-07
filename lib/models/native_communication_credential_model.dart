class NativeCommunicationCredentialModel {
  final String token;
  final String refreshToken;
  final String userId;
  final String flavor;

  NativeCommunicationCredentialModel({
    required this.token,
    required this.refreshToken,
    required this.userId,
    required this.flavor,
  });

  factory NativeCommunicationCredentialModel.fromJson(
      Map<String, dynamic> json) {
    try {
      return NativeCommunicationCredentialModel(
        token: json['token']?.toString() ?? '',
        refreshToken: json['refreshToken']?.toString() ?? '',
        userId: json['userId']?.toString() ?? '',
        flavor: json['flavor']?.toString() ?? 'dev',
      );
    } catch (e) {
      print('Model parsing error: $e');
      rethrow;
    }
  }
}
