import 'package:flutter/material.dart';
import 'package:gestion_gastos_by_barrios_antonio/repositories/ingreso_repository.dart';
import 'package:gestion_gastos_by_barrios_antonio/repositories/categoria_repository.dart';
import 'package:gestion_gastos_by_barrios_antonio/repositories/usuario_repository.dart';
import 'package:gestion_gastos_by_barrios_antonio/models/categoria.dart';
import 'package:gestion_gastos_by_barrios_antonio/models/usuario.dart';
import 'package:gestion_gastos_by_barrios_antonio/widgets/app_drawer.dart';

class IngresosScreen extends StatefulWidget {
  @override
  _IngresosScreenState createState() => _IngresosScreenState();
}

class _IngresosScreenState extends State<IngresosScreen> {
  late List<Map<String, dynamic>> ingresos;
  late List<Categoria> categoriasIngreso;
  late List<Usuario> usuarios;
  bool isLoading = true;

  final IngresoRepository _ingresoRepository = IngresoRepository();
  final CategoriaRepository _categoriaRepository = CategoriaRepository();
  final UsuarioRepository _usuarioRepository = UsuarioRepository();

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    ingresos = await _ingresoRepository.retrieveIngresos();
    categoriasIngreso =
        await _categoriaRepository.retrieveCategoriasPorTipo('ingreso');
    usuarios = await _usuarioRepository.getUsers();
    setState(() {
      isLoading = false;
    });
  }

  void _showAddIngresoDialog() {
    final TextEditingController montoController = TextEditingController();
    final TextEditingController notasController = TextEditingController();
    int? selectedCategoriaId = categoriasIngreso.isNotEmpty
        ? categoriasIngreso.first.categoriaId
        : null;
    int? selectedUsuarioId =
        usuarios.isNotEmpty ? usuarios.first.usuarioId : null;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: Text("Agregar Ingreso"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: montoController,
                    decoration: InputDecoration(hintText: "Monto"),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                  ),
                  TextField(
                    controller: notasController,
                    decoration: InputDecoration(hintText: "Notas"),
                  ),
                  DropdownButton<int>(
                    value: selectedCategoriaId,
                    onChanged: (newValue) =>
                        setModalState(() => selectedCategoriaId = newValue),
                    items: categoriasIngreso
                        .map((categoria) => DropdownMenuItem<int>(
                              value: categoria.categoriaId,
                              child: Text(categoria.nombre),
                            ))
                        .toList(),
                  ),
                  DropdownButton<int>(
                    value: selectedUsuarioId,
                    onChanged: (newValue) =>
                        setModalState(() => selectedUsuarioId = newValue),
                    items: usuarios
                        .map((usuario) => DropdownMenuItem<int>(
                              value: usuario.usuarioId,
                              child: Text(usuario.nombre),
                            ))
                        .toList(),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text("Cancelar"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  child: Text("Guardar"),
                  onPressed: () async {
                    double? monto = double.tryParse(montoController.text);
                    if (monto != null &&
                        selectedCategoriaId != null &&
                        selectedUsuarioId != null) {
                      Map<String, dynamic> newIngreso = {
                        'usuario_id': selectedUsuarioId,
                        'categoria_id': selectedCategoriaId,
                        'monto': monto,
                        'notas': notasController.text,
                        'fecha': DateTime.now().toIso8601String(),
                      };
                      await _ingresoRepository.addIngreso(newIngreso);
                      Navigator.of(context).pop();
                      loadInitialData();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ingresos"),
      ),
      drawer: AppDrawer(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: ingresos.length,
              itemBuilder: (context, index) {
                final ingreso = ingresos[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    title: Text('${ingreso['monto']} - ${ingreso['fecha']}'),
                    subtitle: Text(ingreso['notas']),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await _ingresoRepository
                            .deleteIngreso(ingreso['ingreso_id']);
                        loadInitialData();
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddIngresoDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
