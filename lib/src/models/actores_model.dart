import 'package:scooby_app/src/providers/peliculas_provider.dart';

class Cast {
  final provider = new PeliculasProvider();

  List<Actor> actores = [];

  Cast.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    jsonList.forEach((item) {
      final actor = Actor.fromJsonMap(item);
      provider.getDesc(actor.id).then((value) {
        if (value != '') {
          actor.biography = value;
        } else {
          actor.biography = "No hay descripción para este actor.";
        }
      });
      actores.add(actor);
    });
  }
}

class Actor {
  String uniqueId;
  String type = "actor";
  int castId;
  String character;
  String creditId;
  int gender;
  int id;
  String name;
  int order;
  String profilePath;
  double popularity = 0.0;
  String department = "";
  String biography = "";

  Actor({
    this.castId,
    this.character,
    this.creditId,
    this.gender,
    this.id,
    this.name,
    this.order,
    this.profilePath,
    this.popularity,
    this.department,
  });

  Actor.fromJsonMap(Map<String, dynamic> json) {
    castId = json['cast_id'];
    character = json['character'];
    creditId = json['credit_id'];
    gender = json['gender'];
    id = json['id'];
    name = json['name'];
    order = json['order'];
    profilePath = json['profile_path'];
    popularity = json['popularity'];
    department = json['known_for_department'];
  }

  getFoto() {
    if (profilePath == null) {
      return 'http://forum.spaceengine.org/styles/se/theme/images/no_avatar.jpg';
    } else {
      return 'https://image.tmdb.org/t/p/w500/$profilePath';
    }
  }
}
