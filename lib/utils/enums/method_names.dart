enum MethodNames {
  init(value: 'init'),
  getPlatformVersion(value: 'getPlatformVersion'),
  getCredentials(value: 'getCredentials');

  final String value;

  const MethodNames({required this.value});
}
