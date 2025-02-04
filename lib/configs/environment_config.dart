import 'package:module_app/utils/enums/flavors.dart';

mixin EnvironmentConfig {
  static late String env;

  static void setEnvironment(String? environment) {
    env = environment ?? 'prod';
  }

  static bool get isDev => env == Flavors.dev.value;
  static bool get isProd => env == Flavors.prod.value;
}
