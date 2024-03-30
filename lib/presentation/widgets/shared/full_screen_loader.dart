import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  Stream<String> getLoadingMessages(){

    final messages = <String>[
    "Cargando películas",
    "Comprando palomitas",
    "Cargando populares",
    "Ya casi...",
    "Se está tardando más de lo esperado :("
    ];

    return Stream.periodic(const Duration(milliseconds: 1800), (step){
      return messages[step];
    }).take(messages.length);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Espere por favor"),
          const SizedBox(height: 12),
          const CircularProgressIndicator(strokeWidth: 3,),
          const SizedBox(height: 12),

          StreamBuilder(
            stream: getLoadingMessages(), 
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Text("Cargando");

              return Text(snapshot.data!);
            },
          )
        ]
      ),
    );
  }
}