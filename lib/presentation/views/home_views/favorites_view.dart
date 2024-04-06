import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/presentation/providers/providers.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  FavoritesViewState createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView> {
  bool isLastPage = false;
  bool isLoading = false;

  void loadNextPage() async{
    if (isLoading || isLastPage) return;
    isLoading = true;
      
    final movies = await ref.read(favoriteMoviesProvider.notifier).loadNextPage();
    isLoading = false;

    if (movies.isEmpty) {
      isLastPage = true;
    }
  }

  @override
  void initState() {
    super.initState();

    loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    //loadNextPage();
    final favoriteMovies = ref.watch(favoriteMoviesProvider).values.toList();
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;

    if (favoriteMovies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border_sharp, size: 50, color: colors.primary,),
            Text("Oh no D:", style: TextStyle(fontSize: textStyle.titleLarge!.fontSize, color: colors.primary)
            ),
            Text("Aún no tienes películas en favoritos", 
              style: TextStyle(fontSize: textStyle.titleMedium!.fontSize, color: Colors.black54)
            )
          ],
        ),
      );
    }

    return Scaffold(
      body: MovieMasonry(movies: favoriteMovies, loadNextPage: loadNextPage,)
    );
  }
}