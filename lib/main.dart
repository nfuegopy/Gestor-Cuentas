import 'package:flutter/material.dart';
import 'package:gestion_gastos_by_barrios_antonio/screens/dashboard_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Gastos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Color(0xFFF5F5F5),
        appBarTheme: AppBarTheme(
          color: Color.fromRGBO(74, 170, 238, 1),
        ),
        textTheme: TextTheme(
          headlineLarge: TextStyle( // Reemplazo de headline1
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 97, 178, 236)),
          titleLarge: TextStyle( // Reemplazo de headline6
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2A3E4C)),
          bodyMedium: TextStyle( // Reemplazo de bodyText2
              fontSize: 14.0, 
              color: Color(0xFF4F4F4F)),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFF2A3E4C),
          textTheme: ButtonTextTheme.primary,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF2A3E4C),
        ),
      ),
      home: DashboardScreen(),
    );
  }
}
