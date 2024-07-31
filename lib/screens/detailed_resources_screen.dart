import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/color_providers.dart';

class DetailedResourceScreen extends ConsumerWidget {
  final String mainText;
  final String quoteText;
  final String author;
  final String date;

  const DetailedResourceScreen({
    super.key,
    required this.mainText,
    required this.quoteText,
    required this.author,
    required this.date,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorState = ref.watch(colorProvider);

    return Scaffold(
      backgroundColor: colorState.baseColor,
      appBar: AppBar(
        title: const Text('Resource Detail'),
        backgroundColor: colorState.baseColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Finances',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorState.generatedColors[1],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              mainText,
              style:
                  TextStyle(fontSize: 16, color: colorState.generatedColors[1]),
            ),
            const SizedBox(height: 16),
            Text(
              quoteText,
              style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: colorState.generatedColors[1]),
            ),
            const SizedBox(height: 16),
            Text(
              author,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorState.generatedColors[1]),
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
