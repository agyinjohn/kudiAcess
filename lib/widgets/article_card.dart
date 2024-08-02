import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kudiaccess/screens/detailed_resources_screen.dart';
import '../../providers/color_providers.dart';

class ArticleCard extends ConsumerWidget {
  final String mainText;
  final String quoteText;
  final String author;
  final String date;

  const ArticleCard({
    super.key,
    required this.mainText,
    required this.quoteText,
    required this.author,
    required this.date,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorState = ref.watch(colorProvider);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16.0)),
                child: Image.asset(
                  'assets/images/resource1.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 280.0,
                ),
              ),
              Positioned(
                top: 16.0,
                left: 16.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailedResourceScreen(
                          mainText: mainText,
                          quoteText: quoteText,
                          author: author,
                          date: date,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: colorState.baseColor,
                    ),
                    child: Text(
                      'Read More',
                      style: TextStyle(
                        color: colorState.generatedColors[1],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Finances',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  mainText,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  author,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  date,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
