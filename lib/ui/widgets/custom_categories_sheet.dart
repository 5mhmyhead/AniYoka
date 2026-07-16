import 'package:aniyoka/app/app.locator.dart';
import 'package:aniyoka/services/category_service.dart';
import 'package:aniyoka/ui/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class _CategoryEdit {
  final String? original;
  String current;

  _CategoryEdit({this.original, required this.current});
}

Future<List<String>> showCustomCategoriesSheet(BuildContext context) async {
  final categoryService = locator<CategoryService>();
  final existing = await categoryService.getCategories();

  if (!context.mounted) return [];

  final workingCategories =
      existing.map((c) => _CategoryEdit(original: c, current: c)).toList();
  final toDelete = <String>[];
  final newlyAdded = <String>[];

  await showModalBottomSheet(
    context: context,
    backgroundColor: kcSurfaceColor,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => StatefulBuilder(
      builder: (context, setSheetState) {
        Future<void> addCategory() async {
          final name =
              await _showCategoryNameDialog(context, title: 'Add Category');
          if (name == null || name.trim().isEmpty) return;
          setSheetState(() {
            workingCategories.add(_CategoryEdit(current: name.trim()));
          });
        }

        Future<void> renameCategory(_CategoryEdit edit) async {
          final name = await _showCategoryNameDialog(
            context,
            title: 'Rename Category',
            initialValue: edit.current,
          );
          if (name == null || name.trim().isEmpty) return;
          setSheetState(() => edit.current = name.trim());
        }

        void deleteCategory(_CategoryEdit edit) {
          setSheetState(() {
            if (edit.original != null) toDelete.add(edit.original!);
            workingCategories.remove(edit);
          });
        }

        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 40,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    width: 60,
                    height: 4,
                    decoration: BoxDecoration(
                      color: kcLightGrey,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  'Custom Categories',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    color: kcPrimaryPink,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                ...workingCategories.map((edit) => Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              edit.current,
                              style: GoogleFonts.nunito(
                                color: kcOffWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => renameCategory(edit),
                            child: Container(
                              width: 40,
                              height: 40,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: const BoxDecoration(
                                color: kcBackgroundColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.edit,
                                  color: kcLightGrey, size: 18),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => deleteCategory(edit),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: kcBackgroundColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.delete_outline,
                                  color: kcPrimaryPink, size: 18),
                            ),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: addCategory,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Add Category...',
                            style: GoogleFonts.nunito(
                              color: kcLightGrey,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: kcBackgroundColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add,
                              color: kcLightGrey, size: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: kcBackgroundColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            'Cancel',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(
                              color: kcLightGrey,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          for (final name in toDelete) {
                            await categoryService.deleteCategory(name);
                          }
                          for (final edit in workingCategories) {
                            if (edit.original == null) {
                              await categoryService.addCategory(edit.current);
                              newlyAdded.add(edit.current);
                            } else if (edit.original != edit.current) {
                              await categoryService.renameCategory(
                                  edit.original!, edit.current);
                            }
                          }
                          if (context.mounted) Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: kcPrimaryPink,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            'Save Changes',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(
                              color: kcOffWhite,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
  return newlyAdded;
}

Future<String?> _showCategoryNameDialog(
  BuildContext context, {
  required String title,
  String initialValue = '',
}) {
  final controller = TextEditingController(text: initialValue);

  return showDialog<String>(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: kcSurfaceColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.nunito(
                color: kcPrimaryPink,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'Category Name',
              style: GoogleFonts.nunito(
                color: kcLightGrey,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: controller,
              autofocus: false,
              cursorColor: kcPrimaryPink,
              style: GoogleFonts.inter(
                color: kcOffWhite,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: kcDarkPink,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                hintText: 'Enter name...',
                hintStyle: GoogleFonts.inter(color: kcLightGrey, fontSize: 15),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: kcLightGrey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide:
                      const BorderSide(color: kcPrimaryPink, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kcBackgroundColor,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                  ),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.nunito(
                      color: kcLightGrey,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.pop(context, controller.text.trim()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kcPrimaryPink,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                  ),
                  child: Text(
                    'Save',
                    style: GoogleFonts.nunito(
                      color: kcOffWhite,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
