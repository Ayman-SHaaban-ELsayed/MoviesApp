import 'package:flutter/material.dart';
import 'package:movies_app/ui/profile/profile_tab.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const ProfileTab(),
    );
  }
}
