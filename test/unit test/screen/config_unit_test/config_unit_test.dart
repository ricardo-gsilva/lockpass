import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/stores/config_page_store.dart';

void main(){
  TestWidgetsFlutterBinding.ensureInitialized();
  test('Checking the number of characters in the PIN', (){
    final configStore = ConfigPageStore();

    bool check = configStore.checkPinLength('12345');

    expect(check,true);

    bool check1 = configStore.checkPinLength('1234');

    expect(check1,false);

    bool check2 = configStore.checkPinLength('');

    expect(check2,false);
  });

  test('Checking if the PIN follows the defined rules', (){
    final configStore = ConfigPageStore();

    configStore.validatePin('');

    expect(configStore.pinValidate, false);

    configStore.validatePin('11123');

    expect(configStore.pinValidate, false);

    configStore.validatePin('11223');

    expect(configStore.pinValidate, false);

    configStore.validatePin('12345');

    expect(configStore.pinValidate, true);
  });
}