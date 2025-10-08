import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:techmine/features/root/utils.dart';

@RoutePage()
class StartGamePage extends StatefulWidget {
  const StartGamePage({super.key});

  @override
  _StartGamePageState createState() => _StartGamePageState();
}
class _StartGamePageState extends State<StartGamePage> {


  @override
  Widget build(BuildContext context) {

    return DefaultEmptyPage(
      child: Column(
        children: [
          CustomSection(
            content: Column(
              children: [
                CustomMainText(text: 'Начало игры', size: 40),
                CustomAdditionalText(text: 'Добро пожаловать на наш увлекательный проект!', size: 20),
                CustomAdditionalText(text: 'Всего пара шагов отделяют Вас от игры на наших серверах!', size: 20),
                InstructionCard(
                  content: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomMainText(text: '1.', size: 30),
                      CustomMainText(text: '1.', size: 30),
                      CustomMainText(text: '1.', size: 30),
                      CustomMainText(text: '1.', size: 30),
                    ],
                  ),
                ),
              ],
            )
          )
        ]
      ),
    );
  }
}

class InstructionCard extends StatelessWidget {

  InstructionCard({String this.text = '', required Widget this.content});

  final String text;
  Widget content;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: foreignColor,
      shadowColor: Colors.black,
      margin: EdgeInsets.all(10),
      child: SizedBox(
        // constraints: BoxConstraints.expand(width: 400, height: 200),
        height: 100,
        width: double.infinity,
        child: CustomMainText(text: text, size: 20),
      )
    );
    
    
  }
}