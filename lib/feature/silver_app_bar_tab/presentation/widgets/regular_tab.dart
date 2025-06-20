// regular_tab.dart
import 'package:flutter/material.dart';

class RegularTab extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isLoaded;

  const RegularTab({
    super.key,
    required this.title,
    required this.icon,
    required this.isLoaded,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: 50,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('$title - Item $index'),
          leading: Icon(icon),
        );
      },
    );
  }
}