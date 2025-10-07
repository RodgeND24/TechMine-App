import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:techmine/features/root/utils.dart';
import 'package:techmine/features/routing/app_route.dart';
import 'package:techmine/services/auth/auth_provider.dart';
import 'package:techmine/services/auth/models/register_data.dart';

@RoutePage()
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final _formKey = GlobalKey<FormState>();
  final RegisterData _registerData = RegisterData();
  bool _obscurePassword = true;
  bool _obscureRepeatPassword = true;

  final emailRegExp = RegExp(r'([a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z0-9_-]+)');


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
                                        child: Column(
                                          children: [
                                              SizedBox(
                                                width: 300,
                                                child: TextFormField(
                                                  style: inputTextStyle,
                                                  onSaved: (text) {_registerData.email = text!.trim();},
                                                  validator: (text) {
                                                      if (text == null || text.isEmpty) {return 'Email не заполнен';}
                                                      if (!emailRegExp.hasMatch(text)) {return 'Некорректная email';}
                                                      return null;
                                                    },
                                                  decoration: InputDecoration(
                                                                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: textColor)),
                                                                  labelText: 'Email',
                                                                  labelStyle: inputTextStyle,
                                                                  prefixIcon: Icon(Icons.email, color: textColor)
                                                              ),
                                                  ),
                                                ),

                                              SizedBox(height: 15),

                                              SizedBox(
                                                // constraints: BoxConstraints(minWidth: 100, maxWidth: 300),
                                                width: 300,
                                                child: TextFormField(
                                                  style: inputTextStyle,
                                                  onSaved: (text) {_registerData.username = text!.trim();},
                                                  validator: (text) {
                                                      if (text == null || text.isEmpty) {return 'Логин не заполнен';}
                                                      if (text.length < 3 || text.length > 20) {return 'Минимальная длина 3, максимальная длина 20';}
                                                      return null;
                                                    },
                                                  decoration: InputDecoration(
                                                                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: textColor)),
                                                                  labelText: 'Логин',
                                                                  labelStyle: inputTextStyle,
                                                                  prefixIcon: Icon(Icons.person_2_rounded, color: textColor)
                                                              ),
                                                  ),
                                                ),

                                              SizedBox(height: 15),

                                              SizedBox(
                                                // constraints: BoxConstraints(minWidth: 100, maxWidth: 300),
                                                width: 300,
                                                child: TextFormField(
                                                  style: inputTextStyle,
                                                  onSaved: (text) {_registerData.password = text!;},
                                                  validator: (text) {
                                                      if (text == null || text.isEmpty) {return 'Пароль не заполнен';}
                                                      if (text.length < 10) {return 'Минимальная длина 10';}
                                                      return null;
                                                    },
                                                  decoration: InputDecoration(
                                                                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: textColor)),
                                                                  labelText: 'Пароль',
                                                                  labelStyle: inputTextStyle,
                                                                  prefixIcon: Icon(Icons.lock, color: textColor),
                                                                  suffixIcon: IconButton(
                                                                                onPressed: () {
                                                                                    setState(() {
                                                                                      _obscurePassword = !_obscurePassword;
                                                                                    });
                                                                                  },
                                                                                icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off, color: textColor)),
                                                    ),
                                                  obscureText: _obscurePassword,
                                                  
                                                  ),
                                                ),
                                              
                                              SizedBox(height: 15),

                                              SizedBox(
                                                // constraints: BoxConstraints(minWidth: 100, maxWidth: 300),
                                                width: 300,
                                                child: TextFormField(
                                                  style: inputTextStyle,
                                                  onSaved: (text) {_registerData.repeatPassword = text!;},
                                                  validator: (text) {
                                                      if (text == null || text.isEmpty) {return 'Пароль не заполнен';}
                                                      if (text.length < 10) {return 'Минимальная длина 10';}
                                                      return null;
                                                    },
                                                  decoration: InputDecoration(
                                                                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: textColor)),
                                                                  labelText: 'Повторить пароль',
                                                                  labelStyle: inputTextStyle,
                                                                  prefixIcon: Icon(Icons.lock, color: textColor),
                                                                  suffixIcon: IconButton(
                                                                                onPressed: () {
                                                                                    setState(() {
                                                                                      _obscureRepeatPassword = !_obscureRepeatPassword;
                                                                                    });
                                                                                  },
                                                                                icon: Icon(_obscureRepeatPassword ? Icons.visibility : Icons.visibility_off, color: textColor)
                                                                              ),
                                                    ),
                                                  obscureText: _obscureRepeatPassword,
                                                  
                                                  ),
                                                ),

                                              SizedBox(height: 15),

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
                                                            child: authProvider.isLoading ? CircularProgressIndicator() : Text('Регистрация', style: accessButtonTextStyle)
                                                          )
                                                ),
                                              SizedBox(height: 45),
                                              Padding(
                                                  padding: EdgeInsets.only(bottom: 20),
                                                  child: Text('Уже есть аккаунт?', style: TextStyle(color: textColor)),
                                              ),
                                              Container(
                                                  decoration: BoxDecoration(
                                                    gradient: acceptColorGradient1,
                                                    borderRadius: BorderRadius.circular(25)
                                                  ),
                                                  width: 200,
                                                  height: 45,
                                                  child: ElevatedButton(
                                                            onPressed: () {context.router.replace(LoginRoute());},
                                                            style: getStyleByParent,
                                                            child: Text('Войти', style: accessButtonTextStyle)
                                                          ),
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
        final user = await authProvider.register(_registerData.email, _registerData.username, _registerData.password, _registerData.repeatPassword);
        if (user == null) {
          print('Register failed with error: ${authProvider.error}');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Register error: ${authProvider.error}'), backgroundColor: Colors.red,));
        }
        else {
          print('Register successful for user: ${user.username}');
          context.pushRoute(MainRoute());
        }
      }
      catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Enter error: ${e.toString()}'), backgroundColor: Colors.red,));
      }

    }

}