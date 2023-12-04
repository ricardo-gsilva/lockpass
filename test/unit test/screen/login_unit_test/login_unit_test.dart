import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/stores/login_store.dart';

void main(){
  TestWidgetsFlutterBinding.ensureInitialized();  

  const MethodChannel('plugins.flutter.io/shared_preferences').
    setMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'getAll') {
      return <String, dynamic>{}; // set initial values here if desired
    }
    return null;
  });

  test('Visible password', () {
    final loginStore = LoginStore();
    
    expect(loginStore.obscureText, true);
    expect(loginStore.sufixIcon, true);

    loginStore.visibilityPass();

    expect(loginStore.obscureText, false);
    expect(loginStore.sufixIcon, false);
  });
  
  test('Check number of PIN characters', () {
    final loginStore = LoginStore();

    expect(loginStore.checkPinLength('12345'), true);
    expect(loginStore.checkPinLength('1235'), false);
  });

  test('Login with EMAIL or PIN', (){
    final loginStore = LoginStore();

    expect(loginStore.pinCreated, false);

    loginStore.changeLoginWithPin(true);

    expect(loginStore.pinCreated, true);

    loginStore.changeLoginWithPin(false);

    expect(loginStore.pinCreated, false);
  });

  test('Testing email validator responses', (){
    final loginStore = LoginStore();

    String? check = loginStore.validarEmail('');

    expect(check, null);

    String? check1 = loginStore.validarEmail('teste@teste');

    expect(check1, 'Email Inválido!');

    String? check2 = loginStore.validarEmail('teste@teste.com');

    expect(check2, null);
  });

  test('Checking if the textfield is empty', (){
    final loginStore = LoginStore();

    bool checkFieldIsEmpty = loginStore.checkField();

    expect(checkFieldIsEmpty, false);

    loginStore.emailController.text = 'teste@teste.com';
    loginStore.passwordController.text = '12345';

    bool checkField = loginStore.checkField();

    expect(checkField, true);


  });

  test('login', (){

  });

  test('register', (){
    
  });

  test('resetPassword', (){
    
  });
}