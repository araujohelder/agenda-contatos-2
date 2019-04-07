import 'dart:io';

import 'package:agenda_contatos_2/helpers/contact_helper.dart';
import 'package:agenda_contatos_2/pages/contact_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();
  List<Contact> constacts = List();

  @override
  void initState() {
    super.initState();
    _getAllContacts();
  }

  void _getAllContacts() {
    helper.getAllContacts().then((list) {
      setState(() {
        this.constacts = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        backgroundColor: Colors.red,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: constacts.length,
        itemBuilder: (context, index) {
          return _contactCard(context, index);
        },
      ),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: (){
        _showContactPage(contact: constacts[index]);
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView (
              scrollDirection: Axis.horizontal,
                      child: Container(
              child: Row(
                children: <Widget>[
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: constacts[index].img != null
                                ? FileImage(File(constacts[index].img))
                                : AssetImage("images/person.png"))),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(constacts[index].name ?? "",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                        Text(constacts[index].email ?? "",
                            style: TextStyle(fontSize: 18)),
                        Text(constacts[index].phone ?? "",
                            style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showContactPage({Contact contact}) async{
   final recContact = await  Navigator.push(context, MaterialPageRoute(builder: (context) => ContactPage(contact: contact,)));
    if (recContact != null) {
      if (contact != null) {
         await helper.update(recContact);
      } else {
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }
  
}
