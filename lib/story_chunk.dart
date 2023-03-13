import 'package:flutter/material.dart';

abstract class StoryChunk {
  double getRotation();
  double getTranslationY();
  double getTranslationX();
  String getName();

  Widget getBody();
  Map<String, StoryChunk?> getChoices();
}

class DefaultStoryChunk implements StoryChunk {
  final double rotation;
  final double translationX;
  final double translationY;

  final String name;
  final Widget body;
  final Map<String, StoryChunk?> choices;

  DefaultStoryChunk({
    required this.name,
    required this.rotation,
    required this.translationX,
    required this.translationY,
    required this.body,
    required this.choices,
  });

  @override
  Widget getBody() {
    return body;
  }

  @override
  Map<String, StoryChunk?> getChoices() {
    return choices;
  }

  @override
  double getRotation() {
    return rotation;
  }

  @override
  double getTranslationX() {
    return translationX;
  }

  @override
  double getTranslationY() {
    return translationY;
  }

  @override
  String getName() {
    return name;
  }
}
