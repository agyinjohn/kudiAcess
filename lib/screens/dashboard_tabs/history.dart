import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/color_providers.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _showEarnings = false;

  final List<Map<String, dynamic>> _expenses = [
    {
      'title': 'Dropbox Plan',
      'subtitle': 'Subscription',
      'amount': '-₵144.00',
      'date': '18 Sept 2019',
      'icon': Icons.cloud,
    },
    {
      'title': 'Spotify Subscr.',
      'subtitle': 'Subscription',
      'amount': '-₵24.00',
      'date': '12 Sept 2019',
      'icon': Icons.music_note,
    },
    {
      'title': 'ATM Withdrawal',
      'subtitle': 'Cash Withdrawal',
      'amount': '-₵32.00',
      'date': '10 Sept 2019',
      'icon': Icons.atm,
    },
    {
      'title': 'KFC Restaurant',
      'subtitle': 'Food & Drink',
      'amount': '-₵14.00',
      'date': '09 Sept 2019',
      'icon': Icons.fastfood,
    },
    {
      'title': 'Tax on Interest',
      'subtitle': 'Tax & Bill',
      'amount': '-₵1.00',
      'date': '04 Sept 2019',
      'icon': Icons.attach_money,
    },
  ];

  final List<Map<String, dynamic>> _earnings = [
    {
      'title': 'Freelance Project',
      'subtitle': 'Income',
      'amount': '+₵500.00',
      'date': '15 Sept 2019',
      'icon': Icons.work,
    },
    {
      'title': 'Salary',
      'subtitle': 'Income',
      'amount': '+₵3000.00',
      'date': '01 Sept 2019',
      'icon': Icons.attach_money,
    },
    {
      'title': 'Stock Dividends',
      'subtitle': 'Investment',
      'amount': '+₵200.00',
      'date': '30 Aug 2019',
      'icon': Icons.trending_up,
    },
    {
      'title': 'Selling Old Items',
      'subtitle': 'Income',
      'amount': '+₵150.00',
      'date': '20 Aug 2019',
      'icon': Icons.sell,
    },
    {
      'title': 'Cashback',
      'subtitle': 'Rewards',
      'amount': '+₵10.00',
      'date': '18 Aug 2019',
      'icon': Icons.card_giftcard,
    },
  ];

  List<Map<String, dynamic>> _getFilteredTransactions() {
    final transactions = _showEarnings ? _earnings : _expenses;
    if (_searchQuery.isEmpty) {
      return transactions;
    }
    return transactions.where((transaction) {
      final title = transaction['title'].toLowerCase();
      final subtitle = transaction['subtitle'].toLowerCase();
      return title.contains(_searchQuery) || subtitle.contains(_searchQuery);
    }).toList();
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  void _toggleTransactionType() {
    setState(() {
      _showEarnings = !_showEarnings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 10),
            _buildBalanceCard(),
            const SizedBox(height: 20),
            _buildSearchBar(),
            const SizedBox(height: 10),
            _buildExpensesHeader(),
            const SizedBox(height: 8),
            _buildExpensesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final colorState = ref.watch(colorProvider);
    return Text(
      'In & Out',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: colorState.generatedColors[1],
      ),
    );
  }

  Widget _buildBalanceCard() {
    final colorState = ref.watch(colorProvider);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Active Total Balance',
            style: TextStyle(
              fontSize: 14,
              color: colorState.generatedColors[1],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₵8,420.00',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: colorState.generatedColors[1],
                ),
              ),
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
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 3),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: colorState.generatedColors[2],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  icon: Icon(
                    Icons.arrow_upward_rounded,
                    color: colorState.generatedColors[0],
                  ),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Up by 4% from last month',
                style: TextStyle(
                  color: colorState.generatedColors[1],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: const InputDecoration(
        labelText: 'Search Transactions',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: _updateSearchQuery,
    );
  }

  Widget _buildExpensesHeader() {
    final colorState = ref.watch(colorProvider);
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            if (_showEarnings) _toggleTransactionType();
          },
          child: Text(
            'Expenses',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color:
                  _showEarnings ? Colors.black : colorState.generatedColors[2],
            ),
          ),
        ),
        const SizedBox(width: 18),
        GestureDetector(
          onTap: () {
            if (!_showEarnings) _toggleTransactionType();
          },
          child: Text(
            'Earnings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color:
                  _showEarnings ? colorState.generatedColors[2] : Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Row(
            children: [
              const Text(
                'Sort by',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.arrow_drop_down_rounded),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExpensesList() {
    final filteredTransactions = _getFilteredTransactions();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        children: filteredTransactions.map((transaction) {
          return Column(
            children: [
              _buildTransactionItem(
                icon: transaction['icon'],
                title: transaction['title']!,
                subtitle: transaction['subtitle']!,
                amount: transaction['amount']!,
                date: transaction['date']!,
              ),
              const Divider(color: Colors.grey),
            ],
          );
        }).toList(),
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
    final isExpense = !_showEarnings;
    return ListTile(
      leading: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: IconButton(
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          icon: Icon(icon, color: Colors.blue),
          onPressed: () {},
        ),
      ),
      title: Text(title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            amount,
            style: TextStyle(
              fontSize: 14,
              color: isExpense ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold,
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
}
