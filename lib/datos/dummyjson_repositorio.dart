import 'package:dio/dio.dart';
import '../dominio/falla_red.dart';
import '../dominio/receta.dart';
import 'recetas_json.dart';
import 'recetas_repositorio.dart';
import 'traducir_error.dart';

const recetasPorPagina = 10;

class DummyJsonRepositorio implements RecetasRepositorio {
  final Dio _dio;

  DummyJsonRepositorio(this._dio);

  @override
  Future<PaginaRecetas> buscar({String texto = ''}) async {
    final textoLimpio = texto.trim();
    final String path;
    final Map<String, dynamic> queryParams;

    if (textoLimpio.isEmpty) {
      path = '/recipes';
      queryParams = {'limit': recetasPorPagina};
    } else {
      path = '/recipes/search';
      queryParams = {'q': textoLimpio, 'limit': recetasPorPagina};
    }

    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParams,
      );

      if (response.data is! Map) {
        throw const RespuestaInvalida();
      }

      final mapData = Map<String, dynamic>.from(response.data as Map);
      return paginaDesdeJson(mapData);
    } on DioException catch (e) {
      throw traducirError(e);
    } on FormatException {
      throw const RespuestaInvalida();
    } catch (e) {
      if (e is FallaRed) rethrow;
      throw const RespuestaInvalida();
    }
  }
}