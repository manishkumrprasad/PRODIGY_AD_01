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
      appBar: AppBar(
        title: Text(
          "Calculator",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black12,
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            /// DISPLAY
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    number1 + operand + number2,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),

            /// BUTTONS
            Wrap(
              children: Btn.buttonValues.map((value) {
                return SizedBox(
                  width: value == Btn.n0
                      ? screenSize.width / 2
                      : screenSize.width / 4,
                  height: screenSize.width / 5,
                  child: buildButton(value),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(String value) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Material(
        color: getBtnColor(value),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onBtnTap(String value) {
    /// CLEAR
    if (value == Btn.clr) {
      setState(() {
        number1 = "";
        operand = "";
        number2 = "";
      });
      return;
    }

    /// DELETE
    if (value == Btn.del) {
      setState(() {
        if (number2.isNotEmpty) {
          number2 = number2.substring(0, number2.length - 1);
        } else if (operand.isNotEmpty) {
          operand = "";
        } else if (number1.isNotEmpty) {
          number1 = number1.substring(0, number1.length - 1);
        }
      });
      return;
    }

    /// EQUALS
    if (value == Btn.equals) {
      calculate();
      return;
    }

    /// OPERATOR
    if (isOperator(value)) {
      if (number1.isNotEmpty) {
        setState(() => operand = value);
      }
      return;
    }

    /// NUMBER INPUT
    setState(() {
      if (operand.isEmpty) {
        if (value == Btn.dot && number1.contains(Btn.dot)) return;
        number1 += value;
      } else {
        if (value == Btn.dot && number2.contains(Btn.dot)) return;
        number2 += value;
      }
    });
  }

  void calculate() {
    if (number1.isEmpty || operand.isEmpty || number2.isEmpty) return;

    final num1 = double.parse(number1);
    final num2 = double.parse(number2);
    double result = 0;

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
        result = num2 == 0 ? 0 : num1 / num2;
        break;
      case Btn.percent:
        result = (num1 / 100) * num2;
        break;
    }

    setState(() {
      number1 = result.toString().endsWith(".0")
          ? result.toInt().toString()
          : result.toString();
      operand = "";
      number2 = "";
    });
  }

  bool isOperator(String value) {
    return [
      Btn.add,
      Btn.subtract,
      Btn.multiply,
      Btn.divide,
      Btn.percent,
    ].contains(value);
  }

  Color getBtnColor(String value) {
    if ([Btn.clr, Btn.del].contains(value)) {
      return Colors.blueGrey;
    } else if (isOperator(value) || value == Btn.equals) {
      return Colors.orange;
    }
    return Colors.grey.shade800;
  }
}
