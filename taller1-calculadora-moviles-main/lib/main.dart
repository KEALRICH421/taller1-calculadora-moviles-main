import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/calculadora_screen.dart';
//importar la pantalla HomeScreen desde la carpeta screens para poder usarla en la aplicación
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget { 
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
    title: 'Calculadora',
    theme: ThemeData.dark(),
    debugShowCheckedModeBanner: false,
    //home: HomeScreen());
    home: CalculadoraScreen());
    
    //desactivar el banner de depuración y establecer la pantalla de inicio como HomeScreen
  }
}

