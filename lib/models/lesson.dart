import 'package:flutter/material.dart';

class Lesson {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final double progress;
  final int xpReward;
  final String difficulty;
  final bool isLocked;

  const Lesson({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.progress = 0.0,
    this.xpReward = 50,
    this.difficulty = 'Beginner',
    this.isLocked = false,
  });
}

class LessonContent {
  final String lessonId;
  final String title;
  final String description;
  final List<LessonStep> steps;

  const LessonContent({
    required this.lessonId,
    required this.title,
    required this.description,
    required this.steps,
  });
}

class LessonStep {
  final String instruction;
  final String type;
  final String content;

  const LessonStep({
    required this.instruction,
    required this.type,
    required this.content,
  });
}
