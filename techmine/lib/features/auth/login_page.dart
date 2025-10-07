import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techmine/features/root/utils.dart';
import 'package:techmine/features/routing/app_route.dart';
import 'package:techmine/services/auth/auth_provider.dart';
import 'package:techmine/services/auth/models/login_data.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  final void Function(bool success)? onNavigationResult;
  const LoginPage({super.key, this.onNavigationResult});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();
  final LoginData _loginData = LoginData();
  bool _obscurePassword = true; // hide the password by default

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.clearError();
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: mainColor,
      body: Center(
                child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                      topImage,
                                      Container(
                                        padding: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                            color: foreignColor,
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: Column(children: [
                                            SizedBox(
                                              width: 300,
                                              child: TextFormField(
                                                style: inputTextStyle,
                                                onChanged: (text) {
                                                  if (authProvider.error != null) {
                                                    authProvider.clearError();
                                                  }
                                                },
                                                onSaved: (text) {_loginData.username = text!.trim();},
                                                validator: (text) {
                                                    if (text == null || text.isEmpty) {return 'Логин не заполнен';}
                                                    if (text.length < 3) {return 'Минимальная длина 3';}
                                                    return null;
                                                  },
                                                decoration: InputDecoration(
                                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: textColor)),
                                                    labelText: 'Логин',
                                                    labelStyle: TextStyle(color: Colors.white),
                                                    prefixIcon: Icon(Icons.person_2_rounded, color: Colors.white,)),
                                                ),
                                              ),

                                            SizedBox(height: 45),

                                            SizedBox(
                                              // constraints: BoxConstraints(minWidth: 100, maxWidth: 300),
                                              width: 300,
                                              child: TextFormField(
                                                style: inputTextStyle,
                                                onChanged: (text) {
                                                  if (authProvider.error != null) {
                                                    authProvider.clearError();
                                                  }
                                                },
                                                onSaved: (text) {_loginData.password = text!;},
                                                validator: (text) {
                                                    if (text == null || text.isEmpty) {return 'Пароль не заполнен';}
                                                    if (text.length < 10) {return 'Минимальная длина 10';}
                                                    return null;
                                                  },
                                                decoration: InputDecoration(
                                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: textColor)),
                                                    labelText: 'Пароль',
                                                    labelStyle: inputTextStyle,
                                                    prefixIcon: Icon(Icons.lock, color: Colors.white,),
                                                    suffixIcon: IconButton(
                                                                  onPressed: () {
                                                                      setState(() {
                                                                        _obscurePassword = !_obscurePassword;
                                                                      });
                                                                    },
                                                                  icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off, color: Colors.white,)),
                                                  ),
                                                obscureText: _obscurePassword,
                                                
                                                ),
                                              ),
                                            SizedBox(height: 45),
                                            Container(
                                                decoration: BoxDecoration(
                                                  gradient: acceptColorGradient2,
                                                  borderRadius: BorderRadius.circular(25)
                                                ),
                                                width: 200,
                                                height: 45,
                                                child: ElevatedButton(
                                                          onPressed: authProvider.isLoading ? null : _submitForm,
                                                          style: getStyleByParent,
                                                          child: authProvider.isLoading ? CircularProgressIndicator() : Text('Войти', style: TextStyle(color: Colors.white, fontSize: 20))
                                                        )
                                              ),
                                            SizedBox(height: 45),
                                            Padding(
                                                padding: EdgeInsets.only(bottom: 20),
                                                child: Text('Ещё нет аккаунта?', style: TextStyle(color: Colors.white),),
                                            ),
                                            Container(
                                                decoration: BoxDecoration(
                                                  gradient: acceptColorGradient1,
                                                  borderRadius: BorderRadius.circular(25)
                                                ), 
                                                width: 180,
                                                height: 45,
                                                child: ElevatedButton(
                                                          onPressed: () {context.router.replace(RegisterRoute());},
                                                          style: getStyleByParent,
                                                          child: Text('Регистрация', style: TextStyle(color: Colors.white, fontSize: 20),)),
                                              ),
                                          ],
                                        ),
                                      )
                                      

                                  ],
                            ),
                          ),
                        ),
              )
      );
    }

    Future<void> _submitForm() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (!_formKey.currentState!.validate()) { return; }

    _formKey.currentState!.save();
    
    try {
      final currentUser = await authProvider.login(_loginData.username, _loginData.password);
      
      if (currentUser == null) {
        print('Login failed with error: ${authProvider.error}');
        widget.onNavigationResult?.call(false);
      } else {
        print('Login successful for user: ${currentUser.username}');
        widget.onNavigationResult?.call(true);
        context.pushRoute(MainRoute());
      }
    } catch (e) {
      print('Unexpected error: $e');
      widget.onNavigationResult?.call(false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red)
        );
      }
    }
  }



}