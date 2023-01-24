import 'dart:typed_data';

import 'package:admin_dashboard/global/environment.dart';
import 'package:dio/dio.dart';
import 'package:admin_dashboard/services/local_storage.dart';

class CurriculApi {
  static Dio _dio = new Dio(); // instanciando Dio

  /// Metodo para configurar Dio, que se llamara en dos lugares
  static void configuraDio() {
    // base URL
    // _dio.options.baseUrl = 'http://localhost:8080/api'; // en modo desarrollo
    // _dio.options.contentType = Headers.formUrlEncodedContentType;
    // modo produccion
    // _dio.options.baseUrl = 'https://flutter-web-admin-curso.herokuapp.com/api';
    _dio.options.baseUrl = Environment.baseUrl;
    /**
     * para enviar en los headers el toquen lo buscamos 
     * en el LocalStorage en caso que no lo encuentre 
     * pasamos un String vacio 
     */
    _dio.options.headers = {'x-token': LocalStorage.prefs.getString('token') ?? ''};
  }

  static Future httpGet(String path) async {
    try {
      // realizando la peticion Http
      final resp = await _dio.get(path); // retorna un json object
      return resp.data;
    } on DioError catch (e) {
      print(e.response);
      throw ('Error en el GET');
    }
  }

  static Future post(String path, Map<String, dynamic> data) async {
    // var formData = FormData.fromMap(data);
    try {
      // realizando la peticion Http
      final resp = await _dio.post(path, data: data); // retorna un json object
      // print('REPUEST ${resp.data}');
      return resp.data;
    } on DioError catch (e) {
      print(e.response);
      throw ('Error en el POST');
    }
  }

  static Future put(String path, Map<String, dynamic> data) async {
    // final formData = FormData.fromMap(data);
    try {
      // realizando la peticion Http
      final resp = await _dio.put(path, data: data); // retorna un json object
      return resp.data;
    } on DioError catch (e) {
      print(e.response);
      throw ('Error en el PUT $e');
    }
  }

  static Future delete(String path) async {
    try {
      // realizando la peticion Http
      final resp = await _dio.delete(path); // retorna un json object
      return resp.data;
    } on DioError catch (e) {
      print(e.response);
      throw ('Error en el delete');
    }
  }

  static Future uploadFile(String path, Uint8List bytes) async {
    final formData = FormData.fromMap({'archivo': MultipartFile.fromBytes(bytes)});
    try {
      // realizando la peticion Http
      final resp = await _dio.put(path, data: formData); // retorna un json object
      return resp.data;
    } on DioError catch (e) {
      print(e.response);
      throw ('Error en el PUT $e');
    }
  }
}
