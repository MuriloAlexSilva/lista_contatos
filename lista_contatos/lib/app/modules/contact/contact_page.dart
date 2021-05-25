import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:lista_contatos/app/database/contact_data.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact _editedContact;
  bool userEdited = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _nameFocus = FocusNode(); //Para criar um focus no nome

  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      //Para criar novos contatos
      _editedContact = Contact();
    } else {
      //Para puxar os contatos para editar
      _editedContact = Contact.fromMap(widget.contact.toMap());
      _nameController.text =
          _editedContact.name; //Para pegar o nome do contato para editar
      _emailController.text =
          _editedContact.email; //Para pegar o email do contato para editar
      _phoneController.text =
          _editedContact.phone; //Para pegar o phone do contato para editar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editedContact.name ??
            "Novo Contato"), //Isso seria para se possuir o contato ele envia o nome, senão coloca Novo Contato
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            GestureDetector(
              child: Container(
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: _editedContact.image != null
                        ? FileImage(File(_editedContact.image))
                        : AssetImage("lib/app/images/person.png"),
                  ),
                ),
              ),
            ),
            TextField(
              controller: _nameController,
              focusNode: _nameFocus, //Para controlar o foco neste textfield
              decoration: InputDecoration(labelText: 'Name'),
              keyboardType: TextInputType.name,
              onChanged: (text) {
                userEdited = true;
                setState(() {
                  //Para atualizar o titulo da AppBar
                  _editedContact.name = text;
                });
              },
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              onChanged: (text) {
                userEdited = true;
                _editedContact.email = text;
              },
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
              onChanged: (text) {
                userEdited = true;
                _editedContact.phone = text;
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () {
            if (_editedContact.name != null && _editedContact.name.isNotEmpty) {
              Modular.to.pop(_editedContact);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
        ),
      ),
    );
  }
}
