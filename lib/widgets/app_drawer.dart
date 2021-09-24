import 'package:flutter/material.dart';
import 'package:mandman/screens/profile_screen.dart';
import 'package:mandman/screens/warehouse_screen.dart';
import 'package:provider/provider.dart';

import '../screens/orders_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/user_products_screen.dart';
import '../providers/auth.dart';


class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child:
      // Column(


          SingleChildScrollView(

            child: Column(
              children: [
                //   children: [
                    AppBar(
                      title: Text("Menu"),
                      automaticallyImplyLeading: false,
                    ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text("My Profile"),
                  onTap: () =>
                      Navigator.of(context).pushReplacementNamed(
                          ProfileScreen.routeName),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.chat),
                  title: Text("Pharma Chat"),
                  onTap: () =>
                      Navigator.of(context).pushReplacementNamed(
                          ChatScreen.routeName),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.house_siding_rounded),
                  title: Text("Warehouse"),
                  onTap: () =>
                      Navigator.of(context).pushReplacementNamed(
                          WareHouse.routeName),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.shop),
                  title: Text("Shop"),
                  onTap: () => Navigator.of(context).pushReplacementNamed('/'),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.payment),
                  title: Text("Orders"),
                  onTap: () =>
                      Navigator.of(context)
                          .pushReplacementNamed(OrderScreen.routeName),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.production_quantity_limits_sharp),
                  title: Text("Manage Products"),
                  onTap: () =>
                      Navigator.of(context)
                          .pushReplacementNamed(UserProductScreen.routeName),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text("Log out"),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed('/');
                    Provider.of<Auth>(context, listen: false).logout();
                  },
                ),

              ],
            ),

          ),


      //   ],
      // ),
    );
  }
}