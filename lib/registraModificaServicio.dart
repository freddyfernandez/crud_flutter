import 'dart:convert';
import 'package:crud_cliente_rest/claseServicio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async' show Future;

// ignore: must_be_immutable
class RegistraModificaServicio extends StatefulWidget {
  //DECLARACION DE VARIABLES DE SERVICiO
  String titulo;
  ClaseServicio oServicio = ClaseServicio();
  int codigoServicioSeleccionado = 0;
  String urlPrincipal = 'http://movilesii202022.somee.com/';
  String urlController = "/Servicios";

  //URL DE TIPO JSON OBJETO  "{}"
  String urlListadokey = "/Listarkey?pCodigoServicio=";
  String urlRegistraModifica = "/RegistraModifica?";

  String mensaje = "";
  bool validacion = false;

  RegistraModificaServicio(this.titulo, this.codigoServicioSeleccionado);

  @override
  _RegistraModificaServicio createState() => _RegistraModificaServicio();
}

class _RegistraModificaServicio extends State<RegistraModificaServicio> {
  final _tfNombreCliente = TextEditingController();
  final _tfNroOrden = TextEditingController();
  final _tfFecha = TextEditingController();
  final _tfEstado = TextEditingController();
  final _tfLinea = TextEditingController();
  final _tfObservaciones = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.oServicio.inicializar();
    if (widget.codigoServicioSeleccionado > 0) {
      _listarxCodigo();
    }
  }

  Future<String> _listarxCodigo() async {
    String urlDatosServicios = "";

    urlDatosServicios = widget.urlPrincipal +
        widget.urlController +
        widget.urlListadokey +
        widget.codigoServicioSeleccionado.toString();

    print(urlDatosServicios);

    var respuesta = await http.get(urlDatosServicios);
    print(respuesta.body);

    setState(() {
      widget.oServicio = ClaseServicio.fromJson(json.decode(respuesta.body));

      if (widget.oServicio.CodigoServicio > 0) {
        widget.mensaje = "Estas Actualizando los datos";
        _mostrarDatos();
      }

      print(widget.oServicio);
    });

    return "Procesado";
  }

  void _mostrarDatos() {
    _tfNombreCliente.text = widget.oServicio.NombreCliente;
    _tfNroOrden.text = widget.oServicio.NumeroOrdenServicio;
    _tfFecha.text = widget.oServicio.FechaProgramada;
    _tfLinea.text = widget.oServicio.Linea;
    _tfEstado.text = widget.oServicio.Estado;
    _tfObservaciones.text = widget.oServicio.Observaciones;
  }

  bool _validarRegistro() {
    if (_tfNombreCliente.text.toString() == "" ||
        _tfNroOrden.text.toString() == "") {
      widget.validacion = false;
      setState(() {
        widget.mensaje = "Falta completar los campos  nombre y nro orden";
      });
      return false;
    }
    return true;
  }

  void _GrabarRegistro() {
    //si el metodo es valido realiza la accion
    if (_validarRegistro()) {
      _ejecutarServicioGrabado();
    }
  }

  Future<String> _ejecutarServicioGrabado() async {
    String accion = "N";
    if (widget.oServicio.CodigoServicio > 0) {
      accion = "A";
    }

    String strParametros = "";
    strParametros += "Accion=" + accion;
    strParametros +=
        "&CodigoServicio=" + widget.oServicio.CodigoServicio.toString();
    strParametros += "&NombreCliente=" + _tfNombreCliente.text;
    strParametros += "&NumeroOrdenServicio=" + _tfNroOrden.text;
    strParametros += "&FechaProgramada" + _tfFecha.text;
    strParametros += "&Linea=" + _tfLinea.text;
    strParametros += "&Estado=" + _tfEstado.text;
    strParametros += "&Observaciones=" + _tfObservaciones.text;

    //CONTRUCCION DE LA URL  REGISTROS Y ACTUALIZACIONES
    String urlRegistroServicios = "";

    urlRegistroServicios = widget.urlPrincipal +
        widget.urlController +
        widget.urlRegistraModifica +
        strParametros;

    var respuesta = await http.get(urlRegistroServicios);
    var data = respuesta.body;

    setState(() {
      widget.oServicio = ClaseServicio.fromJson(json.decode(data));

      if (widget.oServicio.CodigoServicio > 0) {
        widget.mensaje = "Se Registro Correctamente";
        _mostrarDatos();
      }

      print(widget.oServicio);
    });
  }

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
                "Codigo de servicio" +
                    widget.oServicio.CodigoServicio.toString(),
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
                  TextField(
                      controller: _tfObservaciones,
                      decoration: InputDecoration(
                        hintText: "Ingrese la observacion ",
                        labelText: "Estado",
                      )),
                  RaisedButton(
                    color: Colors.greenAccent,
                    child: Text(
                      "Grabar",
                      style: TextStyle(fontSize: 18, fontFamily: "rbold"),
                    ),
                    onPressed: _GrabarRegistro,
                  ),
                  Text("Mensaje:" + widget.mensaje),
                ],
              ),
            )
          ],
        ));
  }
}
