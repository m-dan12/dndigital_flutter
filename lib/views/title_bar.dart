// title_bar.dart
import 'package:dndigital/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_resizable_container/flutter_resizable_container.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import '../providers/resizable_controller_model.dart';
import '../themes/button_styles.dart';

class TitleBar extends StatefulWidget {
  const TitleBar({super.key});

  @override
  State<TitleBar> createState() => _TitleBarState();
}

class _TitleBarState extends State<TitleBar> with WindowListener {
  bool isMaximized = false;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _updateMaximizedState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  Future<void> _updateMaximizedState() async {
    final maximized = await windowManager.isMaximized();
    if (mounted) setState(() => isMaximized = maximized);
  }

  @override
  void onWindowMaximize() => setState(() => isMaximized = true);

  @override
  void onWindowUnmaximize() => setState(() => isMaximized = false);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ResizableControllerModel>();

    return DragToMoveArea(
      child: Container(
        height: 44,
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12, width: 1)),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: Colors.black12, width: 1),
                ),
              ),
              child: InkWell(
                onTap: () {},
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    // центрируем логотип
                    child: SvgPicture.asset('lib/assets/logo.svg', height: 28),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ResizableContainer(
                controller: model.controller,
                direction: Axis.horizontal,
                children: [
                  ResizableChild(
                    size: const ResizableSize.pixels(334),
                    divider: model.leftDivider,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 8),
                        DnIconButton(
                          onPressed: () {},
                          icon: Icon(PhosphorIcons.sidebarSimple()),
                          style: ButtonStyles.titleBarIcon,
                        ),
                        const SizedBox(width: 8),
                        DnIconButton(
                          onPressed: () {},
                          icon: Icon(PhosphorIcons.folder()),
                          style: ButtonStyles.titleBarIcon,
                        ),
                        const SizedBox(width: 8),
                        DnIconButton(
                          onPressed: () {},
                          icon: Icon(PhosphorIcons.magnifyingGlass()),
                          style: ButtonStyles.titleBarIcon,
                        ),
                        const SizedBox(width: 8),
                        DnIconButton(
                          onPressed: () {},
                          icon: Icon(PhosphorIcons.bookmarks()),
                          style: ButtonStyles.titleBarIcon,
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                  ResizableChild(
                    divider: model.rightDivider,
                    child: const SizedBox(),
                  ),
                  ResizableChild(
                    size: const ResizableSize.pixels(334),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(width: 8),
                        DnIconButton(
                          onPressed: () {},
                          icon: Icon(PhosphorIcons.diceSix()),
                          style: ButtonStyles.titleBarIcon,
                        ),
                        const SizedBox(width: 8),
                        DnIconButton(
                          onPressed: () {},
                          icon: Icon(PhosphorIcons.sword()),
                          style: ButtonStyles.titleBarIcon,
                        ),
                        const SizedBox(width: 8),
                        DnIconButton(
                          onPressed: () {},
                          icon: Icon(PhosphorIcons.magicWand()),
                          style: ButtonStyles.titleBarIcon,
                        ),
                        const SizedBox(width: 8),
                        DnIconButton(
                          onPressed: () {},
                          icon: Icon(PhosphorIcons.sidebarSimple()),
                          style: ButtonStyles.titleBarIcon,
                        ),
                        const SizedBox(width: 8),
                        DnWindowButton(
                          onPressed: () => windowManager.minimize(),
                          icon: PhosphorIcons.minus(),
                        ),
                        DnWindowButton(
                          onPressed: () => isMaximized
                              ? windowManager.restore()
                              : windowManager.maximize(),
                          icon: PhosphorIcons.cards(),
                        ),
                        DnWindowButton(
                          onPressed: () => windowManager.close(),
                          icon: PhosphorIcons.x(),
                          isClose: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
