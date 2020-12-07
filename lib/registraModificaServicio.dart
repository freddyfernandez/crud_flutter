import 'dart:convert';
import 'package:crud_cliente_rest/claseServicio.dart';
import 'package:flutter/material.dart';
import 'package:json_table/json_table.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart' show Future;

class registraModificaServicio extends StatefulWidget {
  //DECLARACION DE VARIABLES DE SERVICiO
  String titulo;
  claseServicio oServicio = claseServicio();
  int codigoServicio = 0;
  String urlPrincipal = 'http://movilesii202022.somee.com/';
  String urlController = "/Servicios/";
  String urlListadokey = "/Listar?CodigoServicio=";
  String urlRegistraModifica = "/RegistraModifica?";

  String mensaje = "";
  bool validacion = false;

  registraModificaServicio(this.titulo, this.codigoServicio);

  @override
  State<StatefulWidget> createState() => _registraModificaServicio();
}

class _registraModificaServicio extends State<registraModificaServicio> {
  final _tfNombreCliente = TextEditingController();
  final _tfNroOrden = TextEditingController();
  final _tfFecha = TextEditingController();
  final _tfEstado = TextEditingController();
  final _tfLinea = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.oServicio.inicializar();
    if (widget.codigoServicio > 0) {
      _listarxCodigo();
    }
  }

  Future<String> _listarxCodigo() async {
    String urlListaServicios = widget.urlPrincipal +
        widget.urlController +
        widget.urlListadokey +
        widget.codigoServicio.toString();

    var respuesta = await http.get(urlListaServicios);

    setState(() {
      widget.oServicio = claseServicio.fromJson(json.decode(respuesta.body));

      if (widget.oServicio.Codigo > 0) {
        widget.mensaje = "Estas Actualizando los datos";
        _mostrarDatos();
      }

      print(widget.oServicio);
    });

    return "Procesado";
  }

  void _mostrarDatos() {
    _tfNombreCliente.text = widget.oServicio.Cliente;
    _tfEstado.text = widget.oServicio.Estado;
    _tfFecha.text = widget.oServicio.Fecha;
    _tfLinea.text = widget.oServicio.Linea;
    _tfNroOrden.text = widget.oServicio.NroOrden;
  }

  void _grabarRegistro() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Registro de servicios" + widget.titulo),
        ),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "Codigo de cliente" + widget.oServicio.Codigo.toString(),
                style: TextStyle(fontSize: 12),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Column(
                children: <Widget>[
                  TextField(
                      controller: _tfNombreCliente,
                      decoration: InputDecoration(
                        hintText: "Ingrese el nombre del cliente ",
                        labelText: "Nombre Cliente",
                        errorText: _tfNombreCliente.text.toString() == ""
                            ? "falta ingresar el nombre del cliente "
                            : null,
                      )),
                  TextField(
                      controller: _tfNroOrden,
                      decoration: InputDecoration(
                        hintText: "Ingrese el numero de orden ",
                        labelText: "Numero de Orden",
                      )),
                  TextField(
                      controller: _tfFecha,
                      decoration: InputDecoration(
                        hintText: "Ingrese la fecha de la orden ",
                        labelText: "Fecha",
                      )),
                  TextField(
                      controller: _tfLinea,
                      decoration: InputDecoration(
                        hintText: "Ingrese la linea ",
                        labelText: "Linea",
                      )),
                  TextField(
                      controller: _tfEstado,
                      decoration: InputDecoration(
                        hintText: "Ingrese el estado ",
                        labelText: "Estado",
                      )),
                  RaisedButton(
                    color: Colors.greenAccent,
                    child: Text(
                      "Grabar",
                      style: TextStyle(fontSize: 18, fontFamily: "rbold"),
                    ),
                    onPressed: _grabarRegistro,
                  ),
                  Text("Mensaje:" + widget.mensaje),
                ],
              ),
            )
          ],
        ));
  }
}
