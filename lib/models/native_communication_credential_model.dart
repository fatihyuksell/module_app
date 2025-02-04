final class NativeCommunicationCredentialModel {
  final String token;
  final String refreshToken;
  final String userId;

  const NativeCommunicationCredentialModel({
    required this.token,
    required this.refreshToken,
    required this.userId,
  });

  factory NativeCommunicationCredentialModel.fromJson(
      Map<String, dynamic> json) {
    return NativeCommunicationCredentialModel(
      token: json['token'],
      refreshToken: json['refreshToken'],
      userId: json['userId'],
    );
  }
}
