import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';

class ActorMapper{

  static Actor castToEntity(Cast cast) => 
    Actor(
      id: cast.id, 
      name: cast.name, 
      profilePath: cast.profilePath != null 
        ? "https://image.tmdb.org/t/p/w500${ cast.profilePath }" 
        : "https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-541.jpg?size=338&ext=jpg&ga=GA1.1.1930204137.1711497600&semt=ais", 
      character: cast.character
    );

}