import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';
import 'page_header.dart';

/// Inner page opened above the bottom navigation: back button with [title]
/// and the page [body], usually a `SectionList`. [action] sits at the right
/// end of the header, e.g. a "Save" button.
class DetailPage extends StatelessWidget {
  const DetailPage({
    super.key,
    required this.title,
    required this.body,
    this.action,
  });

  final String title;
  final Widget body;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: PageHeader(title: title)),
                if (action case final action?)
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.l, bottom: 5),
                    child: action,
                  ),
              ],
            ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}
