import 'package:flutter/material.dart';
import 'dart:math';

class CalculatorData extends ChangeNotifier {
  num result = 0; // Stores current result
  num prevResult = 0; // Stores previous result
  int currentOP = -1; // Tracks current operation being used.

  bool applied = false; // Checks whether the operation has been applied or not.

  // To keep track of decimals
  bool isDecimal = false;
  int decimalPower = 0; 
  num decimalPart = 0;

  String getResultString() {
    if (!(isDecimal)) {
      return result.toString();
    }

    // The number is decimal
    if (decimalPower == 0) { // No decimal part
      return result.toString() +(".");
    }

    return getResultDecimal().toString();
  }

  String getBufferString() {
    if (currentOP == -1 && prevResult == 0) {
      return "";
    }

    var result = prevResult.toString();
    
    switch (currentOP) {
      case 1:
        result = result +(" +");
        break;
      case 2:
        result = result +(" -");
        break;
      case 3:
        result = result +(" *");
        break;
      case 4:
        result = result +(" /");
        break;
      case 5:
        result = result +("% of");
        break;
    }

    return result;
  }

  num getResultDecimal() {
    num  resultDecimal = 0;
    if (result >= 0) {
      resultDecimal = result + decimalPart/pow(10, decimalPower);
    } else {
      resultDecimal = result - decimalPart/pow(10, decimalPower);
    }

    return resultDecimal;
  }

  void updateNumber(num x) {
    testAndResetBuffers();

    // Logic to update number
    if (!(isDecimal)) {
      if (result >= 0) {
        result = result*10 + x;
      } else {
        result = result*10 - x;
      }
    } else {
      // is Decimal
      decimalPart = decimalPart*10 + x;
      decimalPower++;
    }

    notifyListeners();
  }

  void backspaceNumber() {
    if (isDecimal) {
      if (decimalPart == 0) {
        isDecimal = false;
      } else {
      decimalPart = decimalPart ~/ 10;
      decimalPower--;
      }
    } else {
      result = result ~/ 10;
    }

    notifyListeners();
  }

  void makeDecimal() {
    testAndResetBuffers();
    isDecimal = true;

    notifyListeners();
  }

  void apply() {
    result = isDecimal ? getResultDecimal() : result;
    resetDecimal();

    switch (currentOP) {
      case 1: // Addition
        result = result + prevResult;
        break;
      case 2: // Subtraction
        result = prevResult - result;
        break;
      case 3: // Multiplication
        result = prevResult * result;
        break;
      case 4: // Division
        result = prevResult / result;
        break;
      case 5: // Percentage
        result = (prevResult/100) * result;
        break;
    }

    if (currentOP != -1) { // Operation was used, need to reset
      var temp = result;
      reset();
      result = temp;
      applied = true;
    }
    notifyListeners();
  }

  void setOP(int opCode) {
    apply();
    currentOP = opCode;
    prevResult = result;
    result = 0;
    notifyListeners();
  }

  void reset() {
    result = 0;
    prevResult = 0;
    currentOP = -1;

    applied = false;

    resetDecimal();

    notifyListeners();
  }

  void resetDecimal() {
    isDecimal = false;
    decimalPower = 0;
    decimalPart = 0;
  }

  void testAndResetBuffers() {
    // Check whether to update current result, or start a new calculation
    if (applied == true && currentOP == -1) {
      if (currentOP == -1) {
        // Operations were all applied. So type new number
        result = 0;
        prevResult = 0;
        applied = false;
      } else {
        // Currently in a new operation. Must retain result
        applied = false;
      }
    }
  }
}