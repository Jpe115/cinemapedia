import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';

final similarMoviesProvider = StateNotifierProvider<SimilarMoviesMapNotifier,Map<String,List<Movie>>>((ref)  {
  final getMovies = ref.watch(movieRepositoryProvider).getSimilarMovies;

  return SimilarMoviesMapNotifier(getMovies: getMovies);
});

typedef GetSimilarMovies = Future<List<Movie>>Function(String movieId);
class SimilarMoviesMapNotifier extends StateNotifier<Map<String,List<Movie>>> {

  final GetSimilarMovies getMovies;

  SimilarMoviesMapNotifier({required this.getMovies}) : super({});

  Future<void> loadSimilars(String movieId) async{
    if (state[movieId] != null) return;

    final similars = await getMovies(movieId);
    
    state = {...state, movieId:similars};
  }
}