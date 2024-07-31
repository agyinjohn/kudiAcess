import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kudiaccess/screens/notifications.dart';
import 'package:kudiaccess/screens/profile.dart';
import 'package:kudiaccess/screens/settings.dart';
import 'package:kudiaccess/widgets/article_card.dart';
import '../../providers/color_providers.dart';

class ResourcesScreen extends ConsumerWidget {
  const ResourcesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorState = ref.watch(colorProvider);

    // List of articles with longer quotes
    final List<Map<String, String>> articles = [
      {
        'mainText': 'Aenean Aliquet Est Eu Ullamcorper Rutrum...',
        'quoteText':
            '“The greatest glory in living lies not in never falling, but in rising every time we fall.” – Nelson Mandela',
        'author': 'Mr. Frimpong',
        'date': 'June 27, 2024',
      },
      {
        'mainText': 'Understanding the Basics of Personal Finance',
        'quoteText':
            '“Your economic security does not lie in your job; it lies in your own power to produce – to think, to learn, to create, to adapt.” – Stephen Covey',
        'author': 'Jane Doe',
        'date': 'July 10, 2024',
      },
      {
        'mainText': 'Investing for Beginners',
        'quoteText':
            '“The stock market is filled with individuals who know the price of everything, but the value of nothing.” – Phillip Fisher',
        'author': 'John Smith',
        'date': 'July 12, 2024',
      },
      {
        'mainText': 'Managing Debt Effectively',
        'quoteText':
            '“You must gain control over your money or the lack of it will forever control you.” – Dave Ramsey',
        'author': 'Alice Johnson',
        'date': 'July 14, 2024',
      },
      {
        'mainText': 'Retirement Planning Tips',
        'quoteText':
            '“Retirement is not the end of the road. It is the beginning of the open highway.” – Unknown',
        'author': 'Bob Brown',
        'date': 'July 16, 2024',
      },
      {
        'mainText': 'The Importance of an Emergency Fund',
        'quoteText':
            '“Saving must become a priority, not just a thought. Pay yourself first.” – Dave Ramsey',
        'author': 'Clara White',
        'date': 'July 18, 2024',
      },
      {
        'mainText': 'Credit Scores and Their Impact',
        'quoteText':
            '“A good credit score is like a report card for how you manage your finances.” – Suze Orman',
        'author': 'David Green',
        'date': 'July 20, 2024',
      },
      {
        'mainText': 'Financial Independence, Retire Early (FIRE)',
        'quoteText':
            '“Financial independence is about having more choices.” – Robert Kiyosaki',
        'author': 'Eva Black',
        'date': 'July 22, 2024',
      },
      {
        'mainText': 'Tax Planning Strategies',
        'quoteText':
            '“In this world, nothing can be said to be certain, except death and taxes.” – Benjamin Franklin',
        'author': 'Frank Blue',
        'date': 'July 24, 2024',
      },
      {
        'mainText': 'Understanding Insurance Policies',
        'quoteText':
            '“Insurance is the only product that both the seller and buyer hope is never actually used.” – Unknown',
        'author': 'Grace Red',
        'date': 'July 26, 2024',
      },
    ];

    return Scaffold(
      backgroundColor: colorState.baseColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BuildHeader(),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Financial Literacy',
                  style: TextStyle(
                      color: colorState.generatedColors[1], fontSize: 18),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: PageView.builder(
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return ArticleCard(
                      mainText: article['mainText']!,
                      quoteText: article['quoteText']!,
                      author: article['author']!,
                      date: article['date']!,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BuildHeader extends ConsumerWidget {
  const BuildHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorState = ref.watch(colorProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(width: 40.0),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NotificationsScreen()),
            );
          },
          icon: const Icon(Icons.notifications_none, size: 20.0),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          },
          icon: const Icon(Icons.account_circle_outlined, size: 20.0),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          },
          icon: const Icon(Icons.settings_outlined, size: 20.0),
        ),
      ],
    );
  }
}
