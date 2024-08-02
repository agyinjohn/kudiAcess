import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/user_model.dart';
import '../../providers/color_providers.dart';
import '../../providers/user_provider.dart';
import '../../widgets/add_payment_modal.dart';
import '../../widgets/delete_payment.dart';
import '../../widgets/edit_payment_modal.dart';
import '../notifications.dart';
import '../profile.dart';
import '../settings.dart';

class PaymentsScreen extends ConsumerStatefulWidget {
  const PaymentsScreen({super.key});

  @override
  ConsumerState<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends ConsumerState<PaymentsScreen> {
  final TextEditingController _payBillController = TextEditingController();
  final TextEditingController _controller = TextEditingController();
  final List<String> _selectBillsValues = [
    'Select a bill',
    'Electricity Bill',
    'Internet Recharge',
    'Cable Bill',
    'Mobile Recharge',
    'OTT Bill',
  ];
  final List<String> _paymentMethodValues = [
    'Select payment',
    'Visa Card',
    'Mobile Money',
  ];
  String? _selectedValue;
  String profileImageUrl = "";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel? user;
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
    _selectedValue = _selectBillsValues.first; // Set default value
    _controller.text = _selectedValue!;
    loadUser();
  }

  @override
  Widget build(BuildContext context) {
    final colorState = ref.watch(colorProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, ref),
            const SizedBox(height: 20),
            _buildUpcomingBillCard(),
            const SizedBox(height: 20),
            Text(
              'Bill Payment',
              style:
                  TextStyle(color: colorState.generatedColors[1], fontSize: 14),
            ),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BillPaymentItem(
                    icon: Icons.lightbulb_outlined, title: 'Electricity\nBill'),
                BillPaymentItem(icon: Icons.wifi, title: 'Internet\nRecharge'),
                BillPaymentItem(
                    icon: Icons.live_tv_rounded, title: 'Cable\nBill'),
                BillPaymentItem(
                    icon: Icons.phonelink_ring_sharp,
                    title: 'Mobile\nRecharge'),
                BillPaymentItem(
                    icon: Icons.speaker_phone_rounded, title: 'OTT\nBill'),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Pay a bill',
              style:
                  TextStyle(color: colorState.generatedColors[1], fontSize: 14),
            ),
            const SizedBox(height: 10),
            CustomDropdownTextField(
              dropdownValues: _selectBillsValues,
              hintText: 'Select a bill',
            ),
            const SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              controller: _payBillController,
              decoration: InputDecoration(
                hintText: 'Enter amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomDropdownTextField(
              dropdownValues: _paymentMethodValues,
              hintText: 'Select payment method',
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        colorState.generatedColors[1], // Background color
                    foregroundColor: Colors.white, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12), // Custom border radius
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 18), // Custom padding
                  ),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Scheduled Payment',
              style:
                  TextStyle(color: colorState.generatedColors[1], fontSize: 14),
            ),
            const SizedBox(height: 10),
            _buildScheduledPayments(),
          ],
        ),
      ),
    );
  }

  Row _buildHeader(BuildContext context, WidgetRef ref) {
    final colorState = ref.watch(colorProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 10),
        Text(
          'Payments',
          style: TextStyle(fontSize: 18, color: colorState.generatedColors[1]),
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

  Container _buildUpcomingBillCard() {
    final colorState = ref.watch(colorProvider);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upcoming Bill',
                style: TextStyle(
                  fontSize: 14,
                  color: colorState.generatedColors[1],
                ),
              ),
              Text(
                'Electricity',
                style: TextStyle(
                  fontSize: 10,
                  color: colorState.generatedColors[1],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '₵820.00',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: colorState.generatedColors[1],
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: colorState.generatedColors[2],
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              icon: Icon(
                Icons.add,
                color: colorState.generatedColors[0],
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return AddPaymentModal(
                      nameController: TextEditingController(),
                      amountController: TextEditingController(),
                      dateController: TextEditingController(),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Container _buildScheduledPayments() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: const Column(
        children: [
          PaymentItemRow(
            imagePath: 'assets/images/netflix.png',
            title: 'Netflix',
            date: '21 Sept',
            amount: '¢19.00',
          ),
          SizedBox(height: 20),
          PaymentItemRow(
            imagePath: 'assets/images/shopping.png',
            title: 'Shopping',
            date: '20 Sept',
            amount: '¢65.99',
          ),
          SizedBox(height: 20),
          PaymentItemRow(
            imagePath: 'assets/images/starbucks.png',
            title: 'Starbucks',
            date: '20 Sept',
            amount: '¢19.99',
          ),
        ],
      ),
    );
  }
}

class CustomDropdownTextField extends StatefulWidget {
  final List<String> dropdownValues;
  final String hintText;

  const CustomDropdownTextField({
    super.key,
    required this.dropdownValues,
    required this.hintText,
  });

  @override
  State<CustomDropdownTextField> createState() =>
      _CustomDropdownTextFieldState();
}

class _CustomDropdownTextFieldState extends State<CustomDropdownTextField> {
  late TextEditingController _controller;
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _selectedValue = widget.dropdownValues.first;
    _controller.text = _selectedValue!;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      controller: _controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: PopupMenuButton<String>(
          icon: const Icon(Icons.arrow_drop_down),
          onSelected: (String newValue) {
            setState(() {
              _selectedValue = newValue;
              _controller.text = newValue;
            });
          },
          itemBuilder: (BuildContext context) {
            return widget.dropdownValues
                .map<PopupMenuItem<String>>((String value) {
              return PopupMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList();
          },
        ),
      ),
    );
  }
}

class BillPaymentItem extends ConsumerWidget {
  final IconData icon;
  final String title;

  const BillPaymentItem({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorState = ref.watch(colorProvider);

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: colorState.generatedColors[2],
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            icon: Icon(icon, color: colorState.generatedColors[0]),
            onPressed: () {},
          ),
        ),
        Text(
          title,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class PaymentItemRow extends ConsumerWidget {
  final String imagePath;
  final String title;
  final String date;
  final String amount;

  const PaymentItemRow({
    super.key,
    required this.imagePath,
    required this.title,
    required this.date,
    required this.amount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorState = ref.watch(colorProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: colorState.generatedColors[1],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.asset(imagePath, fit: BoxFit.cover),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(date),
          ],
        ),
        const Spacer(),
        Text(amount),
        const SizedBox(width: 6),
        IconButton(
          icon: const Icon(Icons.edit_square, color: Colors.orange),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return EditPaymentModal(
                  nameController: TextEditingController(text: title),
                  amountController: TextEditingController(text: amount),
                  dateController: TextEditingController(text: date),
                );
              },
            );
          },
        ),
        // const SizedBox(width: 6),
        IconButton(
          icon: const Icon(Icons.delete_forever_outlined, color: Colors.red),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return DeletePaymentModal();
              },
            );
          },
        ),
      ],
    );
  }
}
