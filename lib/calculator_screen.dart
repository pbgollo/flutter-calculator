import 'package:flutter/material.dart';
import 'package:flutter_calculator/button_values.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  
  String number1 = ""; // . 0-9
  String operand = ""; // + - * /
  String number2 = ""; // . 0-9
  
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Output
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "$number1$operand$number2".isEmpty
                      ?"0"
                      :"$number1$operand$number2",
                    style: const TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),

          // Buttons
          Wrap(
            children: Btn.buttonValues
              .map(
                (value) => SizedBox(
                  width: value==Btn.n0
                    ?screenSize.width/2
                    :screenSize.width/4,
                  height: screenSize.width/5,
                  child: buildButton(value),
                ),
              )
              .toList(),
          )

          ],
        ),
      ),
    );
  }

  Widget buildButton(value){
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color.fromRGBO(51, 51, 51, 1)
          ),
          borderRadius: BorderRadius.circular(100)
        ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(value, style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ########
  void onBtnTap(String value){
    if(value==Btn.del){
      delete();
      return;
    }

    if(value==Btn.clr){
      clearAll();
      return;
    }

    if(value==Btn.per){
      convertToPercentage();
      return;
    }

    if(value==Btn.calculate){
      calculate();
      return;
    }

    appendValue(value);
  }

  // ########
  // Aplica os operadores e calcula o resultado
  void calculate(){
    if (number1.isEmpty) return;
    if (operand.isEmpty) return;
    if (number2.isEmpty) return;

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
        result = num1 / num2;
        break;
      default:
    }
    setState(() {
      number1 = "$result";

      if(number1.endsWith(".0")){
        number1 = number1.substring(0,number1.length-2);
      }

      operand = "";
      number2 = "";
    });
  }

  // ########
  // Converte o número para porcentagem
  void convertToPercentage(){
    if(number1.isNotEmpty&&operand.isNotEmpty&&number2.isNotEmpty){
      // Calcular antes de converter
      calculate();
    }
    if (operand.isNotEmpty) {
      // Não pode ser convertido
      return;
    }
    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}";
      operand = "";
      number2 = "";

      if(number1.endsWith(".0")){
        number1 = number1.substring(0,number1.length-2);
      }
    });
  }

  // ########
  // Limpa a toda a saida
  void clearAll(){
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
    });
  }

  // ########
  // Deleta o ultimo digito
  void delete(){
    if(number2.isNotEmpty){
      number2=number2.substring(0,number2.length-1);
    } else if(operand.isNotEmpty){
      operand = "";
    } else if(number1.isNotEmpty){
      number1=number1.substring(0,number1.length-1);
    }
    setState(() {});
  }

  // ########
  void appendValue(String value){
    // Verifica se é um operando
    if(value!=Btn.dot&&int.tryParse(value)==null){
      if(operand.isNotEmpty&&number2.isNotEmpty){
        calculate();
      }
      operand = value;
      // Atribui valor para o number1
    } else if(number1.isEmpty||operand.isEmpty){
      // Trata o caso do "."
      if(value==Btn.dot && number1.contains(Btn.dot)) return;
      if(value==Btn.dot && (number1.isEmpty || number1==Btn.n0)) {
        value = "0.";
      }
      number1 += value;
      // Atribui valor para o number2
    } else if(number2.isEmpty||operand.isNotEmpty){
      // Trata o caso do "."
      if(value==Btn.dot && number2.contains(Btn.dot)) return;
      if(value==Btn.dot && (number2.isEmpty || number2==Btn.n0)) {
        value = "0.";
      }
      number2 += value;
  }
    setState(() {});
  }

  // ########
  Color getBtnColor(value) {
    return [Btn.del, Btn.clr, Btn.per].contains(value)
          ?const Color.fromRGBO(150, 150, 150, 1)
            :[
              Btn.multiply, Btn.divide, Btn.add, Btn.subtract, Btn.calculate
            ].contains(value)
              ?const Color.fromRGBO(255, 149, 0, 1)
              :const Color.fromRGBO(51, 51, 51, 1);
  }

}