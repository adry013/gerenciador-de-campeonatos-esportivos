// lib/screens/dashboard/dashboard_screen.dart
import 'package:flutter/material.dart';
import '../../models/partida_model.dart';
import '../../services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _totalTimes = 0;
  int _totalJogadores = 0;
  int _totalPartidas = 0;
  int _totalGols = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() => _loading = true);
    try {
      final times = await ApiService.listarTimes();
      final jogadores = await ApiService.listarJogadores();
      final partidas = await ApiService.listarPartidas();
      int gols = 0;
      for (final p in partidas) {
        gols += p.placarCasa + p.placarVisitante;
      }
      setState(() {
        _totalTimes = times.length;
        _totalJogadores = jogadores.length;
        _totalPartidas = partidas.length;
        _totalGols = gols;
      });
    } catch (_) {
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _carregar,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dashboard Geral',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Resumo das informações do campeonato',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else ...[
              _CardInfo(
                icon: Icons.group,
                label: 'Total de Equipes',
                valor: _totalTimes,
                cor: Colors.blue,
              ),
              _CardInfo(
                icon: Icons.person,
                label: 'Total de Jogadores',
                valor: _totalJogadores,
                cor: Colors.green,
              ),
              _CardInfo(
                icon: Icons.sports_soccer,
                label: 'Total de Partidas',
                valor: _totalPartidas,
                cor: Colors.orange,
              ),
              _CardInfo(
                icon: Icons.emoji_events,
                label: 'Gols Marcados',
                valor: _totalGols,
                cor: Colors.amber,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CardInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final int valor;
  final Color cor;

  const _CardInfo({
    required this.icon,
    required this.label,
    required this.valor,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: cor.withOpacity(0.15),
          child: Icon(icon, color: cor),
        ),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: Text(
          '$valor',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: cor,
          ),
        ),
      ),
    );
  }
}
