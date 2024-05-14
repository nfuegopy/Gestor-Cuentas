import 'package:flutter/material.dart';
import 'package:gestion_gastos_by_barrios_antonio/repositories/categoria_repository.dart';
import 'package:gestion_gastos_by_barrios_antonio/models/categoria.dart';
import 'package:gestion_gastos_by_barrios_antonio/screens/ingresos_screen.dart';
import 'package:gestion_gastos_by_barrios_antonio/screens/gastos_screen.dart';
import 'package:gestion_gastos_by_barrios_antonio/screens/resumen_screen.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Categoria> categorias;
  bool isLoading = true;
  final CategoriaRepository _categoriaRepository = CategoriaRepository();

  @override
  void initState() {
    super.initState();
    loadCategorias();
  }

  Future loadCategorias() async {
    categorias = await _categoriaRepository.retrieveCategorias();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Gastos'),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Text("Bienvenido a la Gestión de Gastos"),
      ),
    );
  }
}
