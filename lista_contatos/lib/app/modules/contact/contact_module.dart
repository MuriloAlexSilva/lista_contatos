import 'package:flutter_modular/flutter_modular.dart';
import 'package:lista_contatos/app/modules/home/home_page.dart';
import 'contact_page.dart';

class ContactModule extends Module {
  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/contactPage', child: (context, args) => ContactPage()),
    ChildRoute<String>('/', child: (context, args) => HomePage()),
  ];
}
