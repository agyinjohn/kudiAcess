import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kudiaccess/providers/color_providers.dart';
import 'package:kudiaccess/screens/dashboard_tabs/budget.dart';

import 'package:kudiaccess/screens/dashboard_tabs/history.dart';
import 'package:kudiaccess/screens/dashboard_tabs/payment.dart';
import 'package:kudiaccess/screens/dashboard_tabs/resources.dart';
import 'package:kudiaccess/screens/profile.dart';
import 'package:kudiaccess/screens/settings.dart';
import 'package:kudiaccess/utils/commons/flutter_tts.dart';
import 'package:kudiaccess/utils/commons/speech_to_txt.dart';
import 'dart:math' as math;
import 'dashboard_tabs/home.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage>
    with SingleTickerProviderStateMixin {
  final SpeechService _speechService = SpeechService();
  final TextToSpeechService _ttsService = TextToSpeechService();
  late AnimationController _animationController;
  bool isListening = false;
  @override
  void initState() {
    super.initState();
    _initializeSpeech();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  Future<void> _initializeSpeech() async {
    bool available = await _speechService.initialize();
    if (available) {
      setState(() {});
    }
  }

  void _startListening() {
    setState(() {
      isListening = true;
      _animationController.forward();
    });
    _speechService.startListening((result) {
      print(result);
      if (result.contains('go to profile page')) {
        _ttsService.speak('Navigating to Profile page');
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()));
      } else if (result.contains('go to settings')) {
        _ttsService.speak('Navigating to settings page');
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()));
      } else if (result.contains('go to homepage')) {
        if (currentIndex == 0) {
          _ttsService.speak("You are already on the home page");
          print(currentIndex);
        } else {
          _ttsService.speak("Navigating to home page");
          setState(() {
            currentIndex = 0;
          });
        }
      } else if (result.contains('go to history page')) {
        if (currentIndex == 1) {
          _ttsService.speak("You are already on the history page");
        } else {
          _ttsService.speak("Navigating to history page");
          setState(() {
            currentIndex = 1;
          });
        }
      } else if (result.contains('go to payment page')) {
        if (currentIndex == 2) {
          _ttsService.speak("You are already on the payments to page");
        } else {
          _ttsService.speak("Navigating to payments page");
          setState(() {
            currentIndex = 2;
          });
        }
      } else if (result.contains('go to budget page')) {
        if (currentIndex == 3) {
          _ttsService.speak("You are already on the budget and goals to page");
        } else {
          _ttsService.speak("Navigating to budget and goals page");
          setState(() {
            currentIndex = 3;
          });
        }
      } else if (result.contains('go to resources page')) {
        if (currentIndex == 4) {
          _ttsService.speak("You are already on the resources to page");
        } else {
          _ttsService.speak("Navigating to resources and goals page");
          setState(() {
            currentIndex = 4;
          });
        }
      }
    });
  }

  void _stopListening() {
    setState(() {
      isListening = false;
      _animationController.stop();
      _animationController.reset();
    });
    _speechService.stopListening();
  }

  int currentIndex = 0;
  final List<Widget> _screens = [
    const HomeScreen(),
    const HistoryScreen(),
    const PaymentsScreen(),
    const BudgetScreen(),
    const ResourcesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final colorState = ref.watch(colorProvider);
    return Scaffold(
      backgroundColor: colorState.baseColor,
      body: SafeArea(
        child: _screens[currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: colorState.generatedColors[0],
        selectedItemColor: colorState.generatedColors[1],
        unselectedItemColor: colorState.generatedColors[2],
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
          print(currentIndex);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Payment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mobile_friendly),
            label: 'Budget',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Resources',
          ),
        ],
      ),
      floatingActionButton: currentIndex != 5
          ? AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) => FloatingActionButton(
                backgroundColor: colorState.generatedColors[0],
                onPressed: _speechService.isListening
                    ? _stopListening
                    : _startListening,
                child: Transform.rotate(
                    angle: _animationController.value * 2 * math.pi,
                    child: Icon(
                      _speechService.isListening ? Icons.mic : Icons.mic_off,
                      color: colorState.generatedColors[1],
                    )),
              ),
            )
          : null,
    );
  }
}
