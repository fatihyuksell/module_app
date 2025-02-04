import 'package:flutter/material.dart';
import 'package:module_app/configs/environment_config.dart';

class FlavorBanner extends StatelessWidget {
  final Widget child;

  const FlavorBanner({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Banner(
        message: EnvironmentConfig.env.toUpperCase(),
        location: BannerLocation.topStart,
        child: child,
      ),
    );
  }
}
