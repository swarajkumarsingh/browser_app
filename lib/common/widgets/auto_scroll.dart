import 'dart:async';

import 'package:flutter/material.dart';

/// A widget that automatically scrolls its child widget.
class AutoScroll extends StatefulWidget {
  /// Creates an [AutoScroll] widget.
  ///
  /// The [child] is a function that receives a [ScrollController] and returns
  /// the child widget to be scrolled.
  const AutoScroll({Key? key, required this.child}) : super(key: key);

  /// Function that receives a [ScrollController] and returns the child widget
  /// to be scrolled.
  final Widget Function(ScrollController) child;

  @override
  State<AutoScroll> createState() => _AutoScrollState();
}

class _AutoScrollState extends State<AutoScroll> {
  /// Function that receives a [ScrollController] and returns the child widget
  /// to be scrolled.
  late Widget Function(ScrollController) _child;

  /// Scroll controller to control the scrolling.
  late ScrollController _scrollController;

  /// Timer used for auto-scrolling.
  late Timer _timer;

  /// The current scroll offset.
  double _scrollOffset = 0.0;

  /// The amount of scroll increment per timer tick.
  final double _scrollIncrement = 1.0;

  @override
  void initState() {
    // Initializes the scroll controller, child widget and timer.
    super.initState();
    _child = widget.child;
    _scrollController = ScrollController();
    _startAutoScroll();
  }

  @override
  void dispose() {
    // Cancels the timer and disposes the scroll controller.
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  /// Starts the auto-scrolling process.
  ///
  /// This method uses a timer to periodically increase the scroll offset of
  /// the [_scrollController]. For finite scroll child if the scroll position
  /// reaches the end, it jumps back to the beginning and continues scrolling.
  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      // Case: Finite scroll child.
      if (_scrollController.position.extentAfter == 0) {
        // If the scroll position reaches the end, jump back to the beginning.
        _scrollController.jumpTo(0);
        _scrollOffset = 0.0;
      }
      // Increase the scroll offset by the scroll increment amount.
      _scrollOffset += _scrollIncrement;
      _scrollController.jumpTo(_scrollOffset);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _child(_scrollController);
  }
}
