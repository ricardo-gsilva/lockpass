import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/constants/core_colors.dart';
import 'package:lockpass/core/constants/core_icons.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/di/service_locator.dart';
import 'package:lockpass/core/extensions/context_extensions.dart';
import 'package:lockpass/core/extensions/string_validators.dart';
import 'package:lockpass/core/ui/components/button_custom.dart';
import 'package:lockpass/core/ui/components/iconbutton_custom.dart';
import 'package:lockpass/core/ui/components/info_dialog.dart';
import 'package:lockpass/core/ui/components/text_custom.dart';
import 'package:lockpass/core/ui/components/textbutton_custom.dart';
import 'package:lockpass/core/ui/factorys/fields_factory.dart';
import 'package:lockpass/core/ui/overlays/overlay_toast_utils.dart';
import 'package:lockpass/features/list_item/presentation/controller/list_item_controller.dart';
import 'package:lockpass/features/list_item/presentation/state/list_item_state.dart';
import 'package:lockpass/features/list_item/presentation/state/list_item_status.dart';

class SecurityValidationBottomSheet extends StatefulWidget {
  const SecurityValidationBottomSheet({super.key});

  @override
  State<SecurityValidationBottomSheet> createState() =>
      _SecurityValidationBottomSheetState();
}

class _SecurityValidationBottomSheetState
    extends State<SecurityValidationBottomSheet> {
  final TextEditingController pinController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late final ListItemController listItemController;
  bool _obscurePin = true;
  bool _obscurePassword = true;
  bool _canSubmit = false;
  bool _pinOrEmailAndPassword = false;

  @override
  void initState() {
    super.initState();
    listItemController = getIt<ListItemController>();
  }

  @override
  void dispose() {
    pinController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _showInfo(String msg, String titleInfo) {
    showDialog(
      context: context,
      builder: (_) => InfoDialog(
        title: titleInfo,
        content: msg,
        widgets: [
          TextButtonCustom(
            text: "Fechar",
            colorText: CoreColors.textPrimary,
            fontSize: 16,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: listItemController,
      child: BlocListener<ListItemController, ListItemState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          switch (state.status) {
            case TrashAuthFailure(:final message):
              OverlayToast.showError(content: message);
              break;
            case TrashAuthSuccess():
              OverlayToast.showSuccess(
                  content: "Suas credenciais estão válidas");
              Navigator.maybePop(context, true);
              break;
            default:
              break;
          }
        },
        child: Padding(
          padding: EdgeInsets.only(bottom: context.bottomSystemSpace),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            behavior: HitTestBehavior.opaque,
            child: Stack(children: [
              GestureDetector(
                onTap: () {},
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: CoreColors.primaryColor,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: BlocBuilder<ListItemController, ListItemState>(
                      builder: (context, state) {
                        return SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextCustom(
                                      text: "Validação de Segurança",
                                      color: CoreColors.textSecundary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    IconButtonCustom(
                                      icon: CoreIcons.info,
                                      iconSize: 22,
                                      color: CoreColors.textSecundary,
                                      onPressed: () => _showInfo(
                                        "Caso deseje rever itens que foram excluídos, prossiga com a validação de segurança.\n\nApós a validação, a tela de listagem exibirá todos os itens excluídos até o momento. Lá, você poderá restaurar um item, apagá-lo permanentemente ou sair do modo de visualização a qualquer momento.",
                                        "Mostrar Itens Excluídos",
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                TextCustom(
                                  text: !_pinOrEmailAndPassword
                                      ? "Digite seu PIN de 5 dígitos para prosseguir."
                                      : "Insira suas credenciais de acesso.",
                                  color: CoreColors.textSecundary,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                !_pinOrEmailAndPassword
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 20),
                                            child: const Icon(
                                              CoreIcons.pin,
                                              color: CoreColors.textSecundary,
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: FieldsFactory.pin(
                                                controller: pinController,
                                                obscureText: _obscurePin,
                                                validator: (value) =>
                                                    value.pinError,
                                                onToggleVisibility: () {
                                                  setState(() {
                                                    _obscurePin = !_obscurePin;
                                                  });
                                                },
                                                onChanged: (value) {
                                                  setState(() {
                                                    _canSubmit =
                                                        value.trim().length >=
                                                            5;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          FieldsFactory.email(
                                              controller: emailController,
                                              validator: (value) =>
                                                  value.emailError,
                                              onChanged: (value) {
                                                _canSubmit =
                                                    value.emailError == null;
                                              }),
                                          FieldsFactory.password(
                                            controller: passwordController,
                                            obscureText: _obscurePassword,
                                            validator: (value) =>
                                                value.passwordError,
                                            onToggleVisibility: () {
                                              setState(() {
                                                _obscurePassword =
                                                    !_obscurePassword;
                                              });
                                            },
                                            onChanged: (value) {
                                              setState(() {
                                                _canSubmit =
                                                    value.passwordError == null;
                                              });
                                            },
                                          )
                                        ],
                                      ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButtonCustom(
                                      text: _pinOrEmailAndPassword
                                          ? CoreStrings.enterPin
                                          : CoreStrings.enterEmailAndPassword,
                                      colorText: CoreColors.textSecundary,
                                      onPressed: () {
                                        setState(() {
                                          _pinOrEmailAndPassword =
                                              !_pinOrEmailAndPassword;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text(
                                        "Cancelar",
                                        style: TextStyle(
                                          color: CoreColors.textTertiary,
                                        ),
                                      ),
                                    ),
                                    ButtonCustom(
                                      isLoading:
                                          state.status == ListItemLoading(),
                                      backgroundButton:
                                          CoreColors.buttonColorSecond,
                                      colorText: CoreColors.textPrimary,
                                      text: state.status == ListItemLoading()
                                          ? 'Carregando... '
                                          : "Mostrar Excluídos",
                                      onPressed: _canSubmit
                                          ? () async {
                                              await listItemController
                                                  .authenticateTrashMode(
                                                pinOrEmailAndPassword:
                                                    _pinOrEmailAndPassword,
                                                pin: pinController.text,
                                                email: emailController.text,
                                                password:
                                                    passwordController.text,
                                              );
                                            }
                                          : null,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
