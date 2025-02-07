import 'package:flutter/material.dart';
import 'package:module_app/services/local/native_communication_service.dart';

class ReusableAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool exitMode;

  const ReusableAppBar({
    super.key,
    this.title,
    this.exitMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool canPop = Navigator.canPop(context);

    return AppBar(
      leading: canPop || exitMode
          ? GestureDetector(
              onTap: canPop
                  ? () => Navigator.pop(context)
                  : exitMode
                      ? () => NativeCommunicationService.instance.exit()
                      : null,
              child: Icon(
                exitMode ? Icons.exit_to_app_rounded : Icons.arrow_back_ios_new,
                color: Colors.white,
              ),
            )
          : null,
      automaticallyImplyLeading: false,
      title: Text(title ?? 'Splash App Bar'),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
