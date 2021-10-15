import 'package:flutter/material.dart';
import 'package:tareas/database/database_helper_tareas.dart';
import 'package:tareas/models/tareas_model.dart';
import 'package:tareas/view/tarea.dart';

class TareaTermianda extends StatefulWidget {
  TareaTermianda({Key? key}) : super(key: key);

  @override
  _TareaTermiandaState createState() => _TareaTermiandaState();
}

class _TareaTermiandaState extends State<TareaTermianda> {
  late DatabaseHelperTareas _databaseHelperTareas;

  refresh() async {
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _databaseHelperTareas = DatabaseHelperTareas();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _databaseHelperTareas.getTareasTerminadas(),
      builder:
          (BuildContext context, AsyncSnapshot<List<TareasModel>> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Ocurrio un error en la peticion'),
          );
        } else {
          if (snapshot.connectionState == ConnectionState.done) {
            return _listadoTareas(snapshot.data!);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      },
    );
  }

  Widget _listadoTareas(List<TareasModel> tareas) {
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(Duration(seconds: 2), () {
          setState(() {});
        });
      },
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: 160,
            width: double.infinity,
            padding: EdgeInsets.only(
              left: 30,
              top: 60,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromRGBO(67, 206, 162, 1.0),
                Color.fromRGBO(24, 90, 157, 1.0),
              ]),
            ),
            child: Text(
              'Tareas Terminadas',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 130),
            padding: EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(235, 250, 244, 1.0),
                  Color.fromRGBO(255, 255, 255, 1)
                ]),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black38, blurRadius: 20, spreadRadius: 1)
                ]),
            child: ListView.builder(
              itemCount: tareas.length,
              itemBuilder: (context, index) {
                var tarea = tareas.elementAt(index);
                var titulo = tarea.nomTarea;
                var tarjeta = Tarea(
                    tarea.idTarea!,
                    tarea.nomTarea,
                    tarea.dscTarea,
                    tarea.fechaEntrega,
                    (DateTime.now().isAfter(DateTime.parse(tarea.fechaEntrega!))
                        ? true
                        : false),
                    tarea.entregada,
                    refresh);

                return tarjeta;
              },
            ),
          ),
        ],
      ),
    );
  }
}
