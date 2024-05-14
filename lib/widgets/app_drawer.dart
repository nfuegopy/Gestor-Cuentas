import 'package:flutter/material.dart';
import '../screens/CategoriasScreen.dart';
import '../screens/UserScreen.dart';
import '../screens/ingresos_screen.dart';
import '../screens/gastos_screen.dart';
import '../screens/resumen_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/FrecuenciaScreen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_balance_wallet,
                    color: Colors.white, size: 48),
                SizedBox(height: 16),
                Text(
                  'Control de Gastos',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Inicio'),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => DashboardScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Cuentas'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.category),
            title: Text('Categorías'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CategoriasScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.money),
            title: Text('Ingresos'),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => IngresosScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.money_off),
            title: Text('Gastos'),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => GastosScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.assessment),
            title: Text('Resumen'),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => ResumenScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.repeat),
            title: Text('Frecuencias'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FrecuenciaScreen()));
            },
          ),
        ],
      ),
    );
  }
}
