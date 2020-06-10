import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Pelicula> peliculas;

  const CardSwiper({@required this.peliculas});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 10),
      // width: _screenSize.width * 0.7,
      // height: _screenSize.height * 0.5,
      child: Swiper(
          layout: SwiperLayout.STACK,
          itemWidth: _screenSize.width * 0.7, // 70% del ancho de la pantalla.
          itemHeight: _screenSize.height * 0.5, // 50% del alto de la pantalla
          itemBuilder: (BuildContext context, int index) {
            // return Image.network("http://via.placeholder.com/350x150", fit: BoxFit.cover);
            peliculas[index].uniqueId = '${peliculas[index].id}-tarjeta';
            return Hero(
              tag: peliculas[index].uniqueId,
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, 'detalle', arguments: peliculas[index]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: FadeInImage(
                    image: NetworkImage(peliculas[index].getPosterImg()),
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
          itemCount: peliculas.length
          // pagination: SwiperPagination(),
          // control: SwiperControl()

          ),
    );
  }
}
