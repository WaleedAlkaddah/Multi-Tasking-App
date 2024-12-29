import 'package:flutter/material.dart';

class ElevatedBtn extends StatelessWidget {
  final String url;
  final String name;
  final VoidCallback onPressedCall;
  const ElevatedBtn({
    super.key,
    required this.url,
    required this.name,
    required this.onPressedCall,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressedCall,
      child: Text(name),
    );
  }
}
