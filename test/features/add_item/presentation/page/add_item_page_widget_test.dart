import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/constants/core_keys.dart';
import 'package:lockpass/core/navigation/app_routes.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/features/add_item/domain/usecases/create_item_usecase.dart';
import 'package:lockpass/features/add_item/domain/usecases/load_item_groups_usecase.dart';
import 'package:lockpass/features/add_item/presentation/controller/add_item_controller.dart';
import 'package:lockpass/features/add_item/presentation/page/add_item_page.dart';
import 'package:lockpass/features/add_item/presentation/state/add_item_state.dart';
import 'package:lockpass/features/add_item/presentation/state/add_item_status.dart';

import '../../../../test_utils/widget_test_pump.dart';

class _FakeCreateItemUseCase implements CreateItemUseCase {
  @override
  Future<void> call(ItensEntity item, List<String> existingGroups) async {}
}

class _FakeLoadItemGroupsUseCase implements LoadItemGroupsUseCase {
  _FakeLoadItemGroupsUseCase(this.groups);
  final List<String> groups;

  @override
  Future<List<String>> call() async => groups;
}

class _TestAddItemController extends AddItemController {
  _TestAddItemController({
    List<String> dropDownGroups = const <String>[],
    this.emitSuccessOnSubmit = false,
  })  : _dropDownGroups = dropDownGroups,
        super(
          createItemUseCase: _FakeCreateItemUseCase(),
          loadItemGroupsUseCase: _FakeLoadItemGroupsUseCase(dropDownGroups),
          minSubmitDuration: Duration.zero,
          delay: (_) async {},
        );

  final List<String> _dropDownGroups;
  final bool emitSuccessOnSubmit;

  int submitCalls = 0;
  ItensEntity? lastSubmittedItem;

  @override
  Future<void> setDropDownGroups() async {
    if (_dropDownGroups.isNotEmpty) {
      emit(state.copyWith(listItensDrop: _dropDownGroups));
    }
  }

  @override
  Future<void> submit(ItensEntity item) async {
    submitCalls += 1;
    lastSubmittedItem = item;
    if (emitSuccessOnSubmit) {
      emit(state.copyWith(status: const AddItemSuccess()));
    }
  }

  void seed(AddItemState seed) => emit(seed);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget _app(Widget home) {
    return MaterialApp(
      routes: {
        AppRoutes.home: (_) => const Scaffold(
              body: Text('HOME', key: Key('home-page')),
            ),
      },
      home: home,
    );
  }

  Finder _saveButton() {
    return find.descendant(
      of: find.byKey(CoreKeys.buttonCustomCreateItem),
      matching: find.byType(ElevatedButton),
    );
  }

  group('AddItemPage (widget)', () {
    testWidgets('save button starts disabled and enables after filling required fields', (tester) async {
      final controller = _TestAddItemController();
      addTearDown(controller.close);

      await tester.pumpWidget(_app(AddItemPage(controller: controller)));
      await tester.pump();

      ElevatedButton button = tester.widget(_saveButton());
      expect(button.onPressed, isNull);

      // Text fields order: group, service, site, email, login, password.
      await tester.enterText(find.byType(TextFormField).at(0), 'Email');
      await tester.enterText(find.byType(TextFormField).at(1), 'Gmail');
      await tester.enterText(find.byType(TextFormField).at(4), 'user@gmail.com');
      await tester.enterText(find.byType(TextFormField).at(5), 'secret');
      await tester.pump();

      button = tester.widget(_saveButton());
      expect(button.onPressed, isNotNull);
    });

    testWidgets('invalid optional email prevents submit (form validator)', (tester) async {
      final controller = _TestAddItemController();
      addTearDown(controller.close);

      await tester.pumpWidget(_app(AddItemPage(controller: controller)));
      await tester.pump();

      await tester.enterText(find.byType(TextFormField).at(0), 'Email');
      await tester.enterText(find.byType(TextFormField).at(1), 'Gmail');
      await tester.enterText(find.byType(TextFormField).at(3), 'invalid-email');
      await tester.enterText(find.byType(TextFormField).at(4), 'user@gmail.com');
      await tester.enterText(find.byType(TextFormField).at(5), 'secret');
      await tester.pump();

      await tester.ensureVisible(_saveButton());
      await tester.tap(_saveButton());
      await tester.pump();

      expect(controller.submitCalls, 0);
    });

    testWidgets('submits trimmed values and nulls optional fields when empty', (tester) async {
      final controller = _TestAddItemController();
      addTearDown(controller.close);

      await tester.pumpWidget(_app(AddItemPage(controller: controller)));
      await tester.pump();

      await tester.enterText(find.byType(TextFormField).at(0), '  Email  ');
      await tester.enterText(find.byType(TextFormField).at(1), '  Gmail  ');
      await tester.enterText(find.byType(TextFormField).at(2), '   '); // site -> null
      await tester.enterText(find.byType(TextFormField).at(3), '   '); // email -> null
      await tester.enterText(find.byType(TextFormField).at(4), '  user@gmail.com  ');
      await tester.enterText(find.byType(TextFormField).at(5), '  secret  ');
      await tester.pump();

      await tester.ensureVisible(_saveButton());
      await tester.tap(_saveButton());
      await tester.pump();

      final submitted = controller.lastSubmittedItem;
      expect(submitted, isNotNull);
      expect(submitted!.group, 'Email');
      expect(submitted.service, 'Gmail');
      expect(submitted.site, isNull);
      expect(submitted.email, isNull);
      expect(submitted.login, 'user@gmail.com');
      expect(submitted.password, 'secret');
    });

    testWidgets('navigates to home when controller emits AddItemSuccess', (tester) async {
      final controller = _TestAddItemController(emitSuccessOnSubmit: true);
      addTearDown(controller.close);

      await tester.pumpWidget(_app(AddItemPage(controller: controller)));
      await tester.pump();

      await tester.enterText(find.byType(TextFormField).at(0), 'Email');
      await tester.enterText(find.byType(TextFormField).at(1), 'Gmail');
      await tester.enterText(find.byType(TextFormField).at(4), 'user@gmail.com');
      await tester.enterText(find.byType(TextFormField).at(5), 'secret');
      await tester.pump();

      await tester.ensureVisible(_saveButton());
      await tester.tap(_saveButton());
      await pumpModal(tester);
      await flushToasts(tester);

      expect(find.byKey(const Key('home-page')), findsOneWidget);
    });

    testWidgets('dropdown shows when groups are available and selecting updates group field', (tester) async {
      final controller = _TestAddItemController(dropDownGroups: const ['Email', 'Social']);
      addTearDown(controller.close);

      await tester.pumpWidget(_app(AddItemPage(controller: controller)));
      await tester.pump(); // initState calls setDropDownGroups()
      await tester.pump();

      expect(find.byKey(CoreKeys.dropDownAddItem), findsOneWidget);

      // Open dropdown and select "Social".
      await tester.tap(find.byKey(CoreKeys.dropDownAddItem));
      await pumpModal(tester);
      await tester.tap(find.text('Social').last);
      await pumpModal(tester);

      final groupField = tester.widget<TextFormField>(find.byType(TextFormField).at(0));
      expect(groupField.controller?.text, 'Social');
    });
  });
}
