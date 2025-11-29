import 'dart:async';
import 'package:flutter/material.dart';

enum FeedbackType { good, bad }

void showFeedbackDialog(BuildContext context, FeedbackType type) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: "Feedback",
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (context, _, __) {
      Future.delayed(const Duration(seconds: 3), () {
        if (Navigator.of(context, rootNavigator: true).canPop()) {
          Navigator.of(context, rootNavigator: true).pop();
        }
      });

      Icon icon;
      String text;

      if (type == FeedbackType.good) {
        icon = const Icon(
          Icons.sentiment_satisfied_alt,
          size: 64,
          color: Colors.green,
        );
        text = "We're glad you enjoyed!";
      } else {
        icon = const Icon(
          Icons.sentiment_dissatisfied,
          size: 64,
          color: Colors.red,
        );
        text = "We're sorry for the experience!";
      }

      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.symmetric(horizontal: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                const SizedBox(height: 12),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return Transform.scale(
        scale: animation.value,
        child: Opacity(opacity: animation.value, child: child),
      );
    },
  );
}
