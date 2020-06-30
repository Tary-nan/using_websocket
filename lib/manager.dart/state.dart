import 'dart:async';

import 'package:sprinkle/Manager.dart';

class StateBloc implements Manager {

  StreamController animationController = StreamController();
  final StateProvider provider = StateProvider();

  Stream get animationStatus => animationController.stream;

  void toggleAnimation() {
    provider.toggleAnimationValue();
    animationController.sink.add(provider.isAnimating);
  }

  @override
  void dispose() {
    animationController?.close();
  }
}

class StateProvider {
  bool isAnimating = true;
  void toggleAnimationValue() => isAnimating = !isAnimating;
}