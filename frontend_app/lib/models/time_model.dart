// lib/models/time_model.dart
class TimeModel {
  final int? id;
  final String nome;
  final String cidade;

  TimeModel({this.id, required this.nome, required this.cidade});

  factory TimeModel.fromJson(Map<String, dynamic> json) {
    return TimeModel(
      id: json['id'],
      nome: json['nome'],
      cidade: json['cidade'],
    );
  }

  Map<String, dynamic> toJson() => {'nome': nome, 'cidade': cidade};
}
