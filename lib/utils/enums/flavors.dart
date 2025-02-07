enum Flavors {
  dev('dev'),
  stage('stage'),
  prod('prod');

  final String value;

  const Flavors(this.value);

  static Flavors fromString(String value) {
    return Flavors.values.firstWhere((e) => e.value == value);
  }
}
