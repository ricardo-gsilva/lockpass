import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/models/itens_model.dart';
import 'package:lockpass/stores/add_item_store.dart';

void main(){
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Creating the list of dropdown items', (){
    final addStore = AddItemStore();

    List<ItensModel> i = [
      ItensModel(id: 1, type: 'Email', service: 'Gmail', site: 'www.gmail.com', email: 'teste@gmail.com',
       login: 'testegmail', password: 'sdas'),
      ItensModel(id: 1, type: 'Jogos', service: 'Steam', site: 'www.steam.com', email: 'teste@steam.com',
       login: 'testeSteam', password: 'sdas')];

    addStore.listItemDropDown(i);

    expect(addStore.listItensDrop, ['Email','Jogos']);
  });

  test('Testing password visibility', (){
    final addStore = AddItemStore();

    addStore.visibilityPass();

    expect(addStore.sufixIcon, false);
    expect(addStore.obscureText, false);

    addStore.visibilityPass();

    expect(addStore.sufixIcon, true);
    expect(addStore.obscureText, true);
  });

  test('Validating whether the email is valid', (){
    final addStore = AddItemStore();

    String? valid = addStore.validarEmail('');
    expect(valid, null);

    String? valid1 = addStore.validarEmail('teste@');
    expect(valid1, 'Email Inválido!');

    String? valid2 = addStore.validarEmail('teste@teste.com');
    expect(valid2, null);
  });

  test('Validating whether the fields are empty', (){
    final addStore = AddItemStore();

    String? valid = addStore.textFieldValidator('');
    expect(addStore.fieldIsValid, false);
    expect(valid, 'Por favor preencha o campo!');

    String? valid2 = addStore.textFieldValidator('1234');
    expect(addStore.fieldIsValid, true);
    expect(valid2, null);
  });

  test('Validating whether the mandatory form fields have been completed', (){
    final addStore = AddItemStore();

    String password = 'teste';
    String login = 'teste';
    String service = 'email';

    addStore.formValidator('', '', service);

    expect(addStore.formIsValid, false);

    addStore.formValidator('', login, '');

    expect(addStore.formIsValid, false);

    addStore.formValidator(password, '', '');

    expect(addStore.formIsValid, false);

    addStore.formValidator(password, login, service);

    expect(addStore.formIsValid, true);
  });

  test('Adding new item to database', (){
    final addStore = AddItemStore();

    ItensModel i = ItensModel(id: 1, type: 'Email', service: 'Gmail', site: 'www.gmail.com', email: 'teste@gmail.com',
       login: 'testegmail', password: 'sdas');

    addStore.addItem(i);

    expect(addStore.listItens, ['Email']);
  });
  
}