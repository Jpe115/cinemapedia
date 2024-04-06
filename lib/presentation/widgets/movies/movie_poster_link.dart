import 'package:flutter/material.dart';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:go_router/go_router.dart';

class MoviePosterLink extends StatelessWidget {

  final Movie movie;
  
  const MoviePosterLink({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push("/movie/${movie.id}"),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.network(movie.posterPath),
      ),
    );
  }
}