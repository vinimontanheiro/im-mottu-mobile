import 'package:equatable/equatable.dart';
import 'package:marvel/models/thumbnail.dart';

class Character extends Equatable {
  final int id;
  final String name;
  final String description;
  final Thumbnail thumbnail;

  const Character({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnail,
  });

  String get imageUrl => thumbnail.imageUrl;

  factory Character.fromJson(Map<String, dynamic> map) => Character(
        id: map['id'],
        name: map["name"],
        description: map["description"] ?? '',
        thumbnail: Thumbnail.fromJson(
          map["thumbnail"],
        ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "thumbnail": thumbnail.toJson(),
      };

  static List<Character> fromJsonList(List<dynamic> characters) {
    return List<Character>.from(
        characters.map((character) => Character.fromJson(character)));
  }

  static List<Map<String, dynamic>> toJsonList(List<Character> characters) {
    return characters.map((c) => c.toJson()).toList();
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        thumbnail,
      ];
}
