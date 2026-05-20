// lib/screens/jogadores/jogadores_screen.dart
import 'package:flutter/material.dart';
import '../../models/jogador_model.dart';
import '../../models/time_model.dart';
import '../../services/api_service.dart';

class JogadoresScreen extends StatefulWidget {
  const JogadoresScreen({super.key});

  @override
  State<JogadoresScreen> createState() => _JogadoresScreenState();
}

class _JogadoresScreenState extends State<JogadoresScreen> {
  List<JogadorModel> _jogadores = [];
  List<TimeModel> _times = [];
  bool _loading = true;

  final _posicoes = ['Goleiro', 'Zagueiro', 'Lateral', 'Meio Campo', 'Atacante'];

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() => _loading = true);
    try {
      final jogadores = await ApiService.listarJogadores();
      final times = await ApiService.listarTimes();
      setState(() {
        _jogadores = jogadores;
        _times = times;
      });
    } catch (e) {
      _snack('Erro ao carregar: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  String _nomeTime(int id) {
    try {
      return _times.firstWhere((t) => t.id == id).nome;
    } catch (_) {
      return 'Time #$id';
    }
  }

  Future<void> _abrirDialog({JogadorModel? jogador}) async {
    final nomeCtrl = TextEditingController(text: jogador?.nome ?? '');
    String? posicao = jogador?.posicao ?? _posicoes.first;
    int? timeId = jogador?.timeId ?? (_times.isNotEmpty ? _times.first.id : null);

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          title: Text(jogador == null ? 'Novo Jogador' : 'Editar Jogador'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomeCtrl,
                  decoration: const InputDecoration(labelText: 'Nome do jogador'),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: posicao,
                  decoration: const InputDecoration(labelText: 'Posição'),
                  items: _posicoes
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (v) => setS(() => posicao = v),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  value: timeId,
                  decoration: const InputDecoration(labelText: 'Equipe'),
                  items: _times
                      .map((t) => DropdownMenuItem(value: t.id, child: Text(t.nome)))
                      .toList(),
                  onChanged: (v) => setS(() => timeId = v),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () async {
                if (timeId == null) return;
                final novo = JogadorModel(
                  id: jogador?.id,
                  nome: nomeCtrl.text.trim(),
                  posicao: posicao!,
                  timeId: timeId!,
                );
                try {
                  if (jogador == null) {
                    await ApiService.criarJogador(novo);
                  } else {
                    await ApiService.atualizarJogador(jogador.id!, novo);
                  }
                  Navigator.pop(ctx);
                  _carregar();
                } catch (e) {
                  _snack('Erro: $e');
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmarDelete(JogadorModel jogador) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir Jogador'),
        content: Text('Deseja excluir "${jogador.nome}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Não')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (ok == true) {
      try {
        await ApiService.deletarJogador(jogador.id!);
        _carregar();
      } catch (e) {
        _snack('Erro ao excluir: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogadores'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _jogadores.isEmpty
              ? const Center(child: Text('Nenhum jogador cadastrado'))
              : RefreshIndicator(
                  onRefresh: _carregar,
                  child: ListView.builder(
                    itemCount: _jogadores.length,
                    itemBuilder: (ctx, i) {
                      final j = _jogadores[i];
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(j.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${j.posicao} · ${_nomeTime(j.timeId)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _abrirDialog(jogador: j),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmarDelete(j),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[800],
        onPressed: () => _abrirDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
