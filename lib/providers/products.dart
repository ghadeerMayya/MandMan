import 'dart:convert';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

import './product.dart';

class Products with ChangeNotifier {
  List<Product>? _items = [

  ];

  String? authToken;
  String? userId;

  getData(String? authenToken, String? uId, List<Product>? products) {
    authToken = authenToken;
    userId = uId;
    _items = products;
    notifyListeners();
  }

  List<Product> get items {
    return [..._items!];
  }

  List<Product> get favoritesItems {
    return _items!.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items!.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filteredString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';

    var url =
        'https://mandman-28915-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken&$filterByUser';
    var uri=Uri.parse(url);
    try {
      final res = await http.get(uri);
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      uri =
          Uri.parse('https://mandman-28915-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId.json?auth=$authToken');

      final favRes = await http.get(uri);
      final favData = json.decode(favRes.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            isFavorite: favData == null ? false : favData[prodId] ?? false,
            imageUrl: prodData['imageUrl'],
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://mandman-28915-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken';
    final uri=Uri.parse(url);

    try {
      final res = await http.post(uri,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId,
          }));
      final newProduct = Product(
          id: json.decode(res.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items!.add(newProduct);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items!.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://mandman-28915-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$authToken';
      final uri=Uri.parse(url);
      await http.patch(uri,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items![prodIndex] = newProduct;
      notifyListeners();
    } else {
      print("...");
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://mandman-28915-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$authToken';
    final uri=Uri.parse(url);
    final existingProductIndex = _items!.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items![existingProductIndex];
    _items!.removeAt(existingProductIndex);
    notifyListeners();

    final res = await http.delete(uri);
    if (res.statusCode >= 400) {
      _items!.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('couldn\'t delete Product');
    }
    existingProduct = null;
  }
}
