import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {

  int getIndex(BuildContext context) {
    final String path = GoRouterState.of(context).uri.path;

    switch(path) {
      case "/":
        return 0;
      case "/categories":
        return 1;
      case "/favorites":
        return 2;
      default:
        return 0;
    }
  }

  void onItemTapped(BuildContext context, int index) {

    switch(index) {
      case 0:
        context.go("/");
        break;
      
      case 1:
        context.go("/");
        break;
      
      case 2:
        context.go("/favorites");
        break;
    }

  }

  const CustomBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: getIndex(context),
      onTap: (index) => onItemTapped(context, index),
      //elevation: 0,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_max),
          label: "Inicio"
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.label_outline),
          label: "Categorías"
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outline),
          label: "Favoritos"
        )
      ],
    );
  }
}