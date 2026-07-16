import 'package:aniyoka/ui/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchFilterHeader extends StatefulWidget {
  final String title;
  final List<String> sortOptions;
  final String selectedSort;
  final bool selectedSortAscending;
  final void Function(String sortLabel, bool ascending) onSortSelected;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchCleared;

  final List<String>? statusOptions;
  final Set<String>? selectedStatuses;
  final ValueChanged<Set<String>>? onStatusesChanged;

  const SearchFilterHeader({
    super.key,
    required this.title,
    required this.sortOptions,
    required this.selectedSort,
    this.selectedSortAscending = true,
    required this.onSortSelected,
    required this.onSearchChanged,
    required this.onSearchCleared,
    this.statusOptions,
    this.selectedStatuses,
    this.onStatusesChanged,
  });

  @override
  State<SearchFilterHeader> createState() => _SearchFilterHeaderState();
}

class _SearchFilterHeaderState extends State<SearchFilterHeader> {
  final TextEditingController _controller = TextEditingController();
  bool _isSearching = false;

  bool get _hasStatusTab =>
      widget.statusOptions != null && widget.statusOptions!.isNotEmpty;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
    Widget build(BuildContext context) {
    return Container(
      color: kcSurfaceColor,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: SizedBox(
            height: 60,
            child: _isSearching ? _buildSearchBar() : _buildTitleRow(context)
          ),
        ),
      ),
    );
  }

  Widget _buildTitleRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.title,
            style: GoogleFonts.nunito(
              color: kcPrimaryPink,
              fontSize: 42,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        GestureDetector(
          onTap: () => setState(() => _isSearching = true),
          child: Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: kcBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.search, color: kcLightGrey, size: 20),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () => _showFilterSheet(context),
          child: Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: kcBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.sort, color: kcLightGrey, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() => _isSearching = false);
            _controller.clear();
            widget.onSearchCleared();
          },
          child: const Icon(Icons.arrow_back, color: kcOffWhite),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: _controller,
            autofocus: true,
            cursorColor: kcPrimaryPink,
            style: GoogleFonts.inter(color: kcOffWhite, fontSize: 16),
            autocorrect: false,
            enableSuggestions: false,
            decoration: InputDecoration(
              hintText: 'Search for an anime...',
              hintStyle: GoogleFonts.inter(color: kcLightGrey.withValues(alpha: 0.75)),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
            ),
            onChanged: widget.onSearchChanged,
          ),
        ),
        if (_controller.text.isNotEmpty)
          GestureDetector(
            onTap: () {
              _controller.clear();
              widget.onSearchCleared();
            },
            child: const Icon(Icons.close, color: kcLightGrey, size: 20),
          ),
      ],
    );
  }

  void _showFilterSheet(BuildContext context) {
    final hasStatusTab = _hasStatusTab;

    String tempSort = widget.selectedSort;
    bool tempAscending = widget.selectedSortAscending;
    Set<String> tempStatuses = {...(widget.selectedStatuses ?? const {})};

    void applyAndClose(BuildContext sheetContext) {
      Navigator.pop(sheetContext);
      widget.onSortSelected(tempSort, tempAscending);
      if (hasStatusTab) {
        widget.onStatusesChanged?.call(tempStatuses);
      }
    }

    void resetAndClose(BuildContext sheetContext, void Function(void Function()) setSheetState) {
      Navigator.pop(sheetContext);
      tempSort = widget.sortOptions.first;
      tempAscending = true;
      tempStatuses = {};
      widget.onSortSelected(tempSort, tempAscending);
      if (hasStatusTab) {
        widget.onStatusesChanged?.call(tempStatuses);
      }
    }

    Widget buildDragHandle() {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          width: 60,
          height: 4,
          decoration: BoxDecoration(
            color: kcLightGrey,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );
    }

    Widget buildActionButtons(BuildContext sheetContext, void Function(void Function()) setSheetState) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(sheetContext),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: kcBackgroundColor,
                  borderRadius: BorderRadius.circular(30),
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
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () => resetAndClose(sheetContext, setSheetState),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: kcBackgroundColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  'Reset',
                  style: GoogleFonts.nunito(
                    color: kcLightGrey,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => applyAndClose(sheetContext),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: kcPrimaryPink,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  'Apply',
                  style: GoogleFonts.nunito(
                    color: kcOffWhite,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget buildStatusList(void Function(void Function()) setSheetState) {
      return ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Filter by status',
            style: GoogleFonts.nunito(
              color: kcOffWhite,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ...widget.statusOptions!.map((option) {
            final isSelected = tempStatuses.contains(option);
            return GestureDetector(
              onTap: () => setSheetState(() {
                if (isSelected) {
                  tempStatuses.remove(option);
                } else {
                  tempStatuses.add(option);
                }
              }),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: isSelected ? kcPrimaryPink : kcBackgroundColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      option,
                      style: GoogleFonts.nunito(
                        color: isSelected ? kcOffWhite : kcLightGrey,
                        fontSize: 15,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check, color: kcOffWhite, size: 20),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
        ],
      );
    }

    Widget buildSortList(ScrollController? scrollController, void Function(void Function()) setSheetState) {
      return ListView(
        controller: scrollController,
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Sort by',
            style: GoogleFonts.nunito(
              color: kcOffWhite,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ...widget.sortOptions.map((option) {
            final isSelected = option == tempSort;
            return GestureDetector(
              onTap: () => setSheetState(() {
                if (isSelected) {
                  tempAscending = !tempAscending;
                } else {
                  tempSort = option;
                  tempAscending = true;
                }
              }),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: isSelected ? kcPrimaryPink : kcBackgroundColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      option,
                      style: GoogleFonts.nunito(
                        color: isSelected ? kcOffWhite : kcLightGrey,
                        fontSize: 15,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        tempAscending ? Icons.arrow_upward : Icons.arrow_downward,
                        color: kcOffWhite,
                        size: 20,
                      ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
        ],
      );
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: kcSurfaceColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheetState) {
          return DraggableScrollableSheet(
            initialChildSize: 0.75,
            minChildSize: 0.4,
            maxChildSize: 0.85,
            expand: false,
            builder: (context, scrollController) {
              if (!hasStatusTab) {
                return Column(
                  children: [
                    buildDragHandle(),
                    buildActionButtons(sheetContext, setSheetState),
                    const SizedBox(height: 12),
                    Expanded(child: buildSortList(scrollController, setSheetState)),
                  ],
                );
              }

              return DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    buildDragHandle(),
                    buildActionButtons(sheetContext, setSheetState),
                    const SizedBox(height: 12),
                    TabBar(
                      isScrollable: false,
                      labelColor: kcPrimaryPink,
                      unselectedLabelColor: kcLightGrey,
                      indicatorColor: kcPrimaryPink,
                      indicatorWeight: 2,
                      dividerColor: kcLightGrey.withValues(alpha: 0.5),
                      labelStyle: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600),
                      unselectedLabelStyle: GoogleFonts.nunito(fontSize: 16),
                      tabs: const [
                        Tab(text: 'Status'),
                        Tab(text: 'Sort'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          buildStatusList(setSheetState),
                          buildSortList(null, setSheetState),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}