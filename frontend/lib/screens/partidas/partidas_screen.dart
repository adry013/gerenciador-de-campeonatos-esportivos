// lib/screens/partidas/partidas_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/partida_model.dart';
import '../../models/time_model.dart';
import '../../services/api_service.dart';

class PartidasScreen extends StatefulWidget {
  const PartidasScreen({super.key});

  @override
  State<PartidasScreen> createState() => _PartidasScreenState();
}

class _PartidasScreenState extends State<PartidasScreen> {
  List<PartidaModel> _partidas = [];
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
      final partidas = await ApiService.listarPartidas();
      final times = await ApiService.listarTimes();
      setState(() {
        _partidas = partidas;
        _times = times;
      });
    } catch (e) {
      _snack('Erro ao carregar: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  String _nomeTime(int id) {
    try {
      return _times.firstWhere((t) => t.id == id).nome;
    } catch (_) {
      return 'Time #$id';
    }
  }

  Future<void> _abrirDialog({PartidaModel? partida}) async {
    final placarCasaCtrl =
        TextEditingController(text: partida?.placarCasa.toString() ?? '0');
    final placarVisCtrl =
        TextEditingController(text: partida?.placarVisitante.toString() ?? '0');

    DateTime dataSelecionada = partida != null
        ? DateTime.parse(partida.data)
        : DateTime.now();

    int? casaId = partida?.timeCasaId ?? (_times.isNotEmpty ? _times.first.id : null);
    int? visId = partida?.timeVisitanteId ??
        (_times.length > 1 ? _times[1].id : _times.first.id);

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          title: Text(partida == null ? 'Nova Partida' : 'Editar Partida'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // data
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.calendar_today),
                  title: Text(DateFormat('dd/MM/yyyy').format(dataSelecionada)),
                  subtitle: const Text('Data da partida'),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: dataSelecionada,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setS(() => dataSelecionada = picked);
                  },
                ),
                const Divider(),
                DropdownButtonFormField<int>(
                  value: casaId,
                  decoration: const InputDecoration(labelText: 'Time da Casa'),
                  items: _times
                      .map((t) => DropdownMenuItem(value: t.id, child: Text(t.nome)))
                      .toList(),
                  onChanged: (v) => setS(() => casaId = v),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: placarCasaCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Gols Casa'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  value: visId,
                  decoration: const InputDecoration(labelText: 'Time Visitante'),
                  items: _times
                      .map((t) => DropdownMenuItem(value: t.id, child: Text(t.nome)))
                      .toList(),
                  onChanged: (v) => setS(() => visId = v),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: placarVisCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Gols Visitante'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () async {
                if (casaId == null || visId == null) return;
                final nova = PartidaModel(
                  id: partida?.id,
                  data: DateFormat('yyyy-MM-dd').format(dataSelecionada),
                  timeCasaId: casaId!,
                  timeVisitanteId: visId!,
                  placarCasa: int.tryParse(placarCasaCtrl.text) ?? 0,
                  placarVisitante: int.tryParse(placarVisCtrl.text) ?? 0,
                );
                try {
                  if (partida == null) {
                    await ApiService.criarPartida(nova);
                  } else {
                    await ApiService.atualizarPartida(partida.id!, nova);
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

  Future<void> _confirmarDelete(PartidaModel partida) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir Partida'),
        content: Text(
            'Excluir partida ${_nomeTime(partida.timeCasaId)} x ${_nomeTime(partida.timeVisitanteId)}?'),
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
        await ApiService.deletarPartida(partida.id!);
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
        title: const Text('Partidas'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _partidas.isEmpty
              ? const Center(child: Text('Nenhuma partida cadastrada'))
              : RefreshIndicator(
                  onRefresh: _carregar,
                  child: ListView.builder(
                    itemCount: _partidas.length,
                    itemBuilder: (ctx, i) {
                      final p = _partidas[i];
                      final data = DateTime.tryParse(p.data);
                      final dataFmt = data != null
                          ? DateFormat('dd/MM/yyyy').format(data)
                          : p.data;
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.orange,
                            child: Icon(Icons.sports_soccer, color: Colors.white),
                          ),
                          title: Text(
                            '${_nomeTime(p.timeCasaId)} x ${_nomeTime(p.timeVisitanteId)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(dataFmt),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.blue[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${p.placarCasa} x ${p.placarVisitante}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _abrirDialog(partida: p),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _confirmarDelete(p),
                              ),
                            ],
                          ),
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
