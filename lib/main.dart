import 'package:flutter/material.dart';

void main() {
  runApp(const AniYokaApp());
}

class AniYokaApp extends StatelessWidget {
  const AniYokaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AniYoka',
      debugShowCheckedModeBanner: false,
    );
  }
}