// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/time_model.dart';
import '../models/jogador_model.dart';
import '../models/partida_model.dart';

class ApiService {
  static final _headers = {'Content-Type': 'application/json'};

  // ─── TIMES ────────────────────────────────────────────────────────────────

  static Future<List<TimeModel>> listarTimes() async {
    final res = await http.get(Uri.parse('$baseUrl/times'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => TimeModel.fromJson(e)).toList();
    }
    throw Exception('Erro ao listar times');
  }

  static Future<void> criarTime(TimeModel time) async {
    final res = await http.post(
      Uri.parse('$baseUrl/times'),
      headers: _headers,
      body: jsonEncode(time.toJson()),
    );
    if (res.statusCode != 201) throw Exception('Erro ao criar time');
  }

  static Future<void> atualizarTime(int id, TimeModel time) async {
    final res = await http.put(
      Uri.parse('$baseUrl/times/$id'),
      headers: _headers,
      body: jsonEncode(time.toJson()),
    );
    if (res.statusCode != 200) throw Exception('Erro ao atualizar time');
  }

  static Future<void> deletarTime(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/times/$id'));
    if (res.statusCode != 200) throw Exception('Erro ao deletar time');
  }

  // ─── JOGADORES ────────────────────────────────────────────────────────────

  static Future<List<JogadorModel>> listarJogadores() async {
    final res = await http.get(Uri.parse('$baseUrl/jogadores'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => JogadorModel.fromJson(e)).toList();
    }
    throw Exception('Erro ao listar jogadores');
  }

  static Future<void> criarJogador(JogadorModel jogador) async {
    final res = await http.post(
      Uri.parse('$baseUrl/jogadores'),
      headers: _headers,
      body: jsonEncode(jogador.toJson()),
    );
    if (res.statusCode != 201) throw Exception('Erro ao criar jogador');
  }

  static Future<void> atualizarJogador(int id, JogadorModel jogador) async {
    final res = await http.put(
      Uri.parse('$baseUrl/jogadores/$id'),
      headers: _headers,
      body: jsonEncode(jogador.toJson()),
    );
    if (res.statusCode != 200) throw Exception('Erro ao atualizar jogador');
  }

  static Future<void> deletarJogador(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/jogadores/$id'));
    if (res.statusCode != 200) throw Exception('Erro ao deletar jogador');
  }

  // ─── PARTIDAS ─────────────────────────────────────────────────────────────

  static Future<List<PartidaModel>> listarPartidas() async {
    final res = await http.get(Uri.parse('$baseUrl/partidas'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => PartidaModel.fromJson(e)).toList();
    }
    throw Exception('Erro ao listar partidas');
  }

  static Future<void> criarPartida(PartidaModel partida) async {
    final res = await http.post(
      Uri.parse('$baseUrl/partidas'),
      headers: _headers,
      body: jsonEncode(partida.toJson()),
    );
    if (res.statusCode != 201) throw Exception('Erro ao criar partida');
  }

  static Future<void> atualizarPartida(int id, PartidaModel partida) async {
    final res = await http.put(
      Uri.parse('$baseUrl/partidas/$id'),
      headers: _headers,
      body: jsonEncode(partida.toJson()),
    );
    if (res.statusCode != 200) throw Exception('Erro ao atualizar partida');
  }

  static Future<void> deletarPartida(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/partidas/$id'));
    if (res.statusCode != 200) throw Exception('Erro ao deletar partida');
  }
}
