int calculate() {
  return 6 * 7;
}

int sumar (int a,int b) {
  return a+b;
}

double restar (double a, double b){
  return a-b;
}

String saludar (String nombre){
  return ("Hola $nombre");
}

String listaDatos (List<String> frutas ){
  String datos  = "";
  for (var i in frutas){
    datos +=i;
  }
  return datos;
}