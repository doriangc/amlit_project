import 'package:flutter/material.dart';

abstract class StoryChunk {
  Widget getBody();

  Map<String, StoryChunk?> getChoices();
}
