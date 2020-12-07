import 'dart:convert';

class claseServicio {
  int Codigo;
  String Cliente;
  String NroOrden;
  String Fecha;
  String Linea;
  String Estado;
  String Observaciones;
  bool Eliminado;
  int CodigoError;
  String DescripcionError;
  String MensajeError;

  void inicializar() {
    this.Codigo = 0;
    this.Cliente = "";
    this.NroOrden = "";
    this.Fecha = "";
    this.Linea = "";
    this.Estado = "";
    this.Observaciones = "";
    this.Eliminado = false;
    this.CodigoError = 0;
    this.DescripcionError = "";
    this.MensajeError = "";
  }

  claseServicio(
      {this.Codigo,
      this.Cliente,
      this.NroOrden,
      this.Fecha,
      this.Linea,
      this.Estado,
      this.Observaciones,
      this.Eliminado,
      this.CodigoError,
      this.DescripcionError,
      this.MensajeError});

  factory claseServicio.fromJson(Map<String, dynamic> json) {
    return claseServicio(
        Codigo: json["CodigoServicio"],
        Cliente: json["NombreCliente"],
        NroOrden: json["NumeroOrdenServicio"],
        Fecha: json["FechaProgramada"],
        Linea: json["Linea"],
        Estado: json["Estado"],
        Observaciones: json["Observaciones"],
        Eliminado: json["Eliminado"],
        CodigoError: json["CodigoError"],
        DescripcionError: json["DescripcionError"],
        MensajeError: json["MensajeError"]);
  }
}
