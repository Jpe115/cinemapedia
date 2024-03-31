import 'dart:async';

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?>{

  final SearchMoviesCallback searchMovies;
  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast();
  Timer? _debounceTimer;

  SearchMovieDelegate({
    required this.searchMovies
  });

  void clearStreams(){
    debouncedMovies.close();
  }

  void _onQueryChanged(String query){
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async{ 
      if (query.isEmpty){
        debouncedMovies.add([]);
        return;
      }

      final movies = await searchMovies(query);
      debouncedMovies.add(movies);

    });
  }

  @override
  String get searchFieldLabel => "Buscar película";

  @override
  List<Widget>? buildActions(BuildContext context) {

    return [
      
      FadeIn(
        animate: query.isNotEmpty,
        duration: const Duration(milliseconds: 150),
        child: IconButton(
          onPressed: () => query = "", 
          icon: const Icon(Icons.clear_rounded)
        ),
      )

    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {

    return IconButton(onPressed: () {
      clearStreams();
      close(context, null);
    }, 
    icon: const Icon(Icons.arrow_back_rounded));
  }

  @override
  Widget buildResults(BuildContext context) {

    return const Text("buildResults");
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    _onQueryChanged(query);

    return StreamBuilder(
      //future: searchMovies(query),
      stream: debouncedMovies.stream,
      builder: (context, snapshot) {
        
        final movies = snapshot.data ?? [];

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return _MovieItem(
              movie: movies[index], 
              onMovieSelected: (context, movie){
                clearStreams();
                close(context, movie);
              }
            );
          },
        );
      },
    );
  }

}


class _MovieItem extends StatelessWidget {

  final Movie movie;
  final Function onMovieSelected;

  const _MovieItem({
    required this.movie, 
    required this.onMovieSelected
  });

  @override
  Widget build(BuildContext context) {

    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          children: [
      
            //Imagen
            SizedBox(
              width: size.width * 0.24,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath,
                  loadingBuilder: (context, child, loadingProgress) => FadeIn(child: child),
                  ),
                ),
            ),
            const SizedBox(width: 10,),
      
            //Descripción
            SizedBox(
              width: size.width * 0.66,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: textStyles.titleMedium,),
      
                  (movie.overview.length > 100)
                    ? Text("${movie.overview.substring(0, 100)}...")
                    : Text(movie.overview),
      
                  Row(
                    children: [
                      Icon(Icons.star_rate_outlined, color: Colors.yellow.shade800,),
                      const SizedBox(width: 3,),
                      Text( HumanFormats.number(movie.voteAverage, 1), style: textStyles.bodyMedium?.copyWith(color: Colors.yellow.shade900),)
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}