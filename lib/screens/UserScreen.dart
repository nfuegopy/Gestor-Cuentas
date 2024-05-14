import 'package:flutter/material.dart';
import 'package:gestion_gastos_by_barrios_antonio/repositories/usuario_repository.dart';
import 'package:gestion_gastos_by_barrios_antonio/models/usuario.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late List<Usuario> users;
  bool isLoading = true;
  final UsuarioRepository _usuarioRepository = UsuarioRepository();

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    users = await _usuarioRepository.getUsers();
    setState(() {
      isLoading = false;
    });
  }

  void _showAddUserDialog({Usuario? user}) {
    final TextEditingController _nameController =
        TextEditingController(text: user?.nombre);
    final TextEditingController _emailController =
        TextEditingController(text: user?.correo);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(user == null ? "Agregar Usuario" : "Editar Usuario"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                  controller: _nameController,
                  decoration: InputDecoration(hintText: "Nombre")),
              TextField(
                  controller: _emailController,
                  decoration: InputDecoration(hintText: "Correo")),
            ],
          ),
          actions: <Widget>[
            TextButton(
                child: Text("Cancelar"),
                onPressed: () => Navigator.of(context).pop()),
            ElevatedButton(
              child: Text(user == null ? "Guardar" : "Actualizar"),
              onPressed: () async {
                String name = _nameController.text;
                String? email = _emailController.text.isNotEmpty
                    ? _emailController.text
                    : null;
                if (user == null) {
                  await _usuarioRepository.addUser(name, email);
                } else {
                  await _usuarioRepository.updateUser(
                      user.usuarioId, name, email);
                }
                Navigator.of(context).pop();
                loadUsers();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gestión de Usuarios')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                Usuario user = users[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(user.nombre[0]),
                    ),
                    title: Text(user.nombre),
                    subtitle: Text(user.correo ?? 'Sin correo'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showAddUserDialog(user: user)),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await _usuarioRepository.deleteUser(user.usuarioId);
                            loadUsers();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddUserDialog(), child: Icon(Icons.add)),
    );
  }
}
