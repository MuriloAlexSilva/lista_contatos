import 'package:flutter_modular/flutter_modular.dart';
import 'contact_page.dart';

class ContactModule extends Module {
  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/contactPage',
        child: (context, args) => ContactPage(
              contact: args.data,
            )),
  ];
}
