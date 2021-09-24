import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mandman/models/http_exception.dart';
import 'package:mandman/providers/auth.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Colors.blue,
                Colors.white.withOpacity(0.5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0, 1],
            )),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: AuthCard(),
                    flex: deviceSize.width > 600 ? 2 : 1,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

enum AuthMode {
  SignUp,
  LogIn,
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formkey = GlobalKey();

  AuthMode _authMode = AuthMode.LogIn;

  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'fullname':'',
  };

  var _isloading = false;

  final _passwordController = TextEditingController();
  late AnimationController _controller;
  late Animatable<Offset> _slideAnimation;

  // ignore: unused_field
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    // _slideAnimation =
    // Tween(
    //   begin: Offset(0, -0.15),
    //   end: Offset(0, 0),
    // ).animate(
    //   CurvedAnimation(
    //   parent: _controller,
    //   curve: Curves.fastOutSlowIn,
    // ),
    // ) as Animatable<Offset>;

    _opacityAnimation = Tween<double>(
      begin: (0.0),
      end: (1.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  Future<void> _submit() async {
    print('submitting');
    if (!_formkey.currentState!.validate()) {
      print('not validate');
      return;
    }
    FocusScope.of(context).unfocus();
    _formkey.currentState!.save();
    setState(() {
      _isloading = true;
      print('set state is loading');
    });
    try {
      if (_authMode == AuthMode.LogIn) {
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email'], _authData['password']);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .signUp(_authData['email'], _authData['password']);
        await Provider.of<Auth>(context, listen: false)
            .addToFireStore(_authData['email'],_authData['fullname']);

      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';

      if (error.toString().contains('EMAIL_EXIST')) {
        errorMessage = "EMAIL_EXIST";
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = "INVALID_EMAIL";
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = "WEAK_PASSWORD";
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = "EMAIL_NOT_FOUND";
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = "INVALID_PASSWORD";
      }

      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'UNKNOWN ERROR';
      _showErrorDialog(errorMessage);
      print("hey this is");
      print(error);
    }
    setState(() {
      _isloading = false;
    });
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Error occured'),
              content: Text(errorMessage),
              actions: [
                FlatButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text('okay'),
                )
              ],
            ));
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.LogIn) {
      setState(() {
        _authMode = AuthMode.SignUp;
        _controller.forward();
      });
    } else {
      setState(() {
        _authMode = AuthMode.LogIn;
        _controller.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.SignUp ? 400 : 300,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.SignUp ? 400 : 300),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: "E-mail"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val!.isEmpty || !val.contains('@')) {
                      return 'invalid email';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _authData['email'] = val!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Passowrd"),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (val) {
                    if (val!.isEmpty || val.length < 5) {
                      return 'invalid password too short';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _authData['password'] = val!;
                  },
                ),
                AnimatedContainer(
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.SignUp ? 60 : 0,
                    maxHeight: _authMode == AuthMode.SignUp ? 120 : 0,
                  ),
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: TextFormField(
                      enabled: _authMode == AuthMode.SignUp,
                      decoration:
                          InputDecoration(labelText: "Confirm Passowrd"),
                      obscureText: true,
                      validator: _authMode == AuthMode.SignUp
                          ? (val) {
                              if (val != _passwordController.text) {
                                return 'password do not match';
                              }
                              return null;
                            }
                          : null,
                    ),
                  ),


                ),

                AnimatedContainer(
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.SignUp ? 60 : 0,
                    maxHeight: _authMode == AuthMode.SignUp ? 140 : 0,
                  ),
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child:
                    TextFormField(
                        enabled: _authMode == AuthMode.SignUp,
                        decoration: InputDecoration(labelText: "Full Name"),
                        validator: _authMode == AuthMode.SignUp
                     ?
                       (val) {
                        if (val!.isEmpty || val.length < 5) {
                          return 'invalid name';
                        }
                        return null;
                      }:null,
                      onSaved: (val) {
                        _authData['fullname'] = val!;
                      },
                    ),

                  ),


                ),
                _authMode == AuthMode.SignUp
                    ? SizedBox(height: 10)
                :SizedBox(height: 35),
                if (_isloading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child: Text(
                        _authMode == AuthMode.SignUp ? 'Sign up' : 'Login'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: EdgeInsets.all(15),
                    color: Theme.of(context).primaryColor,
                    textColor:
                        Theme.of(context).primaryTextTheme.headline6!.color,
                  ),
                FlatButton(
                  child: Text(
                      '${_authMode == AuthMode.LogIn ? 'Sign up ' : 'Log in '}INSTEAD'),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
