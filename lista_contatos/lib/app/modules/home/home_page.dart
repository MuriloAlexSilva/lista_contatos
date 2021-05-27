import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:lista_contatos/app/database/contact_data.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOptions { orderaz, orderza }

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
    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Contatos'),
        centerTitle: true,
        actions: [
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                  child: Text('Ordernar de A a Z'),
                  value: OrderOptions.orderaz),
              const PopupMenuItem<OrderOptions>(
                  child: Text('Ordernar de Z a A'),
                  value: OrderOptions.orderza),
            ],
            onSelected: _orderList,
          ),
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
        onPressed: () {
          _showNewContactPage();
        },
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
                    fit: BoxFit.cover, //Para deixar a imagem arredondada
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
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index) {
    showBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                      onPressed: () {
                        //Para utilizar o launch (package que chama o telefone), temos que importar o url_launcher
                        launch('tel: ${contacts[index].phone}');
                      },
                      child: Text('Ligar',
                          style: TextStyle(color: Colors.red, fontSize: 20))),
                  TextButton(
                      onPressed: () {
                        Modular.to.pop();
                        _showNewContactPage(
                            text: contacts[index], contact: contacts[index]);
                      },
                      child: Text('Editar',
                          style: TextStyle(color: Colors.red, fontSize: 20))),
                  TextButton(
                      onPressed: () {
                        //Coloca dentro do setState para atulizar a pagina
                        setState(() {
                          contactDatabase.deleteContact(
                              contacts[index].id); //remove o contato do db
                          contacts.removeAt(index); //remove da lista
                          Modular.to.pop();
                        });
                      },
                      child: Text('Excluir',
                          style: TextStyle(color: Colors.red, fontSize: 20))),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _getAllContacts() {
    contactDatabase.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  void _showNewContactPage({Contact contact, Object text}) async {
    final recNewContact =
        await Modular.to.pushNamed('/contactPage', arguments: text);
    if (recNewContact != null) {
      if (contact != null) {
        await contactDatabase
            .updateContact(recNewContact); //Atualizar o contato

      } else {
        await contactDatabase.saveContact(recNewContact); //salvar contato novo
      }
      _getAllContacts();
    }
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        contacts.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        contacts.sort((a, b) {
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState(() {});
  }
}
