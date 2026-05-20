// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/times/times_screen.dart';
import 'screens/jogadores/jogadores_screen.dart';
import 'screens/partidas/partidas_screen.dart';

void main() {
  runApp(const CampeonatoApp());
}

class CampeonatoApp extends StatelessWidget {
  const CampeonatoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campeonato Esportivo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue[800]!),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _paginaAtual = 0;

  final _paginas = const [
    DashboardScreen(),
    TimesScreen(),
    JogadoresScreen(),
    PartidasScreen(),
  ];

  final _labels = ['Dashboard', 'Equipes', 'Jogadores', 'Partidas'];
  final _icons = [
    Icons.home,
    Icons.group,
    Icons.person,
    Icons.sports_soccer,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: const Text(
          'Campeonato Esportivo',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue[800]),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sports_soccer, size: 48, color: Colors.white),
                    SizedBox(height: 8),
                    Text(
                      'Sistema Campeonato',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            ...List.generate(_labels.length, (i) {
              return ListTile(
                leading: Icon(_icons[i], color: _paginaAtual == i ? Colors.blue[800] : Colors.grey),
                title: Text(
                  _labels[i],
                  style: TextStyle(
                    color: _paginaAtual == i ? Colors.blue[800] : null,
                    fontWeight: _paginaAtual == i ? FontWeight.bold : null,
                  ),
                ),
                selected: _paginaAtual == i,
                onTap: () {
                  setState(() => _paginaAtual = i);
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
      body: _paginas[_paginaAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _paginaAtual,
        onTap: (i) => setState(() => _paginaAtual = i),
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: List.generate(
          _labels.length,
          (i) => BottomNavigationBarItem(icon: Icon(_icons[i]), label: _labels[i]),
        ),
      ),
    );
  }
}
