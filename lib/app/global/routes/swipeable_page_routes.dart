import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

void navigateWithSwipe(BuildContext context, Widget page) {
  Navigator.of(context).push(
    SwipeablePageRoute(
      builder: (context) => page,
    ),
  );
}
