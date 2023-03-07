import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Chunk extends StatefulWidget {
  const Chunk({super.key});

  @override
  State<Chunk> createState() => _ChunkState();
}

class _ChunkState extends State<Chunk> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
