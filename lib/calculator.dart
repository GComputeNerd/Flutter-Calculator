import 'package:flutter/material.dart';
import 'dart:math';

class CalculatorData extends ChangeNotifier {
  String result = "0"; // Stores user's input
  String operation = "";
  String buffer = "";

  int currentOP = -1; // Stores Operation to Perform

  bool operationApplied = false;

  String getResultString() {
    return result;
  }

  String getBufferString() {
    switch (currentOP) {
      case 1:
        operation = " +";
        break;
      case 2:
        operation = " -";
        break;
      case 3:
        operation = " ×";
        break;
      case 4:
        operation = " ÷";
        break;
      case 5:
        operation = "% of";
        break;
      case 6:
        operation = " ^";
        break;
    }

    return buffer +(operation);
  }

  void updateNumber(num x) {
    if (result[result.length - 1] == '%') {
      result = result.substring(0, result.length-1);
      setOP(5);
      result = x.toString();
      operationApplied = false;

      notifyListeners();

      return;
    }

    testAndResetBuffers();

    if (result == "0") {
      result = x.toString();
    } else {
      result = result +(x.toString());
    }

    notifyListeners();
  }

  void backspaceNumber() {
    testAndResetBuffers();

    if (result.length != 1) {
      result = result.substring(0, result.length -1);
    } else if (result == '0' && operation != "") {
      operation = "";
      currentOP = -1;
      result = buffer;
      buffer = "";
    } else {
      result = '0';
    }

    notifyListeners();
  }

  void makeDecimal() {
    testAndResetBuffers();
    
    if (result == '-') {
      result = result +('0.');
    } else if (!(result.contains('.'))) {
      result = result +('.');
    }

    notifyListeners();
  }

  void makePercentage() {
    if (!(result[result.length -1] == '%')) {
      result = result +('%');
    }

    notifyListeners();
  }

  void makeNegative() {
    if (result == '0') {
      result = '-';
    } else {
      setOP(2);
    }

    notifyListeners();
  }

  num parseNum(String x) {
    num answer;

    if (x[x.length - 1] == '%') {
      answer = num.parse(x.substring(0,x.length -1)) / 100;
    } else {
      answer = num.parse(x);
    }

    return answer;
  }

  void calculateExpression() {
    num num1 = buffer == "" ? 0 : parseNum(buffer);
    num num2 = parseNum(result);

    num answer = 0;
    bool applied = false;

    switch (currentOP) {
      case 1: // Addition
        answer = num2 + num1;
        applied = true;
        break;
      case 2: // Subtraction
        answer = num1 - num2;
        applied = true;
        break;
      case 3: // Multiplication
        answer = num1 * num2;
        applied = true;
        break;
      case 4: // Division
        answer = num1 / num2;
        applied = true;
        break;
      case 5: // Percentage
        answer = (num1)/100 * num2;
        applied = true;
        break;
      case 6:
        answer = pow(num1, num2);
        applied = true;
        break;
      case -1:
        if (result[result.length -1] == '%') {
          answer = num2;
          applied = true;
        }
        break;
    }

    if (applied) { // Operation was used, need to reset
        reset();
        result = answer.toString();
        operationApplied = true;
    }
  }

  void apply() {
    // Code to run calculation
    try {
      calculateExpression();
    } catch (e) {
      reset();
      result = "BAD EXPRESSION";
      operationApplied = true;
    }

    notifyListeners();
  }

  void setOP(int opCode) {
    // Sets Operation to be done
    if (currentOP == -1) {
      buffer = result;
      result = '0';
    }

    if (result == '0') {
      currentOP = opCode;
    } else if (result != '0' && currentOP != -1){
      apply();
      buffer = result;
      result = '0';
      currentOP = opCode;
    }

    operationApplied = false;

    notifyListeners();
  }

  void reset() {
    result = "0";
    operation = "";
    buffer = "";

    currentOP = -1;

    operationApplied = false;

    notifyListeners();
  }

  void testAndResetBuffers() {
    // Check whether to update current result, or start a new calculation
    if (operationApplied) {
      reset();
    }
  }
}