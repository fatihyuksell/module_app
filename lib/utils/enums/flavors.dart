enum Flavors {
  dev('dev'),
  stage('stage'),
  prod('prod');

  final String value;

  const Flavors(this.value);
}
