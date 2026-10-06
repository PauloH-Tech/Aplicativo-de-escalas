import 'package:flutter/material.dart';
import 'package:escalas_extras/screens/login_screen.dart';
import 'package:escalas_extras/utils/navegacao_auth.dart';
import 'package:escalas_extras/widgets/app_theme.dart';

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
          child: Column(
            children: [
              Container(
                width: double.infinity,
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
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.home),
                      title: const Text('Início'),
                      onTap: () {
                        setState(() => _tab = 0);
                        Navigator.pop(context);
                      },
                    ),
                    // ListTile(
                    //   leading: const Icon(Icons.settings),
                    //   title: const Text('Configurações'),
                    //   onTap: () {
                    //     Navigator.pop(context);
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => const ConfiguracoesScreen(),
                    //       ),
                    //     );
                    //   },
                    // ),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Sair'),
                      onTap: () => NavegacaoAuth.sair(context),
                    ),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: const Text(
                    'Versão do app: 1.0.0',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ),
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
