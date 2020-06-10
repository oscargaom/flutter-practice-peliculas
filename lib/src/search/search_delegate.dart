import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {

  String seleccion = '';

  final peliculasProvider = new PeliculasProvider();

  final peliculas = [
    'Muerte entre las flores (1990)',
    'La lista de Schindler (1993)',
    'El cielo sobre Berlín (1987)',
    'El detective cantante (1986)',
    'Adiós a mi concubina (1993)',
    'Uno de los nuestros (1990)',
    'La mirada de Ulises (1995)',
    'Drunken Master II (1994)',
    'Chunking Express (1994)',
    'Buscando a Nemo (2003)',
    'Ciudad de Dios (2002)',
    'Hable con ella (2002)',
    'Pulp Fiction (1994)',
    'Sin Perdón (1992)',
    'El decálogo (1989)',
    'Kandahar (2001)',
    'La mosca (1986)',
    'Nakayan (1987)',
    'Leolo (1992)'
  ];

  final peliculasRecientes = [
    'El discreto encanto de la burguesía (1972)',
    'El Padrino (Parte I y II) (1972, 1974)',
    'Aguirre, la cólera de Dios (1972)',
    'La Rosa púrpura del Cairo (1985)',
    'La Guerra de las Galaxias (1977)',
    'E.T. El extraterrestre (1982)',
    'Berlin Alexanderplatz (1980)',
    'La noche americana (1973)',
    'Mi tío de América (1980)',
    'A touch of Zen (1971)',
    'Barry Lyndon (1975)',
    'Blade Runner (1992)',
    'Toro salvaje (1980)',
    'Taxi Driver (1976)',
    'Chinatown (1974)',
    'Brazil (1985)'
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    //  Son las acciones de nestro AppBar.
    return [
      IconButton(
        icon: Icon(Icons.clear), 
        onPressed: (){
          this.query = '';
        })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar.
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow, 
        progress: transitionAnimation,
      ), 
      onPressed: () {
        close(context, null);
      });
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar.
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blue,
        child: Text(seleccion)
      )
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando el usuario escribe.

    if (query.isEmpty) {
      return Container();
    } 

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        
        if (snapshot.hasData) {
          final peliculas = snapshot.data;

          return ListView(
            children: peliculas.map((pelicula) {
              
              pelicula.uniqueId = '';
              
              return ListTile(
                leading: FadeInImage(
                  placeholder: AssetImage('assets/img/no-image.jpg'), 
                  image: NetworkImage(pelicula.getPosterImg()),
                  width: 50.0,
                  fit: BoxFit.contain),
                title: Text(pelicula.title),
                subtitle: Text(pelicula.originalTitle),
                onTap: (){
                  close(context, null);
                  Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                },
              );
            }).toList(),
          );


        } else {
          return Center(
            child: CircularProgressIndicator()
          );
        }
      },
    );
  }

  // @override
  // Widget buildSuggestions(BuildContext context) {
  //   // Son las sugerencias que aparecen cuando el usuario escribe.

  //   final listaSugerida = (query.isEmpty) ? peliculasRecientes : 
  //       peliculas.where((element) => element.toLowerCase().startsWith(query.toLowerCase())).toList();

  //   return ListView.builder(
  //     itemCount: listaSugerida.length,
  //     itemBuilder: (context, index) {
  //       return ListTile(
  //         leading: Icon(Icons.movie),
  //         title: Text(listaSugerida[index]),
  //         onTap: () {
  //           seleccion = listaSugerida[index];
  //           showResults(context);
  //         },
  //       );
  //     });
  // }
}