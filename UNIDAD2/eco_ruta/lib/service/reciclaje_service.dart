class ReciclajeService {
  String contenedorPara(String tiposResiduos) {
    switch (tiposResiduos) {
      case 'Papel':
        return 'Contenedor de Papel';
      case 'Orgánico':
        return 'Contenedor de Orgánicos';
      case 'Plástico':
        return 'Contenedor de Plástico';
      case 'Vidrio':
        return 'Contenedor de Vidrio';
      case 'Metal':
        return 'Contenedor de Metales';
      default:
        return 'Contenedor General';

    }
  }
}