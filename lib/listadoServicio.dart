import 'dart:convert';
import 'package:crud_cliente_rest/claseServicio.dart';
import 'package:crud_cliente_rest/registraModificaServicio.dart';
import 'package:flutter/material.dart';
import 'package:json_table/json_table.dart';
import 'package:http/http.dart' as http;
import 'dart:async' show Future;

class ListadoServicio extends StatefulWidget {
  //DECLARACION DE VARIABLES DE SERVICiO
  String titulo;
  List<ClaseServicio> listaServicio = [];
  int codigoServicioSeleccionado = 0;
  String urlPrincipal = 'http://movilesii202022.somee.com/';
  String urlController = "/Servicios/";

  //URL DE TIPO JSON LISTADO OBJETO  "[{}]"
  String urlListado = "/Listar?NombreCliente=";

  String jSonClientes =
      '[{"CodigoServicio": 0,"NombreCliente": "","NumeroOrdenServicio": "","FechaProgramada": "","Linea": "","Estado": "","Observaciones": "","Eliminado": false,"CodigoError": 0,"DescripcionError": "","MensajeError": ""}]';

  ListadoServicio(this.titulo);
  @override
  _ListadoServicio createState() => _ListadoServicio();
}

class _ListadoServicio extends State<ListadoServicio> {
  //DECLARACION DE VARIABLE DE CONTROLADOR
  final _tfNombreCliente = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<String> _consultarServicios() async {
    String urlListaServicios = widget.urlPrincipal +
        widget.urlController +
        widget.urlListado +
        _tfNombreCliente.text.toString();
    var respuesta = await http.get(urlListaServicios);
    var data = respuesta.body;

    //OBTIENE LOS DATOS JSON A OBJETOS
    var oListaServiciosTmp = List<ClaseServicio>.from(
        json.decode(data).map((x) => ClaseServicio.fromJson(x)));

    setState(() {
      //ASIGNA A UNA LISTA VACIA LA LISTA DE OBJETOS
      widget.listaServicio = oListaServiciosTmp;
      //ASIGNA A UN STRING, UNA CADENA JSON TIPO STRING
      widget.jSonClientes = data;

      if (widget.listaServicio.length == 0) {
        widget.jSonClientes =
            '[{"CodigoServicio": 0,"NombreCliente": "","NumeroOrdenServicio": "","FechaProgramada": "","Linea": "","Estado": "","Observaciones": "","Eliminado": false,"CodigoError": 0,"DescripcionError": "","MensajeError": null}]';
      }
    });

    return "Procesado";
  }

  void _nuevoServicio() {
    Navigator.of(context)
        .push(new MaterialPageRoute<Null>(builder: (BuildContext pContexto) {
      return new RegistraModificaServicio(
          "", widget.codigoServicioSeleccionado);
    }));
  }

  void _VerRegistroServicio() {}

  @override
  Widget build(BuildContext context) {
    //VARIABLE QUE DECODIFICA LA CADENA TIPO STRING EN UN OBJETO JSON
    var json = jsonDecode(widget.jSonClientes);

    return Scaffold(
        appBar: AppBar(
          title: Text("Consulta de servicios"),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Para consultar completar  el nombre del cliente y dar click en consultar",
                style: TextStyle(fontSize: 12),
              ),
              TextField(
                  controller: _tfNombreCliente,
                  decoration: InputDecoration(
                    hintText: "Ingrese el nombre del cliente ",
                    labelText: "Nombre Cliente",
                  )),
              Text(
                "Se encontraron " +
                    widget.listaServicio.length.toString() +
                    " Clientes",
                style: TextStyle(fontSize: 9),
              ),
              new Table(children: [
                TableRow(children: [
                  Container(
                    padding: EdgeInsets.only(right: 10.0),
                    child: RaisedButton(
                      color: Colors.greenAccent,
                      child: Text(
                        "Consultar",
                        style: TextStyle(fontSize: 10, fontFamily: "ebold"),
                      ),
                      onPressed: _consultarServicios,
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(right: 10.0),
                      child: RaisedButton(
                        color: Colors.greenAccent,
                        child: Text(
                          "Nuevo",
                          style: TextStyle(fontSize: 10, fontFamily: "ebold"),
                        ),
                        onPressed: _nuevoServicio,
                      )),
                ])
              ]),
              JsonTable(
                json,

                //seleccionar celdas
                showColumnToggle: true,
                allowRowHighlight: true,
                rowHighlightColor: Colors.yellow[500].withOpacity(0.7),
                paginationRowCount: 10,
                onRowSelect: (index, map) {
                  widget.codigoServicioSeleccionado =
                      int.parse(map["CodigoServicio"].toString());
                  print("demo" + map["CodigoServicio"].toString());

                  Navigator.of(context).push(new MaterialPageRoute<Null>(
                      builder: (BuildContext pContexto) {
                    return new RegistraModificaServicio(
                        "", widget.codigoServicioSeleccionado);
                  }));
                  print(widget.codigoServicioSeleccionado);
                },
              )
            ],
          ),
        ));
  }
}
