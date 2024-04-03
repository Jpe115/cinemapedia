import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';

import '../../providers/providers.dart';

class CustomSliverAppBar extends ConsumerWidget {
  const CustomSliverAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleLarge;

    return SliverAppBar(
      floating: true,
      toolbarHeight: 55,
      title: Row(
        children: [
          Icon(Icons.movie_outlined, color: colors.primary),
          const SizedBox(width: 4,),
          Text("Cinemapedia", style: titleStyle,)
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            
            final searchQuery = ref.read(searchQueryProvider); 
            final searchedMovies = ref.read(searchedMoviesProvider);

            showSearch<Movie?>(
              query: searchQuery,
              context: context, 
              delegate: SearchMovieDelegate(
                initialMovies: searchedMovies,
                searchMovies: ref.read(searchedMoviesProvider.notifier).searchMoviesByQuery
              )
            ).then((movie) {
              if (movie == null) return;
              context.push("/movie/${movie.id}");
            });
          }, 
          icon: const Icon(Icons.search_rounded)
        )
      ],
      // flexibleSpace: FlexibleSpaceBar(
      //   title: CustomAppBar(),
      // ),
    );
  }
}