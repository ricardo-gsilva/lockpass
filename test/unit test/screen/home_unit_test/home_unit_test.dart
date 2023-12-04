import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/database/shared_preferences.dart';
import 'package:lockpass/models/itens_model.dart';
import 'package:lockpass/stores/home_page_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(){
  TestWidgetsFlutterBinding.ensureInitialized();
  test('Test search textfield visibility', (){    
    final homeStore = HomePageStore();

    expect(homeStore.searchTextField, false);

    homeStore.visibleSearch();

    expect(homeStore.searchTextField, true);
  });

  test('getPin', () async {
    final homeStore = HomePageStore();
    SharedPreferences.setMockInitialValues({});

    final SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();

    final SharedPrefs sharedPrefs =
            SharedPrefs(sharedPreferences: sharedPreferences);

    bool getPin = await homeStore.getPin();

    String checkPin = sharedPrefs.getPin();

    expect(getPin, true);
    print(checkPin);
  });

  test('Check if the search icon is visible', (){
    final homeStore = HomePageStore();

    bool get = homeStore.visibleIconSearch(0);

    expect(get, true);

    bool get1 = homeStore.visibleIconSearch(1);

    expect(get1, false);

    bool get2 = homeStore.visibleIconSearch(2);

    expect(get2, false);

  });

  test('Testing login list loading and filtering', (){
    final homeStore = HomePageStore();

    homeStore.filterList([], '');
    
    expect(homeStore.filterItens, []);
    expect(homeStore.listTypes, []);

    List<ItensModel> listItens = [];
    listItens.add(ItensModel(
      id: 1,
      type: 'Email',
      service: 'Gmail',
      site: 'www.gmail.com',
      email: 'teste@gmail.com',
      login: 'cadugmail',
      password: 'sdas'));
    
    expect(homeStore.listTypes, []);

    homeStore.filterList(listItens, '');

    String? type = '';

    expect(type, '');

    homeStore.listTypes.map((e){
      type = e.type;
      expect(type, 'Email');
    });

    expect(homeStore.filterItens, listItens);    
  });

  test('Check if the login list is empty to return informational text', (){
    final homeStore = HomePageStore();
    List<ItensModel> listItens = [];
    listItens.add(ItensModel(
      id: 1,
      type: 'Email',
      service: 'Gmail',
      site: 'www.gmail.com',
      email: 'teste@gmail.com',
      login: 'cadugmail',
      password: 'sdas'));
    homeStore.selectedIndex = 0;
    bool loadingWidget = homeStore.loadingWidget(listItens);

    expect(loadingWidget, false);

    List<ItensModel> listItens1 = [];
    homeStore.selectedIndex = 0;
    bool loadingWidget1 = homeStore.loadingWidget(listItens1);

    expect(loadingWidget1, true);

    List<ItensModel> listItens2 = [];
    homeStore.selectedIndex = 1;
    bool loadingWidget2 = homeStore.loadingWidget(listItens2);

    expect(loadingWidget2, false);

    homeStore.selectedIndex = 1;
    bool loadingWidget3 = homeStore.loadingWidget(listItens);

    expect(loadingWidget3, false);
    
  });

  test('Confirming loading of the screen list', (){
    final homeStore = HomePageStore();

    expect(homeStore.screens(), homeStore.listScreens);    

  });

  test('Testing PageView for changing screens', (){
    final homeStore = HomePageStore();

    homeStore.onItemTapped(0);

    expect(homeStore.mode, 1);

    homeStore.onItemTapped(1);

    expect(homeStore.mode, 1);
  });
}