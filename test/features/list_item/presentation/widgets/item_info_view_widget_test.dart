import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/features/list_item/presentation/enums/list_view_mode_enum.dart';
import 'package:lockpass/features/list_item/presentation/widgets/item_info_view_widget.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget _app(Widget child) => MaterialApp(home: Scaffold(body: child));

  group('ItemInfoViewWidget (widget)', () {
    testWidgets('shows password row in list mode and toggles callback', (tester) async {
      var toggled = false;
      const item = ItensEntity(
        userId: 'u',
        id: 1,
        group: 'Email',
        service: 'Gmail',
        site: 'https://gmail.com',
        email: 'user@gmail.com',
        login: 'user@gmail.com',
        password: 'secret',
      );

      await tester.pumpWidget(
        _app(
          ItemInfoViewWidget(
            item: item,
            showPassword: false,
            password: 'secret',
            listMode: ListViewModeEnum.list,
            onTogglePassword: () => toggled = true,
          ),
        ),
      );

      expect(find.text(CoreStrings.password), findsOneWidget);
      expect(find.text(CoreStrings.obscurePassword), findsOneWidget);

      await tester.tap(find.byType(IconButton));
      await tester.pump();

      expect(toggled, isTrue);
    });

    testWidgets('hides password row in trash mode', (tester) async {
      const item = ItensEntity(
        userId: 'u',
        id: 1,
        group: 'Email',
        service: 'Gmail',
        login: 'user@gmail.com',
        password: 'secret',
      );

      await tester.pumpWidget(
        _app(
          ItemInfoViewWidget(
            item: item,
            showPassword: false,
            password: 'secret',
            listMode: ListViewModeEnum.trash,
            onTogglePassword: () {},
          ),
        ),
      );

      expect(find.text(CoreStrings.password), findsNothing);
      expect(find.byType(IconButton), findsNothing);
    });

    testWidgets('shows "not informed" for blank/empty fields', (tester) async {
      const item = ItensEntity(
        userId: 'u',
        id: 1,
        group: '',
        service: '',
        site: null,
        email: null,
        login: '',
        password: 'secret',
      );

      await tester.pumpWidget(
        _app(
          ItemInfoViewWidget(
            item: item,
            showPassword: true,
            password: 'secret',
            listMode: ListViewModeEnum.list,
            onTogglePassword: () {},
          ),
        ),
      );

      expect(find.text(CoreStrings.notInformed), findsAtLeastNWidgets(4));
    });
  });
}

