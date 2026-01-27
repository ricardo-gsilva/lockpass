import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/di/get_it.dart';
import 'package:lockpass/features/addItem/presentation/page/add_item_page.dart';
import 'package:lockpass/features/config/presentation/page/config_page.dart';
import 'package:lockpass/features/home/presentation/controller/home_controller.dart';
import 'package:lockpass/features/home/presentation/state/home_state.dart';
import 'package:lockpass/models/itens_model.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/screens/config.dart';
import 'package:lockpass/screens/list_item.dart';
import 'package:lockpass/widgets/iconbutton_custom.dart';
import 'package:lockpass/widgets/text_custom.dart';
import 'package:lockpass/widgets/textformfield_custom.dart';

class HomePage1 extends StatefulWidget {
  final ItensModel? listItens;
  const HomePage1({this.listItens, super.key});

  @override
  State<HomePage1> createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
  final _searchController = TextEditingController();
  bool _dialogShown = false;
  late final HomeController homeController;

  @override
  void initState() {
    super.initState();
    homeController = getIt<HomeController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeController.init();
    });
    print("🔥 HOME INITSTATE");

  }

  @override
  void dispose() {
    _searchController.dispose();
    homeController.close();
    super.dispose();
  }

  // @override
  // void didChangeDependencies() async {
  //   bool getPin = await store.getPin();
  //   if (getPin) {
  //     showCreatePin();
  //   }
  //   super.didChangeDependencies();
  // }

  void showCreatePinDialog(BuildContext context, HomeState state) {
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
          actionsPadding:
              const EdgeInsets.only(left: 10, right: 10, bottom: 15),
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
                    homeController.onItemTapped(2);
                    Navigator.of(context).pop();
                  },
                ),
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const TextCustom(
                        text: CoreStrings.showAnymore,
                      ),
                      Checkbox(
                        activeColor: CoreColors.primaryColor,
                        checkColor: CoreColors.textSecundary,
                        value: state.isChecked,
                        onChanged: (value) {
                          if (value == null) return;
                          homeController.setHideCreatePinInfo(value);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {   
    return BlocProvider.value(
      value: homeController,
      child: BlocListener<HomeController, HomeState>(
        listenWhen: (previous, current) =>
            previous.showPinAlert != current.showPinAlert,
        listener: (context, state) {
          if (state.showPinAlert && !_dialogShown) {
            _dialogShown = true;
            showCreatePinDialog(context, state);
          }
        },
        child: BlocBuilder<HomeController, HomeState>(
          builder: (context, state) {
             final screens = <Widget>[
              ListItem(
                mode: context.select((HomeController c) => c.state.mode),
                itens: context.select((HomeController c) => c.state.filterItens),
                listTypes: context.select((HomeController c) => c.state.listTypes),
                getData: context.read<HomeController>().getData,
              ),
              AddItemPage1(
                  itens: context.select((HomeController c) => c.state.listItens)),
              const ConfigPage1(),
            ];
            return Scaffold(
              backgroundColor: CoreColors.secondColor,
              appBar: AppBar(
                centerTitle: true,
                toolbarHeight: 76,
                backgroundColor: CoreColors.primaryColor,
                title: state.searchTextField
                    ? TextFormFieldCustom(
                        key: CoreKeys.formFieldSearchItem,
                        label: CoreStrings.searchLogin,
                        colorTextLabel: CoreColors.selectBorder,
                        keyboardType: TextInputType.text,
                        controller: _searchController,
                        cursorColor: CoreColors.textPrimary,
                        colorTextInput: CoreColors.textPrimary,
                        onChanged: (value) {
                          homeController.searchList(value);
                        },
                      )
                    : SizedBox(
                        key: CoreKeys.sizedBoxIconApp,
                        height: 70,
                        child: Image.asset(CoreStrings.iconApp),
                      ),
                actions: [
                  Visibility(
                      visible: state.selectedIndex == 0,
                      child: IconButtonCustom(
                        key: CoreKeys.iconButtonSearch,
                        onPressed: () {
                          homeController.visibleSearch();
                        },
                        icon: CoreIcons.search,
                        color: CoreColors.textSecundary,
                      )),
                ],
              ),
              body: state.filterItens.isEmpty && state.selectedIndex == 0
                  ? Center(
                      child: TextCustom(
                        key: CoreKeys.notFoundItem,
                        text: CoreStrings.notFoundItem,
                      ),
                    )
                  : screens[state.selectedIndex],
              bottomNavigationBar: BottomNavigationBar(
                key: CoreKeys.bottomNavigationBar,
                onTap: (index) => homeController.onItemTapped(index),
                currentIndex: state.selectedIndex,
                backgroundColor: CoreColors.primaryColor,
                elevation: 2,
                selectedItemColor: CoreColors.selectBottomBar,
                unselectedItemColor: CoreColors.unselectBottomBar,
                items: [
                  BottomNavigationBarItem(
                    icon: state.mode == 0
                        ? const Icon(CoreIcons.list)
                        : const Icon(CoreIcons.group),
                    label: state.mode == 0 ? CoreStrings.list : CoreStrings.group,
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(CoreIcons.add),
                    label: CoreStrings.add,
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(CoreIcons.config),
                    label: CoreStrings.config,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
