import 'package:flutter/material.dart';
import 'package:gestion_gastos_by_barrios_antonio/repositories/resumen_repository.dart';
import 'package:gestion_gastos_by_barrios_antonio/models/usuario.dart';
import 'package:gestion_gastos_by_barrios_antonio/repositories/usuario_repository.dart';
import 'package:intl/intl.dart';
import 'package:gestion_gastos_by_barrios_antonio/widgets/app_drawer.dart';

class ResumenScreen extends StatefulWidget {
  @override
  _ResumenScreenState createState() => _ResumenScreenState();
}

class _ResumenScreenState extends State<ResumenScreen> {
  final ResumenRepository _resumenRepository = ResumenRepository();
  final UsuarioRepository _usuarioRepository = UsuarioRepository();
  late List<Usuario> usuarios;
  int selectedUserId = 0;
  double monthlyBalance = 0.0;
  DateTime selectedDate = DateTime.now();
  bool isLoading = true;
  List<Map<String, dynamic>> monthlyMovements = [];

  @override
  void initState() {
    super.initState();
    loadUsuarios();
  }

  Future<void> loadUsuarios() async {
    usuarios = await _usuarioRepository.getUsers();
    if (usuarios.isNotEmpty) {
      selectedUserId = usuarios.first.usuarioId;
      calculateBalance();
      loadMovements();
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> calculateBalance() async {
    setState(() => isLoading = true);
    print(
        'Calculating balance for user $selectedUserId for month ${selectedDate.month} and year ${selectedDate.year}');
    int month = selectedDate.month;
    int year = selectedDate.year;
    monthlyBalance = await _resumenRepository.calculateMonthlyBalance(
        selectedUserId, month, year);
    print('Monthly Balance: $monthlyBalance');
    setState(() => isLoading = false);
  }

  Future<void> loadMovements() async {
    int month = selectedDate.month;
    int year = selectedDate.year;
    monthlyMovements = await _resumenRepository.getMonthlyMovements(
        selectedUserId, month, year);
    setState(() {});
  }

  void _showDatePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
      calculateBalance();
      loadMovements();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resumen Mensual'),
      ),
      drawer: AppDrawer(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButton<int>(
                    value: selectedUserId,
                    onChanged: (newValue) {
                      setState(() {
                        selectedUserId = newValue!;
                      });
                      calculateBalance();
                      loadMovements();
                    },
                    items: usuarios.map((usuario) {
                      return DropdownMenuItem<int>(
                        value: usuario.usuarioId,
                        child: Text(usuario.nombre),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Selecciona el mes y año',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        DateFormat('MMMM yyyy').format(selectedDate),
                        style: TextStyle(fontSize: 18),
                      ),
                      IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: _showDatePicker,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Sobra:',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '\$${monthlyBalance.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 24,
                      color: monthlyBalance >= 0 ? Colors.green : Colors.red,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Historial:',
                    style: TextStyle(fontSize: 20),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: monthlyMovements.length,
                      itemBuilder: (context, index) {
                        final movimiento = monthlyMovements[index];
                        return Card(
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: ListTile(
                            title: Text(
                                '${movimiento['tipo']}: \$${movimiento['monto']}'),
                            subtitle: Text(
                                '${DateFormat('dd/MM').format(DateTime.parse(movimiento['fecha']))} - ${movimiento['notas'] ?? ''}'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
