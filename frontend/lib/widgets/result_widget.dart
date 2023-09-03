import 'package:flutter/material.dart';

class ResultWidget extends StatelessWidget {
  final String diagnosis;

  const ResultWidget({super.key, required this.diagnosis});

  @override
  Widget build(BuildContext context) {
    return Text('Diagnosis: ${diagnosis ?? 'N/A'}');
  }
}
