import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:techmine/features/root/utils.dart';

@RoutePage()
class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  _ContactsPageState createState() => _ContactsPageState();
}
class _ContactsPageState extends State<ContactsPage> {


  @override
  Widget build(BuildContext context) {

    return DefaultEmptyPage(
            text: 'Contacts', 
            child: Container(),
          );
  }
}