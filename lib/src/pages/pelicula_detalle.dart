import 'package:flutter/material.dart';

import 'package:scooby_app/src/models/actores_model.dart';
import 'package:scooby_app/src/models/pelicula_model.dart';

import 'package:scooby_app/src/providers/peliculas_provider.dart';

import 'package:flutter/foundation.dart';

class PeliculaDetalle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dynamic pelicula = ModalRoute.of(context).settings.arguments;
    pelicula.uniqueId = '${pelicula.id}-poster';
    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        _crearAppbar(pelicula),
        SliverList(
          delegate: SliverChildListDelegate([
            SizedBox(height: 10.0),
            _posterTitulo(context, pelicula),
            _descripcion(pelicula),
            _crearCasting(pelicula),
          ]),
        )
      ],
    ));
  }

  Widget _crearAppbar(dynamic pelicula) {
    String name;
    String path;
    if (pelicula.type == "peli") {
      name = pelicula.title;
      path = pelicula.posterPath;
    } else {
      name = pelicula.name;
      path = pelicula.profilePath;
    }
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.redAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          name,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        background: FadeInImage(
          image: NetworkImage("https://image.tmdb.org/t/p/w500" + path),
          //image: NetworkImage(pelicula.getBackgroundImg()),
          placeholder: AssetImage('assets/img/loading.gif'),
          //fadeInDuration: Duration(microseconds: 150),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitulo(BuildContext context, dynamic pelicula) {
    String name;
    String department;
    var foto;
    if (pelicula.type == "peli") {
      name = pelicula.title;
      department = pelicula.originalTitle;
      foto = pelicula.getPosterImg();
    } else {
      name = pelicula.name;
      department = pelicula.department;
      foto = pelicula.getFoto();
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage(foto),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(width: 20.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(name,
                    style: Theme.of(context).textTheme.bodyText1,
                    overflow: TextOverflow.ellipsis),
                Text(department,
                    style: Theme.of(context).textTheme.bodyText1,
                    overflow: TextOverflow.ellipsis),
                Row(
                  children: <Widget>[
                    Icon(Icons.star_border),
                    Text(pelicula.popularity.toString(),
                        style: Theme.of(context).textTheme.bodyText1)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _descripcion(dynamic pelicula) {
    String biography;
    if (pelicula.type == "peli") {
      biography = pelicula.overview;
    } else {
      biography = pelicula.biography;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(
        biography,
        textAlign: TextAlign.justify,
      ),
    );
  }
//
  Widget _crearCasting(dynamic pelicula) {
    final peliProvider = new PeliculasProvider();
    String type = pelicula.type;

    return FutureBuilder(
      future: peliProvider.getCast(pelicula.id.toString(),type),
      builder: (context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return _crearActoresPageView(snapshot.data);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearActoresPageView(List<dynamic> actores) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(viewportFraction: 0.3, initialPage: 1),
        itemCount: actores.length,
        itemBuilder: (context, i) => _actorTarjeta(context, actores[i]),
      ),
    );
  }

  Widget _actorTarjeta(BuildContext context, dynamic pelicula) {
    String name;
    String department;
    var foto;
    if (pelicula.type == "peli") {
      name = pelicula.title;
      department = pelicula.originalTitle;
      foto = pelicula.getPosterImg();
    } else {
      name = pelicula.name;
      department = pelicula.department;
      foto = pelicula.getFoto();
    }
    final tarjeta = Container(
        child: Column(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: FadeInImage(
            image: NetworkImage(foto),
            placeholder: AssetImage('assets/img/no-image.jpg'),
            height: 150.0,
            fit: BoxFit.cover,
          ),
        ),
        Text(
          name,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.caption,
        )
      ],
    ));
    return GestureDetector(
      child: tarjeta,
      onTap: () {
        Navigator.pushNamed(context, 'detalle', arguments: pelicula);
      },
    );
  }
}
