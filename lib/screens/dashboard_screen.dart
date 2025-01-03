import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gestion_gastos_by_barrios_antonio/widgets/app_drawer.dart';
import 'package:gestion_gastos_by_barrios_antonio/repositories/resumen_repository.dart';
import 'package:gestion_gastos_by_barrios_antonio/models/usuario.dart';
import 'package:gestion_gastos_by_barrios_antonio/repositories/usuario_repository.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ResumenRepository _resumenRepository = ResumenRepository();
  final UsuarioRepository _usuarioRepository = UsuarioRepository();
  late List<Usuario> usuarios;
  int selectedUserId = 0;
  double totalIngresos = 0.0;
  double totalEgresos = 0.0;
  double totalDisponible = 0.0;
  DateTime selectedDate = DateTime.now();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUsuarios();
  }

  Future<void> loadUsuarios() async {
    usuarios = await _usuarioRepository.getUsers();
    if (usuarios.isNotEmpty) {
      selectedUserId = usuarios.first.usuarioId;
      loadData();
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);
    int month = selectedDate.month;
    int year = selectedDate.year;

    totalIngresos =
        await _resumenRepository.getTotalIngresos(selectedUserId, month, year);
    totalEgresos =
        await _resumenRepository.getTotalEgresos(selectedUserId, month, year);
    totalDisponible = totalIngresos - totalEgresos;

    setState(() => isLoading = false);
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
      loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inicio"),
      ),
      drawer: AppDrawer(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDropdownButton(),
                  SizedBox(height: 20),
                  _buildDatePicker(),
                  SizedBox(height: 20),
                  _buildSummaryCard('Ingresos', totalIngresos, Colors.green),
                  _buildSummaryCard('Egresos', totalEgresos, Colors.red),
                  _buildSummaryCard(
                    'Disponible',
                    totalDisponible,
                    totalDisponible >= 0 ? Colors.green : Colors.red,
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: _buildBarChart(),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildDropdownButton() {
    return DropdownButton<int>(
      value: selectedUserId,
      onChanged: (newValue) {
        setState(() {
          selectedUserId = newValue!;
        });
        loadData();
      },
      items: usuarios.map((usuario) {
        return DropdownMenuItem<int>(
          value: usuario.usuarioId,
          child: Text(usuario.nombre),
        );
      }).toList(),
    );
  }

  Widget _buildDatePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    );
  }

  Widget _buildSummaryCard(String title, double amount, Color color) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 20),
        ),
        subtitle: Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 18, color: color),
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: totalIngresos > totalEgresos ? totalIngresos : totalEgresos,
            barGroups: [
              BarChartGroupData(
                x: 0,
                barRods: [
                  BarChartRodData(
                    toY: totalIngresos, // Cambio de "y" a "toY"
                    color: Colors.green,
                    width: 20,
                  ),
                ],
                showingTooltipIndicators: [0],
              ),
              BarChartGroupData(
                x: 1,
                barRods: [
                  BarChartRodData(
                    toY: totalEgresos, // Cambio de "y" a "toY"
                    color: Colors.red,
                    width: 20,
                  ),
                ],
                showingTooltipIndicators: [0],
              ),
            ],
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles( // Cambio de SideTitles a AxisTitles
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles( // Cambio de SideTitles a AxisTitles
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value == 0 ? 'Ingresos' : 'Egresos',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
