import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kudiaccess/models/user_model.dart';
import 'package:kudiaccess/providers/user_provider.dart';
import 'package:kudiaccess/screens/notifications.dart';
import 'package:kudiaccess/screens/profile.dart';
import 'package:kudiaccess/screens/settings.dart';

import '../../providers/color_providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  UserModel? user;

  bool savingGoalEnabled = false;
  String savingGoal = '';

  String profileImageUrl = "";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> loadUser() async {
    final loadedUser = await ref.read(userProvider.notifier).loadUser();
    setState(() {
      user = loadedUser;
    });
    if (user != null) {
      print(user!.email);
      DocumentSnapshot pro = await _firestore
          .collection("users")
          .doc(user!.uid)
          .collection("otherData")
          .doc("profile")
          .get();
      setState(() {
        profileImageUrl = pro["profileImageUrl"] ?? "";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadUser();
  }

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

    // final colorState = ref.watch(colorProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 20),
            _buildCarouselSlider(cardList),
            const SizedBox(height: 20),
            _buildBudgetSection(),
            const SizedBox(height: 20),
            _buildSavingGoalSection(),
            const SizedBox(height: 20),
            if (savingGoalEnabled) _buildSavingGoalDisplay(),
            const SizedBox(height: 6),
            _buildRecentTransactionsHeader(context, ref),
            const SizedBox(height: 3),
            _buildTransactionList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colorState = ref.watch(colorProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome',
              style:
                  TextStyle(fontSize: 18, color: colorState.generatedColors[1]),
            ),
            if (user != null)
              Text(
                user!.username,
                style: TextStyle(
                    fontSize: 22,
                    color: colorState.generatedColors[1],
                    fontWeight: FontWeight.bold),
              )
            else
              const Text(
                'Loading...',
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
              child: CircleAvatar(
                radius: profileImageUrl.isNotEmpty ? 18 : 20,
                backgroundColor: Colors.white54,
                backgroundImage: profileImageUrl.isNotEmpty
                    ? NetworkImage(profileImageUrl)
                    : null,
                child: profileImageUrl.isNotEmpty
                    ? null
                    : const Icon(
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

  Widget _buildCarouselSlider(List<Widget> cardList) {
    return CarouselSlider.builder(
      itemCount: cardList.length,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        return AnimatedContainer(
          width: double.infinity,
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
    );
  }

  Widget _buildBudgetSection() {
    return Container(
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
    );
  }

  Widget _buildSavingGoalSection() {
    final colorState = ref.watch(colorProvider);
    return Container(
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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Set a goal to save a certain amount\nby the end of the month.',
              ),
            ],
          ),
          const Spacer(),
          Switch(
            activeColor: colorState.generatedColors[1],
            value: savingGoalEnabled,
            onChanged: (value) {
              setState(() {
                if (value) {
                  _showSavingGoalDialog();
                } else {
                  _showDisableGoalConfirmationDialog();
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSavingGoalDisplay() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Saving Goal',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Your saving goal for this month: ₵$savingGoal',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          _buildSpendingVsGoal(),
        ],
      ),
    );
  }

  Widget _buildSpendingVsGoal() {
    // Dummy data for spending vs goal. Replace with actual logic.
    double totalSpending = 2000;
    double goalAmount = double.tryParse(savingGoal) ?? 0;
    double progress = goalAmount > 0 ? totalSpending / goalAmount : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Spending vs Saving Goal',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        LinearProgressIndicator(
          value: progress > 1 ? 1 : progress,
          backgroundColor: Colors.green[200],
          valueColor: AlwaysStoppedAnimation<Color>(
              totalSpending > goalAmount ? Colors.red : Colors.green),
        ),
        const SizedBox(height: 10),
        Text(
          'Total Spending: ₵$totalSpending',
          style: TextStyle(
            color: totalSpending > goalAmount ? Colors.red : Colors.green,
          ),
        ),
        Text(
          'Saving Goal: ₵$goalAmount',
        ),
      ],
    );
  }

  Widget _buildRecentTransactionsHeader(BuildContext context, WidgetRef ref) {
    final colorState = ref.watch(colorProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Recent Transactions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {
            _showAllTransactions(context);
          },
          child: Text('See All',
              style: TextStyle(color: colorState.generatedColors[1])),
        ),
      ],
    );
  }

  Widget _buildTransactionList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        children: [
          _buildTransactionItem(
            icon: Icons.shopping_cart,
            title: 'Shopping',
            subtitle: 'Groceries and more',
            amount: '-₵120.00',
            date: '18 June 2024',
          ),
          const Divider(color: Colors.grey),
          _buildTransactionItem(
            icon: Icons.restaurant,
            title: 'Restaurant',
            subtitle: 'Dinner with friends',
            amount: '-₵80.00',
            date: '18 June 2024',
          ),
          const Divider(color: Colors.grey),
          _buildTransactionItem(
            icon: Icons.work,
            title: 'Freelance Work',
            subtitle: 'Income',
            amount: '+₵421.00',
            date: '18 June 2024',
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String amount,
    required String date,
  }) {
    final colorState = ref.watch(colorProvider);
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: colorState.generatedColors[2],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: colorState.generatedColors[0]),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            amount,
            style: TextStyle(
              color: amount.startsWith('-') ? Colors.red : Colors.green,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          Text(
            date,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _showAllTransactions(BuildContext context) {
    showModalBottomSheet(
      // barrierColor: ref.watch(colorProvider).baseColor,

      // backgroundColor: ref.watch(colorProvider).baseColor,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.85,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'All Transactions',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    _buildTransactionItem(
                      icon: Icons.shopping_cart,
                      title: 'Shopping',
                      subtitle: 'Groceries and more',
                      amount: '-₵120.00',
                      date: '18 June 2024',
                    ),
                    const Divider(color: Colors.grey),
                    _buildTransactionItem(
                      icon: Icons.restaurant,
                      title: 'Restaurant',
                      subtitle: 'Dinner with friends',
                      amount: '-₵80.00',
                      date: '18 June 2024',
                    ),
                    const Divider(color: Colors.grey),
                    _buildTransactionItem(
                      icon: Icons.work,
                      title: 'Freelance Work',
                      subtitle: 'Income',
                      amount: '+₵421.00',
                      date: '18 June 2024',
                    ),
                    const Divider(color: Colors.grey),
                    _buildTransactionItem(
                      icon: Icons.local_gas_station,
                      title: 'Fuel',
                      subtitle: 'Car refueling',
                      amount: '-₵150.00',
                      date: '17 June 2024',
                    ),
                    const Divider(color: Colors.grey),
                    _buildTransactionItem(
                      icon: Icons.movie,
                      title: 'Cinema',
                      subtitle: 'Movie night',
                      amount: '-₵50.00',
                      date: '16 June 2024',
                    ),
                    const Divider(color: Colors.grey),
                    _buildTransactionItem(
                      icon: Icons.shopping_bag,
                      title: 'Clothes',
                      subtitle: 'New outfits',
                      amount: '-₵250.00',
                      date: '15 June 2024',
                    ),
                    const Divider(color: Colors.grey),
                    _buildTransactionItem(
                      icon: Icons.laptop_mac,
                      title: 'Electronics',
                      subtitle: 'New laptop',
                      amount: '-₵2,000.00',
                      date: '14 June 2024',
                    ),
                    const Divider(color: Colors.grey),
                    _buildTransactionItem(
                      icon: Icons.local_cafe,
                      title: 'Coffee',
                      subtitle: 'Morning coffee',
                      amount: '-₵20.00',
                      date: '14 June 2024',
                    ),
                    const Divider(color: Colors.grey),
                    _buildTransactionItem(
                      icon: Icons.book,
                      title: 'Books',
                      subtitle: 'Educational books',
                      amount: '-₵75.00',
                      date: '13 June 2024',
                    ),
                    const Divider(color: Colors.grey),
                    _buildTransactionItem(
                      icon: Icons.spa,
                      title: 'Spa',
                      subtitle: 'Relaxation and wellness',
                      amount: '-₵180.00',
                      date: '12 June 2024',
                    ),
                    const Divider(color: Colors.grey),
                    _buildTransactionItem(
                      icon: Icons.airplane_ticket,
                      title: 'Flight',
                      subtitle: 'Business trip',
                      amount: '-₵1,200.00',
                      date: '11 June 2024',
                    ),
                    const Divider(color: Colors.grey),
                    _buildTransactionItem(
                      icon: Icons.build,
                      title: 'Home Improvement',
                      subtitle: 'New furniture',
                      amount: '-₵900.00',
                      date: '10 June 2024',
                    ),
                    const Divider(color: Colors.grey),
                    _buildTransactionItem(
                      icon: Icons.fastfood,
                      title: 'Fast Food',
                      subtitle: 'Lunch',
                      amount: '-₵40.00',
                      date: '09 June 2024',
                    ),
                    const Divider(color: Colors.grey),
                    _buildTransactionItem(
                      icon: Icons.sports_gymnastics_outlined,
                      title: 'Gym Membership',
                      subtitle: 'Monthly fee',
                      amount: '-₵200.00',
                      date: '08 June 2024',
                    ),
                    const Divider(color: Colors.grey),
                    _buildTransactionItem(
                      icon: Icons.camera_alt,
                      title: 'Photography',
                      subtitle: 'Camera equipment',
                      amount: '-₵1,500.00',
                      date: '07 June 2024',
                    ),
                    const Divider(color: Colors.grey),
                    _buildTransactionItem(
                      icon: Icons.hotel,
                      title: 'Hotel',
                      subtitle: 'Weekend getaway',
                      amount: '-₵600.00',
                      date: '06 June 2024',
                    ),
                    const Divider(color: Colors.grey),
                    _buildTransactionItem(
                      icon: Icons.car_rental,
                      title: 'Car Rental',
                      subtitle: 'Business trip',
                      amount: '-₵300.00',
                      date: '05 June 2024',
                    ),
                    const Divider(color: Colors.grey),
                    _buildTransactionItem(
                      icon: Icons.card_giftcard_outlined,
                      title: 'Gift',
                      subtitle: 'Birthday present',
                      amount: '-₵100.00',
                      date: '04 June 2024',
                    ),
                    const Divider(color: Colors.grey),
                    _buildTransactionItem(
                      icon: Icons.local_mall,
                      title: 'Shopping Mall',
                      subtitle: 'Clothing and accessories',
                      amount: '-₵450.00',
                      date: '03 June 2024',
                    ),
                    const Divider(color: Colors.grey),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSavingGoalDialog() {
    final TextEditingController goalController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Set Saving Goal'),
          content: TextField(
            controller: goalController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter your saving goal for this month',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  savingGoal = goalController.text;
                  savingGoalEnabled = true;
                });
                Navigator.pop(context);
              },
              child: const Text('Set Goal'),
            ),
          ],
        );
      },
    );
  }

  void _showDisableGoalConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Disable Saving Goal'),
          content:
              const Text('Are you sure you want to disable your saving goal?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  savingGoalEnabled = false;
                  savingGoal = '';
                });
                Navigator.pop(context);
              },
              child: const Text('Disable'),
            ),
          ],
        );
      },
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
