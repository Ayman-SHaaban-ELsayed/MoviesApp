import 'package:flutter/material.dart';
import 'package:movies_app/ui/home/tab_list/home_tab/profile_tab/profile_tab.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const ProfileTab(),
    );
  }
}
