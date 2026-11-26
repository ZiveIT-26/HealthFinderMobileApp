import 'package:material_ui/material_ui.dart';

import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/card_tile.dart';
import '../../../../core/widgets/grouped_card.dart';
import '../../../../core/widgets/section_title.dart';

/// One list of the medical card (allergies, contacts...): title with an
/// "add" button and a card with one row per item, or "Nothing added".
class MedicalListSection extends StatelessWidget {
  const MedicalListSection({super.key, required this.title, required this.items});

  final String title;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 10,
      children: [
        SectionTitle(
          title,
          // Same button as "New chat" in the chat header.
          // TODO: open the add form once list items are editable.
          trailing: AppButton.icon(Icons.add, onTap: () {}, tooltip: 'Add'),
        ),
        GroupedCard(
          children: items.isEmpty ? const [EmptyCardTile()] : items,
        ),
      ],
    );
  }
}
