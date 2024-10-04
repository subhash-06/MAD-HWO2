import 'package:flutter/material.dart';
import 'dart:ui' show lerpDouble;
void main() => runApp(CalculatorApp());

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: CalculatorHome(),
    );
  }
}

class CalculatorHome extends StatefulWidget {
  @override
  _CalculatorHomeState createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String _displayText = '0';  // Display text for the screen
  double _firstNum = 0;
  double _secondNum = 0;
  String _operator = '';
  bool _decimalEntered = false;

  // Function to handle number input
  void _numClick(String text) {
    setState(() {
      if (_displayText == '0') {
        _displayText = text;
      } else {
        _displayText += text;
      }
    });
  }

  // Function to handle operator input
  void _operatorClick(String op) {
    setState(() {
      _firstNum = double.parse(_displayText);
      _operator = op;
      _displayText = '0';
      _decimalEntered = false; // Reset decimal flag for the second number
    });
  }

  // Function to calculate the result
  void _calculate() {
    setState(() {
      _secondNum = double.parse(_displayText);

      if (_operator == '+') {
        _displayText = (_firstNum + _secondNum).toString();
      } else if (_operator == '-') {
        _displayText = (_firstNum - _secondNum).toStringAsFixed(2); // Round result
      } else if (_operator == '*') {
        _displayText = (_firstNum * _secondNum).toString();
      } else if (_operator == '/') {
        if (_secondNum != 0) {
          _displayText = (_firstNum / _secondNum).toString();
        } else {
          _displayText = "Error"; // Handle divide by zero
        }
      }

      // Reset operator and decimal flag after calculation
      _operator = '';
      _decimalEntered = false;
    });
  }

  // Function to handle the "Clear" button
  void _clear() {
    setState(() {
      _displayText = '0';
      _firstNum = 0;
      _secondNum = 0;
      _operator = '';
      _decimalEntered = false;
    });
  }

  // Function to handle decimal input
  void _decimalClick() {
    setState(() {
      if (!_decimalEntered) {
        _displayText += '.';
        _decimalEntered = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          // Display area
          Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerRight,
            child: Text(
              _displayText,
              style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),

          // Button layout using Rows and Columns
          Expanded(
            child: Column(
              children: <Widget>[
                _buildButtonRow(['7', '8', '9', '/']),
                _buildButtonRow(['4', '5', '6', '*']),
                _buildButtonRow(['1', '2', '3', '-']),
                _buildButtonRow(['0', '.', '=', '+']),
                _buildButtonRow(['Clear'], isSingleRow: true, backgroundColor: const Color.fromARGB(255, 233, 77, 30)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to build a row of buttons
  Widget _buildButtonRow(List<String> buttons, {bool isSingleRow = false, Color backgroundColor = const Color.fromARGB(255, 255, 68, 211)}) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: buttons.map((text) {
          return isSingleRow 
            ? Expanded(
                flex: 4,  // Stretch single button across the row
                child: _buildButton(text, backgroundColor: backgroundColor),
              )
            : Expanded(
                child: _buildButton(text, backgroundColor: backgroundColor),
              );
        }).toList(),
      ),
    );
  }

  // Function to build individual buttons with cleaner UI
  Widget _buildButton(String text, {Color backgroundColor = Colors.blueAccent}) {
    return Container(
      margin: EdgeInsets.all(5),
      child: ElevatedButton(
        onPressed: () {
          if (text == 'Clear') {
            _clear();
          } else if (text == '=') {
            _calculate();
          } else if (text == '+' || text == '-' || text == '*' || text == '/') {
            _operatorClick(text);
          } else if (text == '.') {
            _decimalClick();
          } else {
            _numClick(text);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,  // Button background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(20),
          shadowColor: Colors.black,
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
