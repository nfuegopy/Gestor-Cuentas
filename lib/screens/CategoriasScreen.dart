import 'package:flutter/material.dart';
import 'package:gestion_gastos_by_barrios_antonio/repositories/categoria_repository.dart';
import 'package:gestion_gastos_by_barrios_antonio/models/categoria.dart';

class CategoriasScreen extends StatefulWidget {
  @override
  _CategoriasScreenState createState() => _CategoriasScreenState();
}

class _CategoriasScreenState extends State<CategoriasScreen> {
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

  void _showAddCategoryDialog({Categoria? categoria}) {
    TextEditingController _controller =
        TextEditingController(text: categoria?.nombre);
    String? selectedType = categoria?.tipo ?? 'ingreso';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              Text(categoria == null ? "Añadir Categoría" : "Editar Categoría"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _controller,
                decoration: InputDecoration(hintText: "Nombre de la Categoría"),
              ),
              DropdownButton<String>(
                value: selectedType,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedType = newValue!;
                  });
                },
                items: <String>['ingreso', 'egreso']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancelar"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text(categoria == null ? "Guardar" : "Actualizar"),
              onPressed: () async {
                if (_controller.text.isNotEmpty) {
                  Categoria updatedCategory = Categoria(
                    categoriaId: categoria
                        ?.categoriaId, // Mantener el mismo ID para actualización
                    nombre: _controller.text,
                    tipo: selectedType!,
                  );
                  if (categoria == null) {
                    await _categoriaRepository.addCategoria(updatedCategory);
                  } else {
                    await _categoriaRepository.updateCategoria(updatedCategory);
                  }
                  _controller.clear();
                  Navigator.of(context).pop();
                  loadCategorias(); // Recargar la lista después de añadir/editar
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteCategory(int id) async {
    await _categoriaRepository.deleteCategoria(id);
    loadCategorias(); // Recargar la lista después de eliminar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gestión de Categorías')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: categorias.length,
              itemBuilder: (context, index) {
                final categoria = categorias[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    title: Text('${categoria.nombre} (${categoria.tipo})'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () =>
                              _showAddCategoryDialog(categoria: categoria),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              _deleteCategory(categoria.categoriaId!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCategoryDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}
