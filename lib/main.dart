import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:http_proxy/http_proxy.dart';
import 'package:mandman/providers/auth.dart';
import 'package:mandman/providers/cart.dart';
import 'package:mandman/providers/orders.dart';
import 'package:mandman/providers/products.dart';
import 'package:mandman/screens/auth_screen.dart';
import 'package:mandman/screens/cart_screen.dart';
import 'package:mandman/screens/chat_screen.dart';
import 'package:mandman/screens/edit_product_screen.dart';
import 'package:mandman/screens/edit_profile.dart';
import 'package:mandman/screens/orders_screen.dart';
import 'package:mandman/screens/product_detail_screen.dart';
import 'package:mandman/screens/profile_screen.dart';
import 'package:mandman/screens/splash_screen.dart';
import 'package:mandman/screens/user_products_screen.dart';
import 'package:mandman/screens/warehouse_screen.dart';


// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';
import 'package:intl/date_symbols.dart';
// import 'package:proxies/proxies.dart';
import './screens/product_overview_screen.dart';
//
// import 'package:http_proxy/http_proxy.dart';

// import 'package:flutter_openvpn/flutter_openvpn.dart';
// import 'package:flutter_vpn/flutter_vpn.dart';
// import 'package:proxies/proxies.dart';

import 'package:firebase_core/firebase_core.dart';

// var proxyHost;
// var proxyPort;
// const url = 'https://api.github.com/users/wslaimin'; // ????????????????????????

//
// final proxyProvider =
//     SimpleProxyProvider('173.245.75.115', 29842, 'jwilli23', 'WCTck8gg');

/* returns {"currentStatus" : "VPN_CURRENT_STATUS",
	   "expireAt" : "VPN_EXPIRE_DATE_STRING_IN_FORMAT(yyyy-MM-dd HH:mm:ss)",} if successful
 returns null if failed
*/


void main() async {


  // WidgetsFlutterBinding.ensureInitialized();
  // WidgetsFlutterBinding.ensureInitialized();
  // HttpProxy httpProxy = await HttpProxy.createHttpProxy();
  // HttpOverrides.global=httpProxy;
  await Firebase.initializeApp();

//   final proxy = await proxyProvider.getProxy();
//
// // Create an IOClient from the Proxy
//   final client = proxy.createIOClient();
//   print(proxy.toString());

  /////proxies worked to here but i think it doesnt support web

  // final myHttpRequest = client.get(await Firebase.initializeApp());//???
  // client.get(await Firebase.initializeApp());//??????????
  /* returns {"currentStatus" : "VPN_CURRENT_STATUS",
	   "expireAt" : "VPN_EXPIRE_DATE_STRING_IN_FORMAT(yyyy-MM-dd HH:mm:ss)",} if successful
 returns null if failed
*/

// print(client.get('http://scc-syria.000webhostapp.com/casestudy/casestudypanel'));
  //HTTP proxy
  // final proxy = await proxyProvider.getProxy();
  // final client = proxy.createIOClient();

  // WidgetsFlutterBinding.ensureInitialized();//???????????????????????????????????
  // HttpProxy httpProxy = await HttpProxy.createHttpProxy();
  // proxyHost = httpProxy.host;
  // proxyPort = httpProxy.port;
  //
  //
  // HttpOverrides.global=httpProxy;

  //End Http

  runApp(MyApp());

//Open VPN
//   FlutterOpenvpn.init(
//     localizedDescription: "ExampleVPN", //this is required only on iOS
//     providerBundleIdentifier: "mtcsyria.openvpn.com",//this is required only on iOS
// //localizedDescription is the name of your VPN profile
// //providerBundleIdentifier is the bundle id of your vpn extension
//   );
//
//
//   var content=await rootBundle.loadString('/vpnbook-us1-tcp443.ovpn')
//       .then((value) =>
//       FlutterOpenvpn.lunchVpn(
//         value, //content of your .ovpn file
//             (isProfileLoaded) => print('isProfileLoaded : $isProfileLoaded'),
//             (newVpnStatus) => print('vpnActivated : $newVpnStatus'),
//         expireAt: DateTime.now().add(Duration(seconds: 30)),
//         user:
//         //(Optional) VPN automatically disconnects in next 30 seconds
//       )
//   );
}

// class MyApp extends StatefulWidget {

class MyApp extends StatefulWidget {


  // static Future<void> initPlatformState() async {
  //   var content2= rootBundle.loadString('/vpnbook-us1-tcp443.ovpn');
  //   await FlutterOpenvpn.lunchVpn(
  //     content2,
  //         (isProfileLoaded) {
  //       print('isProfileLoaded : $isProfileLoaded');
  //     },
  //         (vpnActivated) {
  //       print('vpnActivated : $vpnActivated');
  //     },
  //
  //     user: 'user',
  //     pass: 'pass',
  //     onConnectionStatusChanged:
  //         (duration, lastPacketRecieve, byteIn, byteOut) => print(byteIn),
  //     expireAt: DateTime.now().add(
  //       Duration(
  //         seconds: 180,
  //       ),
  //     ),
  //   );
  // }
  @override
  _MyAppState createState() => _MyAppState();


}

class _MyAppState extends State<MyApp> {
  // var state = FlutterVpnState.disconnected;
  // CharonErrorState? charonState = CharonErrorState.NO_ERROR;

  @override
  void initState() {
    // FlutterVpn.prepare();
    // FlutterVpn.onStateChanged.listen((s) => setState(() => state = s));
    // FlutterVpn.simpleConnect(
    //   '173.245.75.115:29842',
    //   'jwilli23',
    //   'WCTck8gg',
    // );
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          // ChangeNotifierProvider.value(value: Auth()),
          // ChangeNotifierProxyProvider<Auth, Products>(
          //   create: (_) => Products(),
          //   update: (ctx, authValue, previousProducts) => previousProducts
          //     ..getData(
          //       authValue.token,
          //       authValue.userId,
          //       previousProducts == null ? null : previousProducts.items,
          //     ),
          // ),
          // ChangeNotifierProvider.value(value: Cart()),
          // ChangeNotifierProxyProvider<Auth, Orders>(
          //   create: (_) => Orders(),
          //   update: (ctx, authValue, previousOrders) => previousOrders
          //     ..getData(
          //       authValue.token,
          //       authValue.userId,
          //       previousOrders == null ? null : previousOrders.orders,
          //     ),
          // ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MyMarket',
            // themeMode: ThemeMode.dark,
            theme: ThemeData(
              primaryColor: Colors.blue.shade300,
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
            ),
            home: auth.isAuth
                ? ProductOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, AsyncSnapshot authSnapshot) =>
                        authSnapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            // home: ProfileScreen(),
            routes: {
              EditProfile.routeName:(_)=>EditProfile(),
              WareHouse.routeName:(_)=>WareHouse(),
              ProfileScreen.routeName:(_)=>ProfileScreen(),
              ProductDetailScreen.routeName: (_) => ProductDetailScreen(),
              CartScreen.routeName: (_) => CartScreen(),
              OrderScreen.routeName: (_) => OrderScreen(),
              UserProductScreen.routeName: (_) => UserProductScreen(),
              EditProductScreen.routeName: (_) => EditProductScreen(),
              ChatScreen.routeName: (_) => ChatScreen(),
            },
          ),
        ));
  }
}
