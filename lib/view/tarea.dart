import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tareas/database/database_helper_tareas.dart';
import 'package:tareas/models/tareas_model.dart';
import 'package:tareas/view/editar_tarea.dart';

class Tarea extends StatefulWidget {
  final Function refresh;

  int id;
  var titulo;
  var descripcion;
  var fecha;
  var vencida;
  var completada;
  Tarea(this.id, this.titulo, this.descripcion, this.fecha, this.vencida,
      this.completada, @required this.refresh);

  @override
  _TareaState createState() => _TareaState(this.id, this.titulo,
      this.descripcion, this.fecha, this.vencida, this.completada);
}

class _TareaState extends State<Tarea> {
  late DatabaseHelperTareas _databaseHelperTareas;
  int id;
  var titulo;
  var fecha;
  var descripcion;
  bool vencida;
  int completada;

  _TareaState(this.id, this.titulo, this.descripcion, this.fecha, this.vencida,
      this.completada);

  completar(int? estado) {
    setState(() {
      if (estado == 1) {
        this.completada = 1;
      } else {
        this.completada = 0;
      }
    });
    var tarea = TareasModel(
        idTarea: this.id,
        nomTarea: this.titulo,
        dscTarea: this.descripcion,
        fechaEntrega: this.fecha,
        entregada: estado);
    _databaseHelperTareas.update(tarea.toMap()).then((value) {
      if (value > 0) {
        widget.refresh();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('La solicitud no se completo')));
      }
    });
  }

  delete() {
    var tarea = TareasModel(
        idTarea: this.id,
        nomTarea: this.titulo,
        dscTarea: this.descripcion,
        fechaEntrega: this.fecha,
        entregada: this.completada);
    _databaseHelperTareas.delete(tarea.toMap()).then((value) {
      if (value > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tarea eliminada correctamente')));
        widget.refresh();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('La solicitud no se completo')));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _databaseHelperTareas = DatabaseHelperTareas();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.purple,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditarTarea(
                      TareasModel(
                          idTarea: this.id,
                          nomTarea: this.titulo,
                          dscTarea: this.descripcion,
                          fechaEntrega: this.fecha,
                          entregada: this.completada),
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(
          top: 10,
          left: 20,
          right: 20,
          bottom: 5,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(212, 212, 212, 0.6392156862745098),
                  blurRadius: 5,
                  spreadRadius: 3,
                  offset: Offset(0, 5))
            ],
            gradient: LinearGradient(
                colors: [
                  (this.completada == 1)
                      ? Color.fromRGBO(67, 206, 162, 1.0)
                      : ((DateTime.parse(this.fecha)
                              .difference(DateTime.now())
                              .isNegative)
                          ? (Colors.red)
                          : (Colors.white)),
                  (this.completada == 1)
                      ? Color.fromRGBO(24, 90, 157, 1.0)
                      : ((DateTime.parse(this.fecha)
                              .difference(DateTime.now())
                              .isNegative)
                          ? (Colors.redAccent)
                          : (Colors.white)),
                ],
                begin: FractionalOffset(0, 0),
                end: FractionalOffset(1, 0),
                tileMode: TileMode.clamp)),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Transform.scale(
                  scale: 1.3,
                  child: Checkbox(
                    value: (this.completada == 1),
                    onChanged: (value) {
                      if (value!) {
                        completar(1);
                      } else {
                        completar(0);
                      }
                    },
                    shape: CircleBorder(),
                    checkColor: Colors.white,
                    activeColor: Color.fromRGBO(0, 183, 255, 1.0),
                  )),
            ),
            Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 5, top: 15),
                      child: Text(
                        this.titulo,
                        style: TextStyle(
                            color: (this.completada == 1)
                                ? Colors.white
                                : ((DateTime.parse(this.fecha)
                                        .difference(DateTime.now())
                                        .isNegative)
                                    ? (Colors.white)
                                    : (Colors.black)),
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5, top: 15),
                      child: Text(
                        this.fecha,
                        style: TextStyle(
                            color: (this.completada == 1)
                                ? Colors.white
                                : ((DateTime.parse(this.fecha)
                                        .difference(DateTime.now())
                                        .isNegative)
                                    ? (Colors.white)
                                    : (Colors.black)),
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5, top: 15),
                      child: Text(
                        (this.completada == 1)
                            ? ('Completada')
                            : ((DateTime.parse(this.fecha)
                                    .difference(DateTime.now())
                                    .isNegative)
                                ? ('Vencida')
                                : ('Pendiente')),
                        style: TextStyle(
                            color: (this.completada == 1)
                                ? Colors.white
                                : ((DateTime.parse(this.fecha)
                                        .difference(DateTime.now())
                                        .isNegative)
                                    ? (Colors.white)
                                    : (Colors.black)),
                            fontWeight: FontWeight.w400,
                            fontSize: 14),
                      ),
                    )
                  ],
                )),
            Expanded(
              flex: 2,
              child: IconButton(
                icon: FaIcon(FontAwesomeIcons.trash),
                color: (this.completada == 1)
                    ? Colors.white
                    : ((DateTime.parse(this.fecha)
                            .difference(DateTime.now())
                            .isNegative)
                        ? (Colors.white)
                        : (Colors.red)),
                onPressed: () {
                  delete();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
