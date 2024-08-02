import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fl_chart/fl_chart.dart';
import '../../providers/color_providers.dart';
import '../../widgets/chart.dart';
import '../notifications.dart';
import '../profile.dart';
import '../settings.dart';

class BudgetScreen extends ConsumerWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorState = ref.watch(colorProvider);

    return Scaffold(
      backgroundColor: colorState.baseColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BuildHeader(),
              const CustomLineChart(),
              const SizedBox(height: 16),
              const BudgetCard(),
              const SizedBox(height: 16),
              Text('Your Budget',
                  style: TextStyle(color: colorState.generatedColors[1])),
              const SizedBox(height: 8),
              const BudgetList(),
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 10),
        Text(
          'Budget & Goals',
          style: TextStyle(
            fontSize: 18,
            color: colorState.generatedColors[1],
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

class BudgetCard extends ConsumerWidget {
  const BudgetCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorState = ref.watch(colorProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorState.generatedColors[0],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Budget for October',
                style: TextStyle(
                    fontSize: 16, color: colorState.generatedColors[1]),
              ),
              const SizedBox(height: 8),
              const Text(
                '₵2,478',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Divider(thickness: 3, color: colorState.generatedColors[1]),
          const SizedBox(height: 12)
        ],
      ),
    );
  }
}

class BudgetList extends StatelessWidget {
  const BudgetList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        BudgetListItem(),
        BudgetListItem(),
        BudgetListItem(),
      ],
    );
  }
}

class BudgetListItem extends ConsumerWidget {
  const BudgetListItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorState = ref.watch(colorProvider);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          color: colorState.generatedColors[0],
          borderRadius: BorderRadius.circular(12),
          shape: BoxShape.rectangle),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: colorState.generatedColors[2]),
            width: 48,
            height: 48,
            child:
                Icon(Icons.shopping_cart, color: colorState.generatedColors[0]),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Shopping',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colorState.generatedColors[1])),
              Text('10 Jan 2022',
                  style: TextStyle(color: colorState.generatedColors[1])),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('₵54,417.80',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Text('In Cash',
                  style: TextStyle(color: colorState.generatedColors[1])),
            ],
          ),
        ],
      ),
    );
  }
}
