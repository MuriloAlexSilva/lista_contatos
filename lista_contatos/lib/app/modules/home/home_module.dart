import 'package:flutter_modular/flutter_modular.dart';
import 'package:lista_contatos/app/database/contact_data.dart';
import 'package:lista_contatos/app/modules/contact/contact_page.dart';
import 'home_page.dart';

class HomeModule extends Module {
  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute<String>('/', child: (context, args) => HomePage()),
    //Para enviar os dados para a contactPage editar o usuario do index em questão
    ChildRoute<Contact>('/contactPage',
        child: (context, args) => ContactPage(
              contact: args.data,
            )),
  ];
}
