import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MovieHorizontalListview extends StatefulWidget {

  final List<Movie> movies;
  final String? title;
  final String? subTitle;
  final VoidCallback? loadNextPage;

  const MovieHorizontalListview({
    super.key, 
    required this.movies, 
    this.title, 
    this.subTitle,
    this.loadNextPage
  });

  @override
  State<MovieHorizontalListview> createState() => _MovieHorizontalListviewState();
}

class _MovieHorizontalListviewState extends State<MovieHorizontalListview> {

  final scrollController = ScrollController();
  String scrollDirection = "idle";
  double lastScrollPosition = 0;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(_scrollListener);

    scrollController.addListener(() {
      if (widget.loadNextPage == null) return;

      if ( (scrollController.position.pixels + 200) >= scrollController.position.maxScrollExtent){
        widget.loadNextPage!();
      }
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // Determina la dirección del scroll
    if (scrollController.position.pixels > lastScrollPosition) {
      // Hacia la derecha
      scrollDirection = "Scrolling Right";

    } else if (scrollController.position.pixels < lastScrollPosition) {
      // Hacia la izquierda
      scrollDirection = "Scrolling Left";
    }

    // Actualiza la última posición conocida del scroll
    lastScrollPosition = scrollController.position.pixels;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 374,
      child: Column(
        children: [

          if (widget.title != null || widget.subTitle != null)
            _Title(title: widget.title, subTitle: widget.subTitle,),

          const SizedBox(height: 11,),

          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.movies.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                if (scrollDirection == "Scrolling Right"){
                  return FadeInRight(
                    duration: const Duration(milliseconds: 650),
                    child: _Slide(movie: widget.movies[index]),
                  );
                }
                
                return FadeInLeft(
                  duration: const Duration(milliseconds: 650),
                  child: _Slide(movie: widget.movies[index])
                );
                
              },
            )
          )
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {

  final Movie movie;

  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {

    final textStyle = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          //Imagen
          SizedBox(
            width: 155,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                movie.posterPath,
                filterQuality: FilterQuality.high,
                //fit: BoxFit.cover,
                width: 155,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 70),
                      child: Center(child: CircularProgressIndicator(strokeWidth: 3,)),
                    );
                  }

                  return GestureDetector(
                    onTap: () => context.push("/movie/${movie.id}"),
                    child: child,
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 7,),
          
          //Título
          SizedBox(
            width: 150,
            child: Text(
              movie.title,
              maxLines: 2,
              style: textStyle.titleSmall,
            ),
          ),

          //Rating
          Row(
            children: [
              Icon(Icons.star_rate_outlined, color: Colors.yellow.shade800,),
              const SizedBox(width: 3,),
              Text( HumanFormats.number(movie.voteAverage, 1), style: textStyle.bodyMedium?.copyWith(color: Colors.yellow.shade900),),
              const SizedBox(width: 10,),
              Text( HumanFormats.number(movie.popularity, 0), style: textStyle.bodySmall,)
            ],
          ),

          const SizedBox(height: 5,)

        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {

  final String? title;
  final String? subTitle;

  const _Title({
    this.title, 
    this.subTitle
  });

  @override
  Widget build(BuildContext context) {

    final titleStyle = Theme.of(context).textTheme.titleLarge;

    return Container(
      padding: const EdgeInsets.only(top: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [

          if (title != null)
            Text(title!, style: titleStyle,),
          
          const Spacer(),

          if (subTitle != null)
            FilledButton.tonal(
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
              onPressed: (){}, 
              child: Text(subTitle!)
            )
        ],
      ),
    );
  }
}