import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget{
  final Function updateTheme;
  final Function updateFontSize;
  final Function updateFontStyle;

  const SettingsPage(
      {super.key, required this.updateTheme, required this.updateFontSize, required this.updateFontStyle,});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>{

  bool isDarkMode = false;
  double fontSize = 12.0;
  String fontStyle = 'kalniaGlaze';

  List <String> items = ['Lobster', 'Kalnia_Glaze', 'Billabong', 'Play_Write'];

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }
  disposed(){
    super.dispose();
  }
  Future<void> loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('darkMode') ?? false;
      fontSize = prefs.getDouble('fontSize') ?? 12.0;
      fontStyle = prefs.getString('fontStyle') ?? 'kalniaGlaze';
    });
  }

  Future<void> saveThemePreference(bool value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
  }

  Future<void> saveFontSizePreference(double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', value);
  }

  Future<void> saveFontStylePreference(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fontStyle', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Dark Mode', style: TextStyle(fontSize: 18)),
                Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      isDarkMode = value;
                      widget.updateTheme(isDarkMode);
                    });
                    saveThemePreference(value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('Font Size: ${fontSize.toStringAsFixed(1)}', style: const TextStyle(fontSize: 18)),
            Slider(
              value: fontSize,
              min: 12.0,
              max: 30.0,
              divisions: 18,
              label: fontSize.toString(),
              onChanged: (value) {
                setState(() {
                  fontSize = value;
                  widget.updateFontSize(fontSize);
                });
                saveFontSizePreference(value);
              },
            ),
            const SizedBox(height: 20),
            const Text('Font Style', style: TextStyle(fontSize: 18)),
            DropdownButton(
              hint: Text(fontStyle),
              items: items.map<DropdownMenuItem<String>>(( item){
              return DropdownMenuItem<String>(
                value: item,
                  child: Text(item));
            }).toList(),
              onChanged: (value){
              setState(() {
                fontStyle = value!;
                widget.updateFontStyle(fontStyle);
              });
              saveFontStylePreference(value!);
            }),
          ],
        ),
      ),
    );
  }
}
