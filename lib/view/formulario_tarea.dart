import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tareas/database/database_helper_tareas.dart';
import 'package:tareas/models/tareas_model.dart';

class FormularioTarea extends StatefulWidget {
  FormularioTarea({Key? key}) : super(key: key);

  @override
  _FormularioTareaState createState() => _FormularioTareaState();
}

class _FormularioTareaState extends State<FormularioTarea> {
  late DatabaseHelperTareas _databaseHelperTareas;
  var fecha = DateTime.now().toString();
  var fechaSeleccionada = DateTime.now();
  TextEditingController _controllerTitulo = TextEditingController();
  TextEditingController _controllerDescripcion = TextEditingController();
  bool bandera1 = false;
  bool bandera2 = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.fecha = this.fechaSeleccionada.toString();
    this._databaseHelperTareas = DatabaseHelperTareas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(0),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromRGBO(235, 250, 244, 1),
              Color.fromRGBO(255, 255, 255, 1),
            ])),
          ),
          Container(
            margin: EdgeInsets.only(top: 60, left: 25, right: 25, bottom: 60),
            padding: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12, spreadRadius: 8, blurRadius: 10)
                ]),
            child: ListView(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(bottom: 20),
                  child: InkWell(
                    child: Icon(Icons.arrow_back_ios_new),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/home');
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text('Nueva tarea',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 0, right: 0),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(20, 20, 100, 0.05),
                      borderRadius: BorderRadius.circular(20)),
                  child: TextField(
                    controller: _controllerTitulo,
                    decoration: InputDecoration(
                        errorText: bandera1 ? 'Datos incorrectos' : null,
                        focusColor: Color.fromRGBO(147, 37, 255, 0),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(147, 37, 255, 0),
                                width: 0)),
                        label: Text.rich(TextSpan(children: <InlineSpan>[
                          WidgetSpan(
                            child: Text(
                              'Titulo',
                              style: TextStyle(
                                  color: Color.fromRGBO(
                                      106, 106, 106, 0.8666666666666667),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                            ),
                          ),
                        ])),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                width: 0,
                                color: Color.fromRGBO(0, 0, 0, 0.1)))),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 0, right: 0),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(20, 20, 100, .05),
                      borderRadius: BorderRadius.circular(20)),
                  child: TextField(
                    controller: _controllerDescripcion,
                    maxLines: 10,
                    decoration: InputDecoration(
                        errorText: bandera2 ? 'Datos incorrectos' : null,
                        focusColor: Color.fromRGBO(147, 37, 255, 0.2),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(20, 20, 100, .05),
                                width: 0)),
                        label: Text.rich(TextSpan(children: <InlineSpan>[
                          WidgetSpan(
                            child: Text(
                              'Descripcion',
                              style: TextStyle(
                                  color: Color.fromRGBO(
                                      106, 106, 106, 0.8666666666666667),
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ])),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                width: 0,
                                color: Color.fromRGBO(147, 37, 255, 0.2)))),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _selectDia(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 0, top: 10, right: 0),
                    height: 60,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(20, 20, 100, 0.05),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: double.infinity,
                            margin: EdgeInsets.only(left: 8, top: 8),
                            child: FaIcon(
                              FontAwesomeIcons.calendar,
                              color: Color.fromRGBO(28, 205, 124, 1.0),
                              size: 35,
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 9,
                            child: Container(
                              margin: EdgeInsets.only(left: 20),
                              height: double.infinity,
                              alignment: Alignment.centerLeft,
                              child: Text(fecha),
                            ))
                      ],
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(right: 20, top: 80),
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (_controllerTitulo.text.isEmpty ||
                              _controllerDescripcion.text.isEmpty) {
                            if (_controllerTitulo.text.isEmpty) {
                              bandera1 = true;
                            } else {
                              bandera1 = false;
                            }
                            if (_controllerDescripcion.text.isEmpty) {
                              bandera2 = true;
                            } else {
                              bandera2 = false;
                            }
                          } else {
                            guardar();
                          }
                        });
                      },
                      child: FaIcon(
                        FontAwesomeIcons.check,
                        size: 40,
                      ),
                      style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(10),
                          primary: Color.fromRGBO(28, 205, 124, 1.0)),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _selectDia(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: this.fechaSeleccionada,
        firstDate: new DateTime(2020),
        lastDate: new DateTime(2030));
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: new TimeOfDay(
          hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute),
    );
    if (picked != null) {
      if (time != null) {
        setState(() {
          this.fechaSeleccionada = picked;
          this.fechaSeleccionada = new DateTime(
              this.fechaSeleccionada.year,
              this.fechaSeleccionada.month,
              this.fechaSeleccionada.day,
              time.hour,
              time.minute);
          this.fecha = this.fechaSeleccionada.toIso8601String();
        });
      } else {
        setState(() {
          this.fechaSeleccionada = picked;
          this.fecha = this.fechaSeleccionada.toIso8601String();
        });
      }
    }
  }

  void guardar() {
    if (_controllerTitulo.text != '' && _controllerDescripcion.text != '') {
      try {
        var tarea = TareasModel(
            nomTarea: _controllerTitulo.text,
            dscTarea: _controllerDescripcion.text,
            fechaEntrega: this.fecha,
            entregada: 0);
        _databaseHelperTareas.insert(tarea.toMap()).then((result) {
          if (result > 0) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tarea creada correctamente')));
            Navigator.pop(context);
            Navigator.pushNamed(context, '/home');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('La solicitud no se completo')));
          }
        });
      } catch (Exception) {
        print(Exception);
      }
    }
  }
}
