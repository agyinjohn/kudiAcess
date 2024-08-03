import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kudiaccess/providers/color_providers.dart';
import 'package:kudiaccess/screens/sign_up.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FontSelectionPage extends StatefulWidget {
  FontSelectionPage();

  @override
  State<FontSelectionPage> createState() => _FontSelectionPageState();
}

class _FontSelectionPageState extends State<FontSelectionPage> {
  String _fontFamily = 'Lato';
  final List<String> fontFamilies = [
    'Roboto',
    'Lato',
    'Times New Roman',
    'Courier New',
    'Arial'
  ];

  Future<void> _saveFontFamily(String fontFamily) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fontFamily', fontFamily);

    setState(() {
      _fontFamily = fontFamily;
    });
    final s = await SharedPreferences.getInstance();
    final fo = await s.getString('fontFamily');
    print(fo);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final colorState = ref.watch(colorProvider);
        return Scaffold(
          backgroundColor: colorState.baseColor,
          appBar: AppBar(
            elevation: 10,
            title: Text(
              'Select Font Style',
              style: TextStyle(fontFamily: _fontFamily, fontSize: 24),
            ),
            backgroundColor: colorState.baseColor,
          ),
          body: ListView.builder(
            itemCount: fontFamilies.length,
            itemBuilder: (context, index) {
              final fontFamily = fontFamilies[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                elevation: 3,
                child: ListTile(
                  title: Text(
                    fontFamily,
                    style: TextStyle(fontFamily: fontFamily, fontSize: 18),
                  ),
                  trailing: _fontFamily == fontFamily
                      ? Icon(Icons.check, color: Colors.teal)
                      : null,
                  onTap: () => _saveFontFamily(fontFamily),
                ),
              );
            },
          ),
          floatingActionButton: ElevatedButton.icon(
            label: Text(
              'Next',
              style: TextStyle(fontFamily: _fontFamily, fontSize: 18),
            ),
            icon: Icon(Icons.arrow_forward),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.teal,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignUpPage()));
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
