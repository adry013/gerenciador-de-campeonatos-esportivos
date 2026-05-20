// lib/screens/times/times_screen.dart
import 'package:flutter/material.dart';
import '../../models/time_model.dart';
import '../../services/api_service.dart';

class TimesScreen extends StatefulWidget {
  const TimesScreen({super.key});

  @override
  State<TimesScreen> createState() => _TimesScreenState();
}

class _TimesScreenState extends State<TimesScreen> {
  List<TimeModel> _times = [];
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
      setState(() => _times = times);
    } catch (e) {
      _snack('Erro ao carregar times: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _abrirDialog({TimeModel? time}) async {
    final nomeCtrl = TextEditingController(text: time?.nome ?? '');
    final cidadeCtrl = TextEditingController(text: time?.cidade ?? '');

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(time == null ? 'Novo Time' : 'Editar Time'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomeCtrl,
              decoration: const InputDecoration(labelText: 'Nome do time'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: cidadeCtrl,
              decoration: const InputDecoration(labelText: 'Cidade'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final novo = TimeModel(
                id: time?.id,
                nome: nomeCtrl.text.trim(),
                cidade: cidadeCtrl.text.trim(),
              );
              try {
                if (time == null) {
                  await ApiService.criarTime(novo);
                } else {
                  await ApiService.atualizarTime(time.id!, novo);
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
    );
  }

  Future<void> _confirmarDelete(TimeModel time) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir Time'),
        content: Text('Deseja excluir "${time.nome}"?'),
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
        await ApiService.deletarTime(time.id!);
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
        title: const Text('Equipes'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _times.isEmpty
              ? const Center(child: Text('Nenhum time cadastrado'))
              : RefreshIndicator(
                  onRefresh: _carregar,
                  child: ListView.builder(
                    itemCount: _times.length,
                    itemBuilder: (ctx, i) {
                      final t = _times[i];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue[800],
                          child: Text(
                            t.nome.substring(0, 1).toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(t.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(t.cidade),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _abrirDialog(time: t),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmarDelete(t),
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
