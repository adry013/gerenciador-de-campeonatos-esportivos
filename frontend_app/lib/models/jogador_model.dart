// lib/models/jogador_model.dart
class JogadorModel {
  final int? id;
  final String nome;
  final String posicao;
  final int timeId;

  JogadorModel({this.id, required this.nome, required this.posicao, required this.timeId});

  factory JogadorModel.fromJson(Map<String, dynamic> json) {
    return JogadorModel(
      id: json['id'],
      nome: json['nome'],
      posicao: json['posicao'],
      timeId: json['time_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'posicao': posicao,
        'time_id': timeId,
      };
}
