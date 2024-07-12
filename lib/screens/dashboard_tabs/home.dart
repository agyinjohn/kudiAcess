import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';
import 'package:kudiaccess/screens/notifications.dart';
import 'package:kudiaccess/screens/profile.dart';
import 'package:kudiaccess/screens/settings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> cardList = [
      const BalanceCard(
        color: Colors.blue,
        balance: '₵6,420.00',
        type: 'Debit',
      ),
      const BalanceCard(
        color: Colors.red,
        balance: '₵4,420.00',
        type: 'Credit',
      ),
      const BalanceCard(
        color: Colors.green,
        balance: '₵8,200.00',
        type: 'Savings',
      ),
    ];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome',
                      style: TextStyle(fontSize: 18, color: Colors.blue),
                    ),
                    Text(
                      'Elizabeth Nunito',
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
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
            ),
            const SizedBox(height: 20),
            CarouselSlider.builder(
              itemCount: cardList.length,
              itemBuilder: (BuildContext context, int index, int realIndex) {
                return AnimatedContainer(
                  width: 2000,
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: index == realIndex ? Colors.white : Colors.grey[300],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: cardList[index],
                );
              },
              options: CarouselOptions(
                height: 180,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                viewportFraction: 0.75,
              ),
            ),
            const SizedBox(height: 20),
            // Budget Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Budget for October',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('Cash Available'),
                    ],
                  ),
                  Text(
                    '₵2,478',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Create Saving Goal Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create a Saving goal',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Lorem ipsum dolor sit amet,\nconsectetur adipiscing.',
                      ),
                    ],
                  ),
                  const Spacer(),
                  Switch(
                    value: true,
                    onChanged: (value) {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Recent Transactions Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Transactions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('See all'),
                ),
              ],
            ),
            // Transaction List

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        icon: const Icon(
                          Icons.cloud,
                          color: Colors.blue,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    title: const Text('Dropbox Plan'),
                    subtitle: const Text('Subscription'),
                    trailing: const Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '-₵144.00',
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.w600),
                        ),
                        Text('18 June 2024'),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.grey),
                  ListTile(
                    leading: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        icon: const Icon(
                          Icons.work,
                          color: Colors.blue,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    title: const Text('Freelance Work'),
                    subtitle: const Text('Income'),
                    trailing: const Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '+₵421.00',
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.w600),
                        ),
                        Text('18 June 2024'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BalanceCard extends StatelessWidget {
  final Color color;
  final String balance;
  final String type;

  const BalanceCard({
    super.key,
    required this.color,
    required this.balance,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        image: const DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('assets/images/card_vector.png'),
        ),
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 14.0, 8.0, 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Balance',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                Spacer(),
                Icon(
                  Icons.more_horiz,
                  color: Colors.white,
                ),
              ],
            ),
            // const SizedBox(height: 10),
            Text(
              type,
              style: const TextStyle(color: Colors.white),
            ),
            const Spacer(),
            Text(
              balance,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
