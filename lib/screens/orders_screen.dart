import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:mandman/widgets/app_drawer.dart';

import '../widgets/app_drawer.dart';

import '../widgets/order_item.dart';
import '../providers/orders.dart' show Orders;

class OrderScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      body: FutureBuilder(
        future:
            Provider.of<Orders>(context, listen: false).fetchAndSetOrderss(),
        builder: (_, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.error != null) {
              return Center(
                child: Text('An error occured'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (BuildContext context, int index) => OrderItem(
                    order: orderData.orders[index],
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
