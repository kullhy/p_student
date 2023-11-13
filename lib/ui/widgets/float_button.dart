import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';

class FloatingActionCustom extends StatelessWidget {
  const FloatingActionCustom({
    super.key,
    required AnimationController animationController,
    required Animation<double> animation,
    required this.function,

  })  : _animationController = animationController,
        _animation = animation;

  final AnimationController _animationController;
  final Animation<double> _animation;
  final Function(String filter) function;


  @override
  Widget build(BuildContext context) {
    return FloatingActionBubble(
      // Menu items
      items: <Bubble>[
        // Floating action menu item
        Bubble(
            title: "TẤT CẢ",
            iconColor: Colors.white,
            bubbleColor: const Color.fromRGBO(33, 150, 243, 1),
            icon: Icons.people_outline,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              function("all");
            }),
        // Floating action menu item
        Bubble(
            title: "ĐI MUỘN",
            iconColor: Colors.white,
            bubbleColor: Colors.blue,
            icon: Icons.timer_off_outlined,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              function("late");
            }),
        //Floating action menu item
        Bubble(
            title: "ĐÚNG GIỜ",
            iconColor: Colors.white,
            bubbleColor: Colors.blue,
            icon: Icons.timer_outlined,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              function("onTime");
            }),
      ],

      // animation controller
      animation: _animation,

      // On pressed change animation state
      onPress: () => _animationController.isCompleted
          ? _animationController.reverse()
          : _animationController.forward(),

      // Floating Action button Icon color
      iconColor: Colors.blue,

      // Flaoting Action button Icon
      iconData: Icons.filter_alt_outlined,
      backGroundColor: Colors.white,
    );
  }
}
