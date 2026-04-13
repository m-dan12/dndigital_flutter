// main_view.dart
import 'package:dndigital/views/note_editor.dart';
import 'package:dndigital/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_resizable_container/flutter_resizable_container.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/resizable_controller_model.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ResizableControllerModel>();

    return Row(
      children: [
        Container(
          width: 52,
          decoration: BoxDecoration(
            border: Border(right: BorderSide(color: Colors.black12, width: 1)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              DnIconButton(
                icon: Icon(PhosphorIcons.bookBookmark()),
                onPressed: () {},
              ),
              const SizedBox(height: 8),
              DnIconButton(
                icon: Icon(PhosphorIcons.usersThree()),
                onPressed: () {},
              ),
              const SizedBox(height: 8),
              DnIconButton(
                icon: Icon(PhosphorIcons.castleTurret()),
                onPressed: () {},
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(height: 8),
                    DnIconButton(
                      icon: Icon(PhosphorIcons.moon()),
                      onPressed: () {},
                    ),
                    const SizedBox(height: 8),
                    DnIconButton(
                      icon: Icon(PhosphorIcons.gearSix()),
                      onPressed: () {},
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
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
                child: Container(),
              ),
              ResizableChild(divider: model.rightDivider, child: NoteEditor()),
              ResizableChild(
                size: const ResizableSize.pixels(334),
                child: Container(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
