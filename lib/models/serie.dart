import 'package:equatable/equatable.dart';
import 'package:marvel/models/thumbnail.dart';

class Serie extends Equatable {
  final int id;
  final String title;
  final String description;
  final Thumbnail thumbnail;

  const Serie({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
  });

  String get imageUrl => thumbnail.imageUrl;

  factory Serie.fromJson(Map<String, dynamic> map) => Serie(
        id: map['id'],
        title: map["title"],
        description: map["description"] ?? '',
        thumbnail: Thumbnail.fromJson(
          map["thumbnail"],
        ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "thumbnail": thumbnail.toJson(),
      };

  static List<Serie> fromJsonList(List<dynamic> characters) {
    return List<Serie>.from(
        characters.map((character) => Serie.fromJson(character)));
  }

  static List<Map<String, dynamic>> toJsonList(List<Serie> series) {
    return series.map((s) => s.toJson()).toList();
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        thumbnail,
      ];
}
