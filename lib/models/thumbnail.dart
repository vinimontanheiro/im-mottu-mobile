import 'package:equatable/equatable.dart';

class Thumbnail extends Equatable {
  final String path;
  final String ext;

  const Thumbnail({
    required this.path,
    required this.ext,
  });

  String get imageUrl => "$path.$ext";

  factory Thumbnail.fromJson(Map<String, dynamic> map) => Thumbnail(
        path: map['path'],
        ext: map["extension"] ?? map["ext"],
      );

  Map<String, dynamic> toJson() => {
        "path": path,
        "extension": ext,
      };

  @override
  List<Object?> get props => [path, ext];
}
