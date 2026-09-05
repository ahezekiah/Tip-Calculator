import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(TipCalculatorApp());
}

class TipCalculatorApp extends StatelessWidget {
  const TipCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TipCalculatorScreen(),
    );
  }
}

class TipCalculatorScreen extends StatefulWidget {
  const TipCalculatorScreen({super.key});

  @override
  _TipCalculatorScreenState createState() => _TipCalculatorScreenState();
}

class _TipCalculatorScreenState extends State<TipCalculatorScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _billController = TextEditingController();
  double billAmount = 0.0;
  final double tipPercentage = 15.0;
  final NumberFormat currencyFormat = NumberFormat.currency(symbol: "\$");

  void _resetCalculator() {
    setState(() {
      _billController.clear();
      billAmount = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    double tipAmount = billAmount * (tipPercentage / 100);
    double grandTotal = billAmount + tipAmount;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    "💵 Tip Calculator",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _billController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Bill Total (after tax)",
                    labelStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.attach_money, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.2),
                  ),
                  onChanged: (value) {
                    setState(() {
                      billAmount = double.tryParse(value) ?? 0.0;
                    });
                  },
                ),
                const SizedBox(height: 30),
                _buildResultRow(
                    icon: Icons.percent,
                    label: "Tip %",
                    value: "${tipPercentage.toStringAsFixed(0)}%"),
                _buildAnimatedResultRow(
                    icon: Icons.money,
                    label: "Tip Amount",
                    value: currencyFormat.format(tipAmount)),
                _buildAnimatedResultRow(
                    icon: Icons.attach_money,
                    label: "Grand Total",
                    value: currencyFormat.format(grandTotal),
                    large: true),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _resetCalculator,
                  icon: Icon(Icons.refresh),
                  label: Text("Reset"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    foregroundColor: Colors.white,
                    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildResultRow(
      {required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 8),
            Text(label,
                style: TextStyle(fontSize: 20, color: Colors.white70)),
          ]),
          Text(value, style: TextStyle(fontSize: 20, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildAnimatedResultRow(
      {required IconData icon,
        required String label,
        required String value,
        bool large = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 8),
            Text(label,
                style: TextStyle(fontSize: large ? 22 : 20, color: Colors.white70)),
          ]),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: Text(
              value,
              key: ValueKey(value),
              style: TextStyle(
                fontSize: large ? 28 : 20,
                fontWeight: large ? FontWeight.bold : FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}