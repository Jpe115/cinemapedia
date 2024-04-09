import 'package:cinemapedia/presentation/providers/movies/similar_movies_provider.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_horizontal_listview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

class MovieScreen extends ConsumerStatefulWidget {

  static const name = "movie-screen";

  final String movieId;

  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {

  @override
  void initState() {
    super.initState();

    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsbyMovieProvider.notifier).loadActors(widget.movieId);
    ref.read(similarMoviesProvider.notifier).loadSimilars(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {

    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId]; 
    final List<Movie>? similars = ref.watch(similarMoviesProvider)[widget.movieId];

    if (movie == null || similars == null) return const Scaffold(body: Center(child: CircularProgressIndicator(strokeWidth: 2.5,),),);

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(movie: movie,),
          SliverList(delegate: SliverChildBuilderDelegate(
            (context, index) => _MovieDetails(movie: movie, similarMovies: similars),
            childCount: 1
          ))
        ],
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {

  final Movie movie;
  final List<Movie> similarMovies;

  const _MovieDetails({required this.movie, required this.similarMovies});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              //Imagen
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath,
                  width: size.width * 0.3,
                ),
              ),

              const SizedBox(width: 10),

              //Descripción
              SizedBox(
                width: (size.width - 40) * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Text(movie.title, style: textStyles.titleLarge),
                    Text("Sinópsis:", style: textStyles.titleMedium,),
                    const SizedBox(height: 1),
                    (movie.overview != "") 
                      ? Text(movie.overview, style: textStyles.bodyMedium,)
                      : const Text("No disponible")
                  ],
                ),
              ),
            
            ],
          ),
        ),

        //Géneros de la peliícula
        Padding(
          padding: const EdgeInsets.all(13),
          child: Wrap(
            children: [
              ...movie.genreIds.map((genre) => Container(
                margin: const EdgeInsets.only(right: 10, bottom: 7),
                child: Chip(
                  label: Text(genre),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                ),
              ))
            ],
          ),
        ),

        //Lista de actores
        Padding(
          padding: const EdgeInsets.only(left: 9, top: 5),
          child: Text("Cast", style: textStyles.titleLarge),
        ),
        _ActorsByMovie(movieId: movie.id.toString()),

        //Recomendaciones
        Padding(
          padding: const EdgeInsets.only(left: 9),
          child: Text("Recomendaciones", style: textStyles.titleLarge),
        ),
        MovieHorizontalListview(movies: similarMovies),

        //const SizedBox(height: 5)
      ],
    );
  }
}


class _ActorsByMovie extends ConsumerWidget {

  final String movieId;

  const _ActorsByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, ref) {

    final actorsByMovie = ref.watch(actorsbyMovieProvider);
    if (actorsByMovie[movieId] == null) return const CircularProgressIndicator(strokeWidth: 2);

    final actors = actorsByMovie[movieId]!;

    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (BuildContext context, int index) { 
          final actor = actors[index];

          return Container(
            padding: const EdgeInsets.all(8),
            width: 135,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                //Actor picture
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    actor.profilePath, 
                    height: 180,
                    width: 135,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 5),

                //Nombre
                Text(
                  actor.name, 
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
                Text(actor.character ?? "",
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: const TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),  
                )
              ],
            ),
          );
        },
      ),
    );
  }
}


final isFavoriteProvider = FutureProvider.family.autoDispose((ref, int movieId) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);

  return localStorageRepository.isMovieFavorite(movieId);
});


class _CustomSliverAppBar extends ConsumerWidget {

  final Movie movie;

  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final isFavoriteFuture = ref.watch(isFavoriteProvider(movie.id));

    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          style: IconButton.styleFrom(
            backgroundColor: const Color.fromARGB(77, 138, 137, 137),
            shape: const CircleBorder()
          ),
          onPressed: () async {

            await ref.read(favoriteMoviesProvider.notifier).toggleFavorite(movie);

            ref.invalidate(isFavoriteProvider(movie.id));

          }, 
          icon: isFavoriteFuture.when(
            error: (_, __) => throw UnimplementedError(), 
            loading: () => const CircularProgressIndicator(strokeWidth: 3),
            data: (isFavorite) => isFavorite
              ? const Icon(Icons.favorite_rounded, color: Colors.red)
              : const Icon(Icons.favorite_border_rounded)
          )
          //const Icon(Icons.favorite_border_rounded)
          //icon: const Icon(Icons.favorite_rounded, color: Colors.red,)
        )
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
        // title: Text(
        //   movie.title,
        //   style: const TextStyle(fontSize: 20),
        //   textAlign: TextAlign.start,
        // ),

        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) return const SizedBox();
                  return FadeIn(child: child);
                },
              ),
            ),

            const _CustomGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.8, 1.0],
              colors: [
                Colors.transparent,
                Colors.black54,
              ]
            ),

            const _CustomGradient(
              begin: Alignment.topLeft,
              stops: [0.0, 0.2],
              colors: [
                Colors.black45,
                Colors.transparent,
              ], 
            ),

            const _CustomGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.0, 0.2],
              colors: [
                Colors.black45,
                Colors.transparent,
              ], 
            ),

          ],
        ),
      ),
    );
  }
}

class _CustomGradient extends StatelessWidget {

  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<double> stops;
  final List<Color> colors;

  const _CustomGradient({
    required this.colors, 
    this.begin = Alignment.centerLeft, 
    this.end = Alignment.centerRight, 
    required this.stops
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: begin,
            end: end,
            stops: stops,
            colors: colors
          )
        )
      ),
    );
  }
}