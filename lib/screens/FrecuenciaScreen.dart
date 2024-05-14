import 'package:flutter/material.dart';
import 'package:gestion_gastos_by_barrios_antonio/repositories/frecuencia_repository.dart';
import 'package:gestion_gastos_by_barrios_antonio/models/frecuencia.dart';
import 'package:gestion_gastos_by_barrios_antonio/widgets/app_drawer.dart';

class FrecuenciaScreen extends StatefulWidget {
  @override
  _FrecuenciaScreenState createState() => _FrecuenciaScreenState();
}

class _FrecuenciaScreenState extends State<FrecuenciaScreen> {
  late List<Frecuencia> frecuencias;
  bool isLoading = true;
  final FrecuenciaRepository _frecuenciaRepository = FrecuenciaRepository();

  @override
  void initState() {
    super.initState();
    refreshFrecuencias();
  }

  Future refreshFrecuencias() async {
    setState(() => isLoading = true);
    frecuencias = await _frecuenciaRepository.retrieveFrecuencias();
    setState(() => isLoading = false);
  }

  void _showAddEditFrecuenciaDialog({Frecuencia? frecuencia}) {
    final TextEditingController descController =
        TextEditingController(text: frecuencia?.descripcion);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
              frecuencia == null ? 'Agregar Frecuencia' : 'Editar Frecuencia'),
          content: TextField(
            controller: descController,
            decoration: InputDecoration(hintText: 'Descripción'),
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text('Guardar'),
              onPressed: () async {
                final String description = descController.text.trim();
                if (description.isEmpty) return;

                if (frecuencia == null) {
                  await _frecuenciaRepository
                      .insertFrecuencia(Frecuencia(descripcion: description));
                } else {
                  await _frecuenciaRepository.updateFrecuencia(Frecuencia(
                      frecuenciaId: frecuencia.frecuenciaId,
                      descripcion: description));
                }

                Navigator.of(context).pop();
                refreshFrecuencias();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteFrecuencia(Frecuencia frecuencia) async {
    await _frecuenciaRepository.deleteFrecuencia(frecuencia.frecuenciaId!);
    refreshFrecuencias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Frecuencias'),
      ),
      drawer: AppDrawer(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: frecuencias.length,
              itemBuilder: (context, index) {
                final frecuencia = frecuencias[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    title: Text(frecuencia.descripcion),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showAddEditFrecuenciaDialog(
                              frecuencia: frecuencia),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteFrecuencia(frecuencia),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditFrecuenciaDialog(),
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
