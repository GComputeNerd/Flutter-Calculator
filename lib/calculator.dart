import 'package:flutter/material.dart';
import 'dart:math';

class CalculatorData extends ChangeNotifier {
  String result = "0"; // Stores user's input
  String operation = "";
  String buffer = "";

  int currentOP = -1; // Stores Operation to Perform

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
        operation = " *";
        break;
      case 4:
        operation = " /";
        break;
      case 5:
        operation = "% of";
        break;
    }

    return buffer +(operation);
  }

  void updateNumber(num x) {
    testAndResetBuffers();

    if (result == "0") {
      result = x.toString();
    } else {
      result = result +(x.toString());
    }

    notifyListeners();
  }

  void backspaceNumber() {
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
    
    if (!(result.contains('.'))) {
      result = result +('.');
    }

    notifyListeners();
  }

  void apply() {
    // Code to run calculation

    num num1 = buffer == "" ? 0 : num.parse(buffer);
    num num2 = num.parse(result);

    num answer = 0;

    switch (currentOP) {
      case 1: // Addition
        answer = num2 + num1;
        break;
      case 2: // Subtraction
        answer = num1 - num2;
        break;
      case 3: // Multiplication
        answer = num1 * num2;
        break;
      case 4: // Division
        answer = num1 / num2;
        break;
      case 5: // Percentage
        answer = (num1/100) * num2;
        break;
    }

    if (currentOP != -1) { // Operation was used, need to reset
      reset();
      result = answer.toString();
    }
    notifyListeners();
  }

  void setOP(int opCode) {
    // Sets Operation to be done
    if (currentOP == -1) {
      buffer = result;
      result = '0';
    }

    currentOP = opCode;

    notifyListeners();
  }

  void reset() {
    result = "0";
    operation = "";
    buffer = "";

    currentOP = -1;

    notifyListeners();
  }

  void testAndResetBuffers() {
    // Check whether to update current result, or start a new calculation
    
  }
}