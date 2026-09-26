import 'package:flutter/material.dart';
import 'package:sistema_escalas_front/screens/login_screen.dart';
import 'package:sistema_escalas_front/utils/navegacao_auth.dart';
import 'package:sistema_escalas_front/widgets/app_theme.dart';

import 'fila_screen.dart';
import 'militares_inativos_screen.dart';
import 'rodada_screen.dart';
import 'afastamento_screen.dart';
import 'configurations_screen.dart';
import 'militares_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
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
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.60,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: 50,
                  bottom: 20,
                  left: 16,
                  right: 16,
                ),
                color: AppTheme.primary,
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Início'),
                onTap: () {
                  setState(() => _tab = 0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Configurações'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ConfiguracoesScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sair'),
                onTap: () => NavegacaoAuth.sair(context),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(_titles[_tab]),
        actions: [
          if (_tab == 2)
            IconButton(
              padding: EdgeInsets.only(left: 16, right: 16),
              icon: const Icon(Icons.group_off_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MilitaresInativosScreen(),
                  ),
                );
              },
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
