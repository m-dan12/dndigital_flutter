// title_bar.dart
import 'package:dndigital/core/widgets/window_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_resizable_container/flutter_resizable_container.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
<<<<<<< HEAD
import '../utils/providers/layout_controller_provider.dart';
=======
import '../../features/master_notes/presentation/viewmodel/resizable_controller_view_model.dart';
>>>>>>> origin/main
import '../theme/button_styles.dart';

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
<<<<<<< HEAD
    final model = context.watch<LayoutControllerProvider>();
=======
    final model = context.watch<ResizableControllerViewModel>();
>>>>>>> origin/main

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
                    size: const ResizableSize.pixels(334, min: 184),
                    divider: model.leftDivider,
<<<<<<< HEAD
                    child: ClipRect(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(PhosphorIcons.sidebarSimple()),
                            constraints: const BoxConstraints(),
                            style: BtnStyle.titleBar,
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(PhosphorIcons.folderSimple()),
                            constraints: const BoxConstraints(),
                            style: BtnStyle.titleBar,
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(PhosphorIcons.magnifyingGlass()),
                            constraints: const BoxConstraints(),
                            style: BtnStyle.titleBar,
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(PhosphorIcons.bookmarks()),
                            constraints: const BoxConstraints(),
                            style: BtnStyle.titleBar,
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
=======
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(PhosphorIcons.sidebarSimple()),
                          constraints: const BoxConstraints(),
                          style: BtnStyle.titleBar,
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(PhosphorIcons.folder()),
                          constraints: const BoxConstraints(),
                          style: BtnStyle.titleBar,
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(PhosphorIcons.magnifyingGlass()),
                          constraints: const BoxConstraints(),
                          style: BtnStyle.titleBar,
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(PhosphorIcons.bookmarks()),
                          constraints: const BoxConstraints(),
                          style: BtnStyle.titleBar,
                        ),
                        const SizedBox(width: 8),
                      ],
>>>>>>> origin/main
                    ),
                  ),
                  ResizableChild(
                    divider: model.rightDivider,
                    child: const SizedBox(),
                  ),
                  ResizableChild(
                    size: const ResizableSize.pixels(334, min: 322),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(PhosphorIcons.diceSix()),
                          constraints: const BoxConstraints(),
                          style: BtnStyle.titleBar,
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(PhosphorIcons.sword()),
                          constraints: const BoxConstraints(),
                          style: BtnStyle.titleBar,
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(PhosphorIcons.magicWand()),
                          constraints: const BoxConstraints(),
                          style: BtnStyle.titleBar,
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(PhosphorIcons.sidebarSimple()),
                          constraints: const BoxConstraints(),
                          style: BtnStyle.titleBar,
                        ),
                        const SizedBox(width: 8),
                        WindowButton(
                          onPressed: () => windowManager.minimize(),
                          icon: PhosphorIcons.minus(),
                        ),
                        WindowButton(
                          onPressed: () => isMaximized
                              ? windowManager.restore()
                              : windowManager.maximize(),
                          icon: PhosphorIcons.cards(),
                        ),
                        WindowButton(
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
