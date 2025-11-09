import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:module10liveassignment/btn_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _input = '';
  String _output = '0';
  String _expression = '';
  double num1 = 0;
  double num2 = 0;
  String operand = '';
  bool _isDarkMode = false; // Theme toggle

  @override
  void initState() {
    super.initState();
    _loadTheme(); // Load saved theme
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  Future<void> _saveTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', value);
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    _saveTheme(_isDarkMode);
  }

  void buttonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _output = '0';
        _input = '';
        _expression = '';
        operand = '';
        num1 = 0;
        num2 = 0;
      } else if (value == '=') {
        num2 = double.tryParse(_input) ?? 0;

        if (operand == '+') {
          _output = (num1 + num2).toString();
        } else if (operand == '-') {
          _output = (num1 - num2).toString();
        } else if (operand == '×') {
          _output = (num1 * num2).toString();
        } else if (operand == '÷') {
          _output = (num2 != 0) ? (num1 / num2).toString() : 'Error';
        }

        _expression = '$num1 $operand $num2 =';
        _input = _output;
        operand = '';
      } else if (['+', '-', '×', '÷'].contains(value)) {
        if (operand.isNotEmpty && _input.isNotEmpty) {
          num2 = double.tryParse(_input) ?? 0;

          if (operand == '+') {
            num1 = num1 + num2;
          } else if (operand == '-') {
            num1 = num1 - num2;
          } else if (operand == '×') {
            num1 = num1 * num2;
          } else if (operand == '÷') {
            num1 = (num2 != 0) ? num1 / num2 : 0;
          }

          _output = num1.toString();
        } else {
          num1 = double.tryParse(_input) ?? num1;
        }

        operand = value;
        _input = '';
        _expression = '$num1 $operand';
      } else {
        _input += value;
        _output = _input;

        if (operand.isNotEmpty) {
          _expression = '$num1 $operand $_input';
        } else {
          _expression = _input;
        }
      }
    });
  }

  Widget _buildButton(String text, {Color? color, Color? foregroundColor}) {
    return BtnWidget(
      text: text,
      color: color ?? (_isDarkMode ? Colors.grey[800]! : Colors.grey[300]!),
      foregroundColor: foregroundColor ?? (_isDarkMode ? Colors.white : Colors.black),
      onPressed: () => buttonPressed(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _isDarkMode ? Colors.black : Colors.white;
    final textColor = _isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('Calculator', style: TextStyle(color: textColor)),
        backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.blue,
        actions: [
          IconButton(
            icon: Icon(
              _isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
              color: textColor,
            ),
            onPressed: _toggleTheme,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(height: 130),
              Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.centerRight,
                child: Text(
                  _expression,
                  style: TextStyle(fontSize: 28, color: _isDarkMode ? Colors.grey[400] : Colors.grey[700]),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.centerRight,
                child: Text(
                  _output,
                  style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: textColor),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        _buildButton('C', color: Colors.redAccent, foregroundColor: Colors.white),
                        _buildButton('÷', color: Colors.orange, foregroundColor: Colors.white),
                        _buildButton('×', color: Colors.orange, foregroundColor: Colors.white),
                        _buildButton('-', color: Colors.orange, foregroundColor: Colors.white),
                      ],
                    ),
                    Row(
                      children: [
                        _buildButton('7'),
                        _buildButton('8'),
                        _buildButton('9'),
                        _buildButton('+', color: Colors.orange, foregroundColor: Colors.white),
                      ],
                    ),
                    Row(
                      children: [
                        _buildButton('4'),
                        _buildButton('5'),
                        _buildButton('6'),
                        _buildButton('=', color: Colors.blueAccent, foregroundColor: Colors.white),
                      ],
                    ),
                    Row(
                      children: [
                        _buildButton('1'),
                        _buildButton('2'),
                        _buildButton('3'),
                        _buildButton('0'),
                      ],
                    ),
                    Row(
                      children: [_buildButton('.')], // Decimal point row
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
