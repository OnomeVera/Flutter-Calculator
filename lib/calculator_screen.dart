import 'package:flutter/material.dart';
import 'button_values.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = "";
  String operand = "";
  String number2 = "";

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Output Display
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(16),
                child: Text(
                  "$number1$operand$number2".isEmpty ? "0" : "$number1$operand$number2",
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ),
            // Buttons Layout
            Wrap(
              alignment: WrapAlignment.center,
              children: Btn.buttonValues
                  .map(
                    (value) => SizedBox(
                      width: value == Btn.n0
                          ? screenSize.width / 2
                          : screenSize.width / 4,
                      height: screenSize.width / 5,
                      child: buildButton(value),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(String value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: CircleBorder(),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }

    if (value == Btn.clr) {
      clearAll();
      return;
    }

    if (value == Btn.per) {
      convertToPercentage();
      return;
    }

    if (value == Btn.calculate) {
      calculate();
      return;
    }

    appendValue(value);
  }

  void calculate() {
    if (number1.isEmpty || operand.isEmpty || number2.isEmpty) return;

    final double num1 = double.parse(number1);
    final double num2 = double.parse(number2);

    var result = 0.0;
    switch (operand) {
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.subtract:
        result = num1 - num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      case Btn.divide:
        result = num2 != 0 ? num1 / num2 : 0; // Handle division by zero
        break;
      default:
    }

    setState(() {
      number1 = result.toStringAsPrecision(3);
      if (number1.endsWith(".0")) {
        number1 = number1.substring(0, number1.length - 2);
      }
      operand = "";
      number2 = "";
    });
  }

  void convertToPercentage() {
    if (number1.isNotEmpty && operand.isEmpty) {
      final number = double.parse(number1);
      setState(() {
        number1 = (number / 100).toString();
      });
    }
  }

  void clearAll() {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
    });
  }

  void delete() {
    setState(() {
      if (number2.isNotEmpty) {
        number2 = number2.substring(0, number2.length - 1);
      } else if (operand.isNotEmpty) {
        operand = "";
      } else if (number1.isNotEmpty) {
        number1 = number1.substring(0, number1.length - 1);
      }
    });
  }

  void appendValue(String value) {
    setState(() {
      if (int.tryParse(value) != null || value == Btn.dot) {
        if (operand.isEmpty) {
          if (value == Btn.dot && number1.contains(Btn.dot)) return;
          number1 += value;
        } else {
          if (value == Btn.dot && number2.contains(Btn.dot)) return;
          number2 += value;
        }
      } else {
        if (operand.isEmpty && number1.isNotEmpty) {
          operand = value;
        }
      }
    });
  }

  Color getBtnColor(String value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.blueGrey
        : [Btn.per, Btn.add, Btn.subtract, Btn.multiply, Btn.divide, Btn.calculate].contains(value)
            ? Colors.orange
            : Colors.black87;
  }
}
