import '../dominio/receta.dart';

Dificultad dificultadDesdeTexto(Object? valor) {
  return switch (valor) {
    'Easy' => Dificultad.facil,
    'Medium' => Dificultad.media,
    'Hard' => Dificultad.dificil,
    _ => Dificultad.desconocida,
  };
}

List<String> _parsearListaTextoOpcional(Object? jsonValue, String campo) {
  if (jsonValue == null) {
    return const [];
  }
  if (jsonValue is! List) {
    throw FormatException('El campo "$campo" debe ser una lista.');
  }
  final resultado = <String>[];
  for (final elemento in jsonValue) {
    if (elemento is! String) {
      throw FormatException('Un elemento de "$campo" no es texto.');
    }
    resultado.add(elemento);
  }
  return resultado;
}

Receta recetaDesdeJson(Map<String, dynamic> json) {
  final id = json['id'];
  if (id is! int) {
    throw const FormatException('El campo "id" es obligatorio y debe ser int.');
  }

  final nombre = json['name'];
  if (nombre is! String) {
    throw const FormatException('El campo "name" es obligatorio y debe ser String.');
  }

  final cocina = json['cuisine'];
  if (cocina is! String) {
    throw const FormatException('El campo "cuisine" es obligatorio y debe ser String.');
  }

  final prepTime = json['prepTimeMinutes'];
  if (prepTime is! int) {
    throw const FormatException('El campo "prepTimeMinutes" es obligatorio y debe ser int.');
  }

  final cookTime = json['cookTimeMinutes'];
  if (cookTime is! int) {
    throw const FormatException('El campo "cookTimeMinutes" es obligatorio y debe ser int.');
  }

  final porciones = json['servings'];
  if (porciones is! int) {
    throw const FormatException('El campo "servings" es obligatorio y debe ser int.');
  }

  final rating = json['rating'];
  if (rating is! num) {
    throw const FormatException('El campo "rating" es obligatorio y debe ser num.');
  }

  return Receta(
    id: id,
    nombre: nombre,
    cocina: cocina,
    dificultad: dificultadDesdeTexto(json['difficulty']),
    minutosPreparacion: prepTime,
    minutosCoccion: cookTime,
    porciones: porciones,
    calificacion: rating.toDouble(), // Asegura conversión a double[cite: 12, 19]
    etiquetas: _parsearListaTextoOpcional(json['tags'], 'tags'),
    ingredientes: _parsearListaTextoOpcional(json['ingredients'], 'ingredients'),
  );
}

PaginaRecetas paginaDesdeJson(Map<String, dynamic> json) {
  final total = json['total'];
  if (total is! int) {
    throw const FormatException('El campo "total" es obligatorio y debe ser int.');
  }

  final recipesRaw = json['recipes'];
  if (recipesRaw is! List) {
    throw const FormatException('El campo "recipes" es obligatorio y debe ser una lista.');
  }

  final recetas = <Receta>[];
  for (final elemento in recipesRaw) {
    if (elemento is! Map) {
      throw const FormatException('Cada elemento de "recipes" debe ser un objeto Map.');
    }
    recetas.add(recetaDesdeJson(Map<String, dynamic>.from(elemento)));
  }

  return PaginaRecetas(
    recetas: recetas,
    total: total,
  );
}

