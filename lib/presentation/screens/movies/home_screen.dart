import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/presentation/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {

  static const name = "home-screen";
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeView(),

      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}




class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {

  @override
  void initState() {
    super.initState();
    
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleLarge;

    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final slideShowMovies = ref.watch(moviesSlideshowProvider);

    return CustomScrollView(
      slivers: [

        SliverAppBar(
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
            IconButton(onPressed: (){}, icon: const Icon(Icons.search_rounded))
          ],
          // flexibleSpace: FlexibleSpaceBar(
          //   title: CustomAppBar(),
          // ),
        ),

        SliverList(delegate: SliverChildBuilderDelegate(
          (context, index){
            return Column(
              children: [
                //const CustomAppBar(),

                MoviesSlideshow(movies: slideShowMovies),

                MovieHorizontalListview(
                  movies: nowPlayingMovies,
                  title: "En cines",
                  subTitle: "Lunes 20",
                  loadNextPage: () {
                    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
                  },
                ),

                MovieHorizontalListview(
                  movies: nowPlayingMovies,
                  title: "Próximamente",
                  subTitle: "Este mes",
                  loadNextPage: () {
                    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
                  },
                ),

                MovieHorizontalListview(
                  movies: nowPlayingMovies,
                  title: "Populares",
                  //subTitle: "De todos los tiempos",
                  loadNextPage: () {
                    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
                  },
                ),

                MovieHorizontalListview(
                  movies: nowPlayingMovies,
                  title: "Mejor calificadas",
                  subTitle: "De todos los tiempos",
                  loadNextPage: () {
                    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
                  },
                ),

                const SizedBox(height: 10,)
              ],
            );    
          },
          childCount: 1
        ))
      ] 
    );
  }
}