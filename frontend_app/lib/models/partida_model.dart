// lib/models/partida_model.dart
class PartidaModel {
  final int? id;
  final String data;
  final int timeCasaId;
  final int timeVisitanteId;
  final int placarCasa;
  final int placarVisitante;
  // campos extras vindos do join (opcionais)
  final String? nomeTimeCasa;
  final String? nomeTimeVisitante;

  PartidaModel({
    this.id,
    required this.data,
    required this.timeCasaId,
    required this.timeVisitanteId,
    required this.placarCasa,
    required this.placarVisitante,
    this.nomeTimeCasa,
    this.nomeTimeVisitante,
  });

  factory PartidaModel.fromJson(Map<String, dynamic> json) {
    return PartidaModel(
      id: json['id'],
      data: json['data'],
      timeCasaId: json['time_casa_id'] ?? 0,
      timeVisitanteId: json['time_visitante_id'] ?? 0,
      placarCasa: json['placar_casa'],
      placarVisitante: json['placar_visitante'],
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data,
        'time_casa_id': timeCasaId,
        'time_visitante_id': timeVisitanteId,
        'placar_casa': placarCasa,
        'placar_visitante': placarVisitante,
      };
}
