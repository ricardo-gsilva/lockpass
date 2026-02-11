import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/di/get_it.dart';
import 'package:lockpass/features/addItem/presentation/page/add_item_page.dart';
import 'package:lockpass/features/config/presentation/page/config_page.dart';
import 'package:lockpass/features/home/presentation/controller/home_controller.dart';
import 'package:lockpass/features/home/presentation/enums/home_tab_enum.dart';
import 'package:lockpass/features/home/presentation/enums/list_view_enum.dart';
import 'package:lockpass/features/home/presentation/state/home_state.dart';
import 'package:lockpass/features/home/presentation/widgets/list_item_grouped_widget.dart';
import 'package:lockpass/features/home/presentation/widgets/list_item_widget.dart';
import 'package:lockpass/models/itens_model.dart';
import 'package:lockpass/constants/core_colors.dart';
import 'package:lockpass/constants/core_icons.dart';
import 'package:lockpass/constants/core_keys.dart';
import 'package:lockpass/constants/core_strings.dart';
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
                        value: state.hideCreatePinInfo,
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
              if (state.viewMode == ListViewEnum.list)
                BlocProvider.value(
                  value: homeController,
                  child: ListItemWidget(),
                )
              else
                BlocProvider.value(
                  value: homeController,
                  child: ListItemGroupedWidget(),
                ),
              AddItemPage1(
                itens: context.select((HomeController c) => c.state.allItems),
              ),
              const ConfigPage1(),
            ];
            // if (state.isLoading) {
            //   return CircularProgressIndicator(
            //     color: CoreColors.alertError,
            //   );
            // }
            return Scaffold(
              backgroundColor: CoreColors.secondColor,
              appBar: AppBar(
                centerTitle: true,
                toolbarHeight: 76,
                backgroundColor: CoreColors.primaryColor,
                title: state.searchTextField && state.currentTab == HomeTab.list
                    ? TextFormFieldCustom(
                        key: CoreKeys.formFieldSearchItem,
                        label: CoreStrings.searchLogin,
                        colorTextLabel: CoreColors.textSecundary,
                        colorFocusedBorder: CoreColors.unselectBottomBar,
                        keyboardType: TextInputType.text,
                        controller: _searchController,
                        cursorColor: CoreColors.textSecundary,
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
                      visible: state.currentTab == HomeTab.list,
                      child: IconButtonCustom(
                        key: CoreKeys.iconButtonSearch,
                        onPressed: () {
                          homeController.visibleSearch();
                        },
                        icon: CoreIcons.search,
                        color: CoreColors.textSecundary,
                      )),
                ],
                leading: MenuAnchor(
                  // Estilização do menu para combinar com seus cards amarelos
                  style: MenuStyle(
                    backgroundColor:
                        WidgetStateProperty.all(CoreColors.titleItem),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  builder: (context, controller, child) {
                    return IconButton(
                      onPressed: () {
                        if (controller.isOpen) {
                          controller.close();
                        } else {
                          controller.open();
                        }
                      },
                      icon:
                          const Icon(Icons.account_circle, color: Colors.white),
                    );
                  },
                  menuChildren: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextCustom(
                        text:
                            'Logado: ${state.userEmail}', // O email que você quer mostrar
                      ),
                    ),
                  ],
                ),
              ),
              body: Stack(
                children: [
                  Positioned.fill(
                    child: state.filteredItems.isEmpty &&
                            state.currentTab == HomeTab.list
                        ? Center(
                            child: TextCustom(
                              key: CoreKeys.notFoundItem,
                              text: CoreStrings.notFoundItem,
                            ),
                          )
                        : screens[state.selectedIndex],
                  ),
                  if (state.isLoading)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withAlpha(89),
                        child: Center(
                          child: SizedBox(
                            height: 48,
                            width: 48,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: CoreColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    )
                ],
              ),
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
                    icon: state.viewMode == ListViewEnum.list
                        ? const Icon(CoreIcons.list)
                        : const Icon(CoreIcons.group),
                    label: state.viewMode == ListViewEnum.list
                        ? CoreStrings.list
                        : CoreStrings.group,
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
