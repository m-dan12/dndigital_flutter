import 'package:flutter/material.dart';
import 'package:flutter_resizable_container/flutter_resizable_container.dart';

<<<<<<<< HEAD:lib/core/utils/providers/layout_controller_provider.dart
class LayoutControllerProvider extends ChangeNotifier {
========
class ResizableControllerViewModel extends ChangeNotifier {
>>>>>>>> origin/main:lib/features/master_notes/presentation/viewmodel/resizable_controller_view_model.dart
  final ResizableController controller = ResizableController();

  bool _leftHovered = false;
  bool _rightHovered = false;

  bool get leftHovered => _leftHovered;
  bool get rightHovered => _rightHovered;

  ResizableDivider get leftDivider => ResizableDivider(
    thickness: _leftHovered ? 3 : 1,
    padding: _leftHovered ? 1 : 3,
    color: _leftHovered ? Colors.orangeAccent : Colors.black12,
    onHoverEnter: () {
      _leftHovered = true;
      notifyListeners();
    },
    onHoverExit: () {
      _leftHovered = false;
      notifyListeners();
    },
  );

  ResizableDivider get rightDivider => ResizableDivider(
    thickness: _rightHovered ? 3 : 1,
    padding: _rightHovered ? 1 : 3,
    color: _rightHovered ? Colors.orangeAccent : Colors.black12,
    onHoverEnter: () {
      _rightHovered = true;
      notifyListeners();
    },
    onHoverExit: () {
      _rightHovered = false;
      notifyListeners();
    },
  );

  void updateDividers() => notifyListeners();
}
