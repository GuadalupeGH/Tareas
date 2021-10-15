import 'package:flutter/material.dart';
import 'package:tareas/view/formulario_tarea.dart';
import 'package:tareas/view/lista_tareas.dart';
import 'package:tareas/view/tarea_terminada.dart';

class Home extends StatefulWidget {
  int index;
  Home(this.index);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int indexPage = 0;
  completadas() {
    setState(() {
      this.indexPage = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //creacion de la parte inferior
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(0),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromRGBO(235, 250, 244, 1.0),
              Colors.white,
            ])),
          ),
          Center(
            child: _vistaSelect(),
          )
        ],
      ),

      bottomNavigationBar: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            padding: EdgeInsets.only(left: 0, top: 10, bottom: 0),
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(21, 203, 123, 1),
                      Color.fromRGBO(7, 182, 176, 1),
                    ],
                    begin: FractionalOffset(0, 0),
                    end: FractionalOffset(1, 0),
                    tileMode: TileMode.clamp),
                borderRadius: BorderRadius.circular(20)),
            child: BottomNavigationBar(
              onTap: (value) {
                cambiarPagina(value);
              },
              currentIndex: this.indexPage,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.book,
                      size: 35,
                    ),
                    label: ''),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.check,
                      size: 35,
                    ),
                    label: '')
              ],
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedFontSize: 14,
              unselectedFontSize: 13,
              unselectedItemColor: Colors.white60,
              selectedItemColor: Color.fromRGBO(255, 255, 255, 1),
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 5),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/home');
                  Navigator.pushNamed(context, '/formulario');
                },
                child: Icon(
                  Icons.add,
                  color: Color.fromRGBO(28, 205, 124, 1),
                  size: 40,
                ),
                style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(10),
                    primary: Color.fromRGBO(255, 255, 255, 0.6509803921568628),
                    elevation: 10),
              ))
        ],
      ),
    );
  }

  _vistaSelect() {
    if (this.indexPage == 0) {
      return ListaTareas(this.completadas);
    } else if (this.indexPage == 1) {
      return TareaTermianda();
    } else if (this.indexPage == 2) {
      return FormularioTarea();
    }
  }

  void cambiarPagina(int value) {
    setState(() {
      this.indexPage = value;
    });
  }
}
