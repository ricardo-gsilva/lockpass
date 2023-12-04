import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/models/itens_model.dart';
import 'package:lockpass/models/type_model.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/stores/card_item_store.dart';

void main(){
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel =
      MethodChannel('dev.fluttercommunity.plus/aespack');

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMessageHandler(channel.name, (data) async {
    final MethodCall call = channel.codec.decodeMethodCall(data);
    if (call.method == 'getAll') {
      return channel.codec.encodeSuccessEnvelope(<String>{
        '', '0102030405060708', '1112131415161718'
      });
    }
    return null;
  });

  test('Checking dropdown list content', () {
    final cardStore = CardItemStore();
    TypeModel t = TypeModel(
      typeId: null,
      type: 'Steam',
      visible: false
    );

    List<String?> listType = [];
    List<TypeModel> type = [];

    type.add(t);
    type.map((e){
      listType.add(e.type);
      expect(cardStore.listTypeDrop, listType);
    });   

    cardStore.listItemDropDown(type);

    expect(cardStore.listType, type);    
  });

  test('Comparison of the item, to check whether information editing has occurred', (){
    final cardStore = CardItemStore();

    ItensModel i = ItensModel(
      id: 1,
      type: 'Jogos',
      service: 'Steam',
      site: 'www.steam.com.br',
      email: 'teste@steam.com',
      login: 'testeSteam',
      password: '12332112'
    );

    List<ItensModel> list = [];
    list.add(i);

    cardStore.getItem(i);

    expect(cardStore.newIten, i);
    expect(cardStore.itens, i);
  });

  test('Checking if fields are empty', (){
    final cardStore = CardItemStore();

    String pass = '12345';
    String login = 'teste';
    String service = 'steam';

    cardStore.validator('', '', '');

    expect(cardStore.formValidator, false);

    cardStore.validator(pass, '', '');

    expect(cardStore.formValidator, false);

    cardStore.validator(pass, login, '');

    expect(cardStore.formValidator, false);

    cardStore.validator(pass, login, service);

    expect(cardStore.formValidator, true);
  });

  test('Validating whether the email is valid', (){
    final cardStore = CardItemStore();

    String? valid = cardStore.validarEmail('');
    expect(valid, 'Informe o Email');

    String? valid1 = cardStore.validarEmail('teste@');
    expect(valid1, 'Email Inválido!');

    String? valid2 = cardStore.validarEmail('teste@teste.com');
    expect(valid2, null);
  });

  test('Validating whether the fields are empty', (){
    final cardStore = CardItemStore();

    String? valid = cardStore.textFieldValidator('');
    expect(cardStore.validation, false);
    expect(valid, 'Por favor preencha o campo!');

    String? valid2 = cardStore.textFieldValidator('1234');
    expect(cardStore.validation, true);
    expect(valid2, null);
  });

  test('Testing icon changes', (){
    final cardStore = CardItemStore();

    cardStore.changeIcon(false);
    expect(cardStore.icon, CoreIcons.save);

    cardStore.changeIcon(true);
    expect(cardStore.icon, CoreIcons.edit);
  });
}