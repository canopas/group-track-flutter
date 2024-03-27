import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MapView extends ConsumerStatefulWidget {
  const MapView({super.key});

  @override
  ConsumerState<MapView> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapView> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Hello, Map 123"),
    );
  }
}
