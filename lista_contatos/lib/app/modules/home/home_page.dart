import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lista_contatos/app/database/contact_data.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//Podemos ter somente um data, pois colocamos ele como singleton
  ContactDatabase contactDatabase = ContactDatabase();
  List<Contact> contacts = [];

  //Para inicializar sempre que iniciarmos o app
  @override
  void initState() {
    super.initState();
    contactDatabase.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Contatos'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.filter_list,
              size: 32,
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return _contactCard(context, index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: contacts[index].image != null
                        ? FileImage(File(contacts[index].image))
                        : AssetImage("lib/app/images/person.png"),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contacts[index].name ??
                          "", //Isso quer dizer que se o nome for salvo vazio, ficará vazio
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      contacts[index].email ??
                          "", //Isso quer dizer que se o nome for salvo vazio, ficará vazio
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      contacts[index].phone ??
                          "", //Isso quer dizer que se o nome for salvo vazio, ficará vazio
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
