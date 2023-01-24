import 'package:flutter/material.dart';
import 'package:admin_dashboard/api/cafe_api.dart';
import 'package:admin_dashboard/models/categoria.dart';
import 'package:admin_dashboard/models/http/categories_response.dart';

class CategoriesProvider extends ChangeNotifier {
  List<Categoria> categories = [];

  getCategories() async {
    // peticion al api
    final resp = await CurriculApi.httpGet('/categorias');
    final categoriesRes = CategoriesResponse.fromMap(resp);
    this.categories = [...categoriesRes.categorias];
    notifyListeners();
  }

  Future newCategory(String name) async {
    // payload
    final data = {
      'nombre': name,
    };
    try {
      final json = await CurriculApi.post('/categorias', data);
      final newCategori = Categoria.fromMap(json);

      this.categories.add(newCategori);
      notifyListeners();
    } catch (e) {
      // print(e);
      throw 'Error al crear categoría';
    }
  }

  Future updateCategory(String id, String name) async {
    final data = {'nombre': name};
    try {
      await CurriculApi.put('/categorias/$id', data);
      this.categories = this.categories.map((categ) {
        if (categ.id != id) return categ;
        categ.nombre = name;
        return categ;
      }).toList();
      notifyListeners();
    } catch (e) {
      // print(e);
      throw 'Error al actualizar categoría';
    }
  }

  Future deleteCategoria(String id) async {
    try {
      await CurriculApi.delete('/categorias/$id');
      this.categories.removeWhere((element) => element.id == id);
      notifyListeners();
    } catch (e) {
      // print(e);
      print('Error al actualizar categoría');
    }
  }
}
