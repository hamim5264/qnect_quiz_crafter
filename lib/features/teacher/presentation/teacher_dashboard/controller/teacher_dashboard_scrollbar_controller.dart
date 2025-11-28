import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TeacherDashboardScrollbarController {
  final ScrollController scrollController = ScrollController();

  final ValueNotifier<bool> showAppBar = ValueNotifier(true);

  TeacherDashboardScrollbarController() {
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (showAppBar.value == true) {
        showAppBar.value = false;
      }
    } else if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (showAppBar.value == false) {
        showAppBar.value = true;
      }
    }
  }

  void dispose() {
    scrollController.dispose();
    showAppBar.dispose();
  }
}
