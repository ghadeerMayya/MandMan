import 'package:flutter/material.dart';
import 'package:mandman/providers/cart.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';

class OrderItem {
  final String id;
  final DateTime dateTime;
  final List<CartItem> products;
  final double amount;

  OrderItem({
    required this.id,
    required this.dateTime,
    required this.products,
    required this.amount,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  String? authToken;
  String? userId;

  getData(String? auth_Token, String? uId, List<OrderItem>? orders) {
    authToken = auth_Token;
    userId = uId;
    _orders = orders!;
    notifyListeners();
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrderss() async {
    final url =
        'https://mandman-28915-default-rtdb.europe-west1.firebasedatabase.app/orders/$userId.json?auth=$authToken';
    final uri=Uri.parse(url);
    try {
      final res = await http.get(uri);
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }

      final List<OrderItem> loadedOrders = [];
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(
          OrderItem(
            id: orderId,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
            products: (orderData['products'] as List<dynamic>)
                .map((item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price']))
                .toList(),
          ),
        );
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    final url =
        'https://mandman-28915-default-rtdb.europe-west1.firebasedatabase.app/orders/$userId.json?auth=$authToken';
    final uri=Uri.parse(url);
    try {
      final timestamp = DateTime.now();
      final res = await http.post(uri,
          body: json.encode({
            'amount': total,
            'dateTime': timestamp.toIso8601String(),
            'products': cartProduct
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'quantity': cp.quantity,
                      'price': cp.price,
                    })
                .toList(),
          }));
      _orders.insert(
          0,
          OrderItem(
              id: json.decode(res.body)['name'],
              dateTime: timestamp,
              products: cartProduct,
              amount: total));
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
