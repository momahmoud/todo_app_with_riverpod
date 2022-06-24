import 'package:flutter/material.dart';
import 'package:todo/constants/app_assets.dart';
import 'package:todo/ui/animations/animation_controller_state.dart';
import 'package:todo/ui/common/centered_svg_icon.dart';
import 'package:todo/ui/tasks/task_completion_ring.dart';

import '../theme/app_theme.dart';

class AnimatedTask extends StatefulWidget {
  final String iconName;
  final bool completed;
  final ValueChanged<bool>? onCompleted;
  final bool isEditing;
  final bool hasCompletedState;
  AnimatedTask({
    Key? key,
    required this.iconName,
    required this.completed,
    this.isEditing = false,
    this.hasCompletedState = true,
    this.onCompleted,
  }) : super(key: key);

  @override
  State<AnimatedTask> createState() =>
      _AnimatedTaskState(Duration(milliseconds: 740));
}

class _AnimatedTaskState extends AnimationControllerState<AnimatedTask> {
  _AnimatedTaskState(Duration duration) : super(duration);

  late final Animation<double> _animation;
  bool _showDoneIcon = false;

  @override
  void initState() {
    super.initState();

    animationController.addStatusListener(_checkStatusUpdates);
    _animation = animationController.drive(CurveTween(curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    animationController.removeStatusListener(_checkStatusUpdates);

    super.dispose();
  }

  void _checkStatusUpdates(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onCompleted?.call(true);
      if (widget.hasCompletedState) {
        if (mounted) {
          setState(() => _showDoneIcon = true);
        }
        Future.delayed(Duration(seconds: 1), () {
          if (mounted) {
            setState(() => _showDoneIcon = false);
          }
        });
      } else {
        animationController.value = 0.0;
      }
    }
  }

  void _onTapDown(TapDownDetails details) {
    if (!widget.isEditing &&
        !widget.completed &&
        animationController.status != AnimationStatus.completed) {
      animationController.forward();
    } else if (!_showDoneIcon) {
      widget.onCompleted?.call(false);
      animationController.value = 0.0;
    }
  }

  void _onTapCancel() {
    if (!widget.isEditing &&
        animationController.status != AnimationStatus.completed) {
      animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: (_) => _onTapCancel(),
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
          animation: _animation,
          builder: (BuildContext context, _) {
            final themeData = AppTheme.of(context);
            final progress = widget.completed ? 1.0 : _animation.value;
            final hasDone = progress == 1.0;
            final iconColor =
                hasDone ? themeData.accentNegative : themeData.taskIcon;
            return Stack(
              children: [
                TaskCompletionRing(progress: progress),
                Positioned.fill(
                  child: CenteredSvgIcon(
                    iconName: hasDone && _showDoneIcon
                        ? AppAssets.check
                        : widget.iconName,
                    color: iconColor,
                  ),
                ),
              ],
            );
          }),
    );
  }
}
