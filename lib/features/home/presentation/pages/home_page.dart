import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/di/service_locator.dart';
import 'package:lockpass/core/ui/components/button_custom.dart';
import 'package:lockpass/features/add_item/presentation/page/add_item_page.dart';
import 'package:lockpass/features/config/presentation/page/config_page.dart';
import 'package:lockpass/features/home/presentation/controller/home_controller.dart';
import 'package:lockpass/features/home/presentation/state/home_event.dart';
import 'package:lockpass/features/home/presentation/state/home_status.dart';
import 'package:lockpass/features/list_item/presentation/enums/list_view_enum.dart';
import 'package:lockpass/features/home/presentation/state/home_state.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/core/constants/core_colors.dart';
import 'package:lockpass/core/constants/core_icons.dart';
import 'package:lockpass/core/constants/core_keys.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/features/list_item/presentation/page/list_item_page.dart';
import 'package:lockpass/core/ui/components/iconbutton_custom.dart';
import 'package:lockpass/core/ui/components/text_custom.dart';

class HomePage extends StatefulWidget {
  final ItensEntity? listItens;
  const HomePage({this.listItens, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();
  late final HomeController homeController;
  bool dontShowAgain = false;

  @override
  void initState() {
    super.initState();
    homeController = getIt<HomeController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeController.init();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    homeController.close();
    super.dispose();
  }

  void showCreatePinDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
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
              actions: [
                Flex(
                  direction: Axis.horizontal,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            activeColor: CoreColors.primaryColor,
                            checkColor: CoreColors.textSecundary,
                            value: dontShowAgain,
                            onChanged: (value) {
                              if (value == null) return;
                              setDialogState(() {
                                dontShowAgain = value;
                              });
                            },
                          ),
                          const TextCustom(
                            text: CoreStrings.showAnymore,
                          ),
                        ],
                      ),
                    ),
                    IconButtonCustom(
                      icon: CoreIcons.config,
                      color: CoreColors.textPrimary,
                      onPressed: () async {
                        await homeController
                            .setHideCreatePinInfo(dontShowAgain);
                        homeController.onItemTapped(2);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ButtonCustom(
                    key: CoreKeys.buttonCreatePin,
                    colorText: CoreColors.textPrimary,
                    text: "Fechar",
                    fontSize: 16,
                    backgroundButton: CoreColors.buttonColorSecond,
                    onPressed: () async {
                      await homeController.setHideCreatePinInfo(dontShowAgain);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: homeController,
      child: BlocListener<HomeController, HomeState>(
        listenWhen: (previous, current) => previous.event != current.event,
        listener: (context, state) {
          if (state.event is ShowPinDialogEvent) {
            showCreatePinDialog(context);
            homeController.clearEvent();
          }
        },
        child: BlocBuilder<HomeController, HomeState>(
          builder: (context, state) {
            final screens = <Widget>[
              ListItemPage(
                viewMode: state.viewMode,
              ),
              AddItemPage(
                itens: context.select((HomeController c) => []),
              ),
              const ConfigPage(),
            ];
            return Scaffold(
              backgroundColor: CoreColors.secondColor,
              appBar: AppBar(
                centerTitle: true,
                toolbarHeight: 76,
                backgroundColor: CoreColors.primaryColor,
                title: SizedBox(
                  key: CoreKeys.sizedBoxIconApp,
                  height: 70,
                  child: Image.asset(CoreStrings.iconApp),
                ),
                leading: MenuAnchor(
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
                        text: 'Logado: ${state.userEmail}',
                      ),
                    ),
                  ],
                ),
              ),
              body: Stack(
                children: [
                  screens[state.selectedIndex],
                  if (state.status is HomeLoading)
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
                        ? const Icon(CoreIcons.group)
                        : const Icon(CoreIcons.list),
                    label: state.viewMode == ListViewEnum.list
                        ? CoreStrings.group
                        : CoreStrings.list,
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
