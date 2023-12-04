import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lockpass/models/itens_model.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/stores/home_page_store.dart';
import 'package:lockpass/widgets/iconbutton_custom.dart';
import 'package:lockpass/widgets/text_custom.dart';
import 'package:lockpass/widgets/textformfield_custom.dart';

class HomePage extends StatefulWidget {
  final ItensModel? listItens;
  const HomePage({this.listItens, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageStore store = HomePageStore();

  @override
  void initState() {
    super.initState();
    store.getData();
    store.getPlatform();    
  }

  @override
  void didChangeDependencies() async {
    bool getPin = await store.getPin();
    if (getPin) {
      showCreatePin();
    }
    super.didChangeDependencies();
  }

  void showCreatePin() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            key: CoreKeys.alertDialogCreatePin,
            actionsOverflowDirection: VerticalDirection.down,
            backgroundColor: CoreColors.secondColor,
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextCustom(              
                  textAlign: TextAlign.center,
                  text: CoreStrings.createYourPin,
                  fontSize: 18,
                ),
                Icon(CoreIcons.warning)
              ],
            ),
            content: const TextCustom(      
              text: CoreStrings.noticeCreatePin,
              fontSize: 16,
            ),
            actionsPadding: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
            actions: [
              Flex(
                direction: Axis.horizontal,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButtonCustom(            
                    icon: CoreIcons.arrowBack,
                    color: CoreColors.textPrimary,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  IconButtonCustom(            
                    icon: CoreIcons.config,
                    color: CoreColors.textPrimary,
                    onPressed: () {
                      store.onItemTapped(2);
                      Navigator.of(context).pop();
                    },
                  ),
                  Flex(
                    direction: Axis.horizontal,
                    mainAxisSize: MainAxisSize.min,                    
                    children: [
                      const TextCustom(                       
                        text: CoreStrings.showAnymore,
                      ),
                      Observer(builder: (context) {
                        return Checkbox(                       
                          activeColor: CoreColors.primaryColor,
                          checkColor: CoreColors.textSecundary,
                          value: store.isChecked,
                          onChanged: (bool? value) {
                            store.checkBoxVisibleInfoPin(value!);
                          },
                        );
                      }),
                    ],
                  ),
                ],
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Scaffold(
        backgroundColor: CoreColors.secondColor,
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 76,
          backgroundColor: CoreColors.primaryColor,
          title: store.searchTextField == true
              ? TextFormFieldCustom(
                  key: CoreKeys.formFieldSearchItem,
                  label: CoreStrings.searchLogin,
                  colorTextLabel: CoreColors.selectBorder,
                  keyboardType: TextInputType.text,
                  controller: store.searchController,
                  cursorColor: CoreColors.textPrimary,
                  colorTextInput: CoreColors.textPrimary,
                  onChanged: store.searchList,
                )
              : SizedBox(
                  key: CoreKeys.sizedBoxIconApp,
                  height: 70,
                  child: Image.asset(CoreStrings.iconApp),
                ),
          actions: [
            Visibility(
              visible: store.visibleIconSearch(store.selectedIndex),
              child: IconButtonCustom(
                  key: CoreKeys.iconButtonSearch,
                  onPressed: () {
                    store.visibleSearch();
                  },
                  icon: CoreIcons.search,
                  color: CoreColors.textSecundary,
                )
              ),
          ],
        ),
        body: Observer(builder: (context) {          
          return store.loadingWidget(store.filterItens)
              ? const SizedBox(
                  child: Center(
                    child: TextCustom(
                      key: CoreKeys.notFoundItem,
                      text: CoreStrings.notFoundItem,
                    ),
                  ),
                )
              : store.screens()[store.selectedIndex];
        }),
        bottomNavigationBar: BottomNavigationBar(
            key: CoreKeys.bottomNavigationBar,
            onTap: store.onItemTapped,
            currentIndex: store.selectedIndex,
            backgroundColor: CoreColors.primaryColor,
            elevation: 2,
            selectedItemColor: CoreColors.selectBottomBar,
            unselectedItemColor: CoreColors.unselectBottomBar,
            items: [
              BottomNavigationBarItem(
                icon: store.mode == 0 ? const Icon(CoreIcons.list) : const Icon(CoreIcons.group),
                label: store.mode == 0? CoreStrings.list : CoreStrings.group,
              ),
              const BottomNavigationBarItem(
                icon: Icon(CoreIcons.add), label: CoreStrings.add,
              ),
              const BottomNavigationBarItem(
                  icon: Icon(CoreIcons.config), label: CoreStrings.config),
            ]),
      );
    });
  }
}
