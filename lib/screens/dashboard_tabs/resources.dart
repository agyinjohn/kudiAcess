import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/color_providers.dart';
import '../notifications.dart';
import '../profile.dart';
// import '../quote_detail.dart';
import '../settings.dart';

class ResourcesScreen extends ConsumerWidget {
  const ResourcesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorState = ref.watch(colorProvider);

    return Scaffold(
      backgroundColor: colorState.baseColor,
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BuildHeader(),
              SizedBox(height: 16),
              Center(
                child: Text(
                  'Financial Literacy',
                  style: TextStyle(color: Colors.blueGrey, fontSize: 18),
                ),
              ),
              SizedBox(height: 18),
              ArticleCard(
                mainText: 'Aenean Aliquet Est Eu Ullamcorper Rutrum...',
                quoteText: 'Lorem Ipsum Dolor Sit Amet...',
                author: 'Mr. Frimpong',
                date: 'June 27, 2024',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BuildHeader extends StatelessWidget {
  const BuildHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.chevron_left_rounded,
            color: Color.fromRGBO(243, 156, 18, 3),
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'Resources',
          style: TextStyle(
            fontSize: 18,
            color: Color.fromRGBO(243, 156, 18, 3),
          ),
        ),
        const Spacer(),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ));
              },
            ),
            const SizedBox(width: 1),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(),
                    ));
              },
              icon: const Icon(Icons.notification_add),
            ),
            const SizedBox(width: 1),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => const ProfileScreen()),
                  ),
                );
              },
              child: const CircleAvatar(
                backgroundColor: Colors.white54,
                child: Icon(
                  Icons.person_2_outlined,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ArticleCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => QuoteDetail(
                    //       mainText: mainText,
                    //       quoteText: quoteText,
                    //       author: author,
                    //       date: date,
                    //     ),
                    //   ),
                    // );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                    ),
                    child: const Text(
                      'Read More',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Finances',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Donec Sed Vestibulum Libero. Pellentesque A Mauris Convallis, Laoreet Velit Eget, Pulvinar Lacus. Pellentesque Ipsum Arcu, Tincidunt Vel Elit Vitae, Ultrices Fermentum Dui. Curabitur Pellentesque A Velit Vitae Rhoncus.',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Mr. Frimpong',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  'June 27, 2024',
                  style: TextStyle(
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
