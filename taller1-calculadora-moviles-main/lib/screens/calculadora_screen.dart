import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/botones.dart';

class CalculadoraScreen extends StatefulWidget {
  const CalculadoraScreen({super.key});

  @override
  State<CalculadoraScreen> createState() => _CalculadoraScreenState();
}

class _CalculadoraScreenState extends State<CalculadoraScreen> {
  String number1 =
      ''; //Variable para almacenar el primer número ingresado por el usuario
  String number2 =
      ''; //Variable para almacenar el segundo número ingresado por el usuario
  String operand =
      ''; //Variable para almacenar el operador seleccionado por el usuario (suma, resta, multiplicación, división)

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(
      context,
    ).size; //Variable para obtener el tamaño de la pantalla y poder adaptar el diseño a diferentes dispositivos
    return Scaffold(
      body: SafeArea(
        //Safe area para que el contenido no quede sobre la barra de tareas
        bottom:
            false, //Permite que el contenido se extienda hasta el borde inferior de la pantalla
        child: Column(
          children: [
            //Salida de la calculadora
            Expanded(
              child: SingleChildScrollView(
                reverse:
                    true, //Permite que el contenido se desplace hacia arriba cuando se agregan nuevos números o resultados
                child: Container(
                  alignment: Alignment
                      .bottomRight, //Alinea el contenido al fondo a la derecha
                  padding: const EdgeInsets.all(
                    16,
                  ), //Espaciado interno para que el texto no quede pegado a los bordes
                  child: Text(
                    '$number1$operand$number2'.isEmpty
                        ? '0'
                        : '$number1$operand$number2', //Muestra el número 1, el operador y el número 2 en la salida de la calculadora
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign
                        .end, //Alinea el texto a la derecha para simular la salida de una calculadora
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Wrap(
                children: Btn.buttonValues
                    .map(
                      (value) => SizedBox(
                        width: value == Btn.n0
                            ? (screenSize.width / 2)
                            : (screenSize.width /
                                  4), //Cada botón ocupa un cuarto del ancho de la pantalla
                        height:
                            (screenSize.width /
                            5), //Cada botón tiene una altura proporcional al ancho de la pantalla para mantener una apariencia consistente
                        child: buildButton(value),
                      ),
                    )
                    .toList(),
              ),
            ),

            //Botones de la calculadora
          ],
        ),
      ),
    );
  }

  Widget buildButton(String value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getBtnColor(
          value,
        ), //Determina el color del botón según su función (números, operadores, etc.)
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white24, width: 2),
          borderRadius: BorderRadius.circular(100),
        ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  //#############################################
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

  //##########################################
  void calculate() {
    if (number1.isEmpty || operand.isEmpty || number2.isEmpty) return;
    if (number1 == 'Error') return;

    double num1 = double.parse(number1);
    double num2 = double.parse(number2);

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
        if (num2 == 0) {
          clearAll();
          number1 = 'Error';
          setState(() {});
          return;
        }
        result = num1 / num2;
        break;
      default:
    }
    setState(() {
      number1 = result
          .toString(); //Muestra el resultado en la salida de la calculadora
      if (number1.endsWith('.0')) {
        number1 = number1.substring(
          0,
          number1.length - 2,
        ); // Elimina el ".0" si el resultado es un número entero
      }
      operand =
          ''; //Limpia el operador para permitir ingresar una nueva operación
      number2 =
          ''; //Limpia el segundo número para permitir ingresar una nueva operación
    });
  }

  //##########################################
  void convertToPercentage() {
    if (number1 == 'Error') return;
    if (number1.isEmpty) return;

    if (operand.isNotEmpty && number2.isNotEmpty) {
      calculate(); // Si hay una operación completa, primero calcular el resultado
    }

    if (number1.isEmpty || number1 == 'Error') return;

    final number = double.tryParse(number1);
    if (number == null) return;

    setState(() {
      number1 = (number / 100).toString();
      if (number1.endsWith('.0')) {
        number1 = number1.substring(0, number1.length - 2);
      }
      operand = '';
      number2 = '';
    });
  }

  //#########################################
  void clearAll() {
    // Limpia todos los valores para reiniciar la calculadora
    number1 = '';
    number2 = '';
    operand = '';
    setState(() {}); // Redibuja la pantalla con los valores limpios
  }

  //###########################################
  void delete() {
    // Elimina el último carácter ingresado, ya sea del segundo número, del operador o del primer número
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = '';
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }
    setState(
      () {},
    ); // Redibuja la pantalla con los nuevos valores después de eliminar
  }

  //##############################################

  void appendValue(String value) {
    if (number1 == 'Error') {
      number1 = '';
      operand = '';
      number2 = '';
    }

    bool isOperator = value != Btn.dot && int.tryParse(value) == null;

    if (isOperator) {
      if (number1.isEmpty) return;
      if (operand.isNotEmpty && number2.isEmpty) {
        operand = value;
        setState(() {});
        return;
      }
      if (operand.isNotEmpty && number2.isNotEmpty) {
        calculate();
      }
      operand = value;
      setState(() {});
      return;
    }

    if (operand.isEmpty) {
      if (value == Btn.dot && number1.contains(Btn.dot)) return;
      if (value == Btn.dot && number1.isEmpty) {
        number1 = '0.';
        setState(() {});
        return;
      }
      number1 += value;
      setState(() {});
      return;
    }

    if (value == Btn.dot && number2.contains(Btn.dot)) return;
    if (value == Btn.dot && number2.isEmpty) {
      number2 = '0.';
      setState(() {});
      return;
    }

    number2 += value;
    setState(() {});
  }

  //##############################################
  Color getBtnColor(String value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.blueGrey
        : [
            Btn.per,
            Btn.multiply,
            Btn.divide,
            Btn.add,
            Btn.subtract,
            Btn.calculate,
          ].contains(value)
        ? Colors.orange
        : Colors.black87;
  }
}
