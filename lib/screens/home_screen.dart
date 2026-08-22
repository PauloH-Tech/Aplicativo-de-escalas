import 'package:flutter/material.dart';

import 'fila_screen.dart';
import 'militares_inativos_screen.dart';
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
          if (_tab == 2)
            IconButton(
              padding: EdgeInsets.only(left: 16, right: 16),
              icon: const Icon(Icons.group_off_outlined),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MilitaresInativosScreen(),
                ),
              ),
            ),
          IconButton(
            padding: EdgeInsets.only(left: 16, right: 16),
            icon: const Icon(Icons.more_vert),
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
