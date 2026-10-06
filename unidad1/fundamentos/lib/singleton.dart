class Configuracion {
  //1er paso constructor privado 
  Configuracion._internal();

  //2 crear instancia unica
  static Configuracion? _instance;

  //3 metodo para obtener instancia 
  static Configuracion get instance{
  _instance ??= Configuracion._internal();
  return _instance!;
  }

  //4 estado de la configuracion 
  String _idioma = 'es';
  String _tema = 'claro';
  bool _notificacion = true;

  //metodos get y set 

  String get idioma => _idioma;
  set idioma (String value) => _idioma =value;

  String get tema => _tema;
  set tema (String value) => _tema =value;

  bool get notificaciones => _notificacion;
  set notificaciones (String value) => _notificacion = value as bool;
}