
import 'package:flutter/material.dart';

import 'rodada_screen.dart';
import 'afastamento_screen.dart';
import 'configurations_screen.dart';
import 'militares_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;

  final _titles = ['Fila de escalas', 'Rodadas', 'Militares', 'Afastamentos'];

  final _screens = const [
    FilaScreen(),
    RodadaScreen(),
    MilitaresScreen(),
    AfastamentoScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_tab]),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Configurações',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ConfiguracoesScreen()),
            ),
          ),
        ],
      ),
      body: _screens[_tab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_numbered_rounded),
            label: 'Fila',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Rodadas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline_rounded),
            label: 'Militares',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_busy_outlined),
            label: 'Afastamentos',
          ),
        ],
      ),
    );
  }
}





class FilaScreen extends StatelessWidget{
  const FilaScreen();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold();
  }
}
