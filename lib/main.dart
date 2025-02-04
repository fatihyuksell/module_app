import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:module_app/configs/environment_config.dart';
import 'package:module_app/configs/flavor_banner.dart';
import 'package:module_app/services/local/native_communication.dart';
import 'package:module_app/utils/enums/flavors.dart';
import 'package:module_app/utils/route_util.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kDebugMode) {
    await NativeCommunicationService.instance.init();
  } else {
    EnvironmentConfig.setEnvironment(Flavors.dev.value);
  }

  runApp(const _ModuleApp());
}

class _ModuleApp extends StatelessWidget {
  const _ModuleApp();

  @override
  Widget build(BuildContext context) {
    return FlavorBanner(
      child: RepaintBoundary(
        child: MaterialApp(
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.blue,
              titleTextStyle: TextStyle(fontSize: 20, color: Colors.white),
            ),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          onGenerateRoute: RouteUtil.instance.onGenerateRoute,
        ),
      ),
    );
  }
}
