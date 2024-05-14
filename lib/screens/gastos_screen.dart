import 'package:flutter/material.dart';
import 'package:gestion_gastos_by_barrios_antonio/repositories/gasto_repository.dart';
import 'package:gestion_gastos_by_barrios_antonio/repositories/categoria_repository.dart';
import 'package:gestion_gastos_by_barrios_antonio/repositories/frecuencia_repository.dart';
import 'package:gestion_gastos_by_barrios_antonio/repositories/usuario_repository.dart';
import 'package:gestion_gastos_by_barrios_antonio/models/categoria.dart';
import 'package:gestion_gastos_by_barrios_antonio/models/frecuencia.dart';
import 'package:gestion_gastos_by_barrios_antonio/models/usuario.dart';
import 'package:gestion_gastos_by_barrios_antonio/widgets/app_drawer.dart';

class GastosScreen extends StatefulWidget {
  @override
  _GastosScreenState createState() => _GastosScreenState();
}

class _GastosScreenState extends State<GastosScreen> {
  late List<Map<String, dynamic>> gastos;
  late List<Categoria> categoriasEgreso;
  late List<Usuario> usuarios;
  late List<Frecuencia> frecuencias;
  bool isLoading = true;

  final GastoRepository _gastoRepository = GastoRepository();
  final CategoriaRepository _categoriaRepository = CategoriaRepository();
  final UsuarioRepository _usuarioRepository = UsuarioRepository();
  final FrecuenciaRepository _frecuenciaRepository = FrecuenciaRepository();

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    gastos = await _gastoRepository.retrieveGastos();
    categoriasEgreso =
        await _categoriaRepository.retrieveCategoriasPorTipo('egreso');
    usuarios = await _usuarioRepository.getUsers();
    frecuencias = await _frecuenciaRepository.retrieveFrecuencias();
    print(frecuencias);
    if (frecuencias.isEmpty) {
      print("Error: No se cargaron las frecuencias.");
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> loadGastos() async {
    gastos = await _gastoRepository.retrieveGastos();
    setState(() {
      isLoading = false;
    });
  }

  void _showAddGastoDialog({Map<String, dynamic>? gasto}) {
    final TextEditingController montoController =
        TextEditingController(text: gasto?['monto'].toString());
    final TextEditingController notasController =
        TextEditingController(text: gasto?['notas']);
    int? selectedCategoriaId = gasto != null
        ? gasto['categoria_id']
        : (categoriasEgreso.isNotEmpty
            ? categoriasEgreso.first.categoriaId
            : null);
    int? selectedUsuarioId = gasto != null
        ? gasto['usuario_id']
        : (usuarios.isNotEmpty ? usuarios.first.usuarioId : null);
    int? selectedFrecuenciaId = gasto != null
        ? gasto['frecuencia_id']
        : (frecuencias.isNotEmpty ? frecuencias.first.frecuenciaId : null);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(gasto == null ? "Agregar Gasto" : "Editar Gasto"),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: montoController,
                      decoration: InputDecoration(labelText: "Monto"),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                    ),
                    TextField(
                      controller: notasController,
                      decoration: InputDecoration(labelText: "Notas"),
                    ),
                    DropdownButton<int>(
                      value: selectedCategoriaId,
                      onChanged: (newValue) {
                        setState(() {
                          selectedCategoriaId = newValue;
                        });
                      },
                      items: categoriasEgreso
                          .map<DropdownMenuItem<int>>((Categoria categoria) {
                        return DropdownMenuItem<int>(
                          value: categoria.categoriaId,
                          child: Text(categoria.nombre),
                        );
                      }).toList(),
                    ),
                    DropdownButton<int>(
                      value: selectedUsuarioId,
                      onChanged: (newValue) {
                        setState(() {
                          selectedUsuarioId = newValue;
                        });
                      },
                      items: usuarios
                          .map<DropdownMenuItem<int>>((Usuario usuario) {
                        return DropdownMenuItem<int>(
                          value: usuario.usuarioId,
                          child: Text(usuario.nombre),
                        );
                      }).toList(),
                    ),
                    DropdownButton<int>(
                      value: selectedFrecuenciaId,
                      onChanged: (int? newValue) {
                        setState(() {
                          selectedFrecuenciaId = newValue;
                        });
                      },
                      items: frecuencias
                          .map<DropdownMenuItem<int>>((Frecuencia frecuencia) {
                        return DropdownMenuItem<int>(
                          value: frecuencia.frecuenciaId,
                          child: Text(frecuencia.descripcion),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text("Cancelar"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  child: Text(gasto == null ? "Guardar" : "Actualizar"),
                  onPressed: () async {
                    double? monto = double.tryParse(montoController.text);
                    print('Monto: $monto');
                    print('Categoria ID: $selectedCategoriaId');
                    print('Usuario ID: $selectedUsuarioId');
                    print('Frecuencia ID: $selectedFrecuenciaId');

                    if (monto != null &&
                        selectedCategoriaId != null &&
                        selectedUsuarioId != null &&
                        selectedFrecuenciaId != null) {
                      Map<String, dynamic> gastoData = {
                        'usuario_id': selectedUsuarioId,
                        'categoria_id': selectedCategoriaId,
                        'frecuencia_id': selectedFrecuenciaId,
                        'monto': monto,
                        'notas': notasController.text,
                        'fecha': DateTime.now().toIso8601String(),
                      };

                      if (gasto == null) {
                        await _gastoRepository.addGasto(gastoData);
                      } else {
                        gastoData['gasto_id'] = gasto['gasto_id'];
                        await _gastoRepository.updateGasto(gastoData);
                      }

                      Navigator.of(context).pop();
                      loadGastos();
                    } else {
                      print("Por favor, completa todos los campos.");
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text('Error'),
                          content: Text(
                              'Todos los campos son necesarios. Asegúrate de que todos los campos están completados.'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Ok'),
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                            )
                          ],
                        ),
                      );
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
        title: Text("Gastos"),
      ),
      drawer: AppDrawer(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: gastos.length,
              itemBuilder: (context, index) {
                final gasto = gastos[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    title: Text('${gasto['monto']} - ${gasto['fecha']}'),
                    subtitle: Text(gasto['notas']),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await _gastoRepository.deleteGasto(gasto['gasto_id']);
                        loadGastos();
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddGastoDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}
