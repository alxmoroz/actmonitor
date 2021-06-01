// Copyright (c) 2021. Alexandr Moroz

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//TODO: рефакторинг

import '../separator.dart';
import 'checkbox_circle.dart';

class SelectionItem {
  const SelectionItem({required this.view, required this.onSelect, this.alreadySelected = false});

  final Widget view;
  final VoidCallback onSelect;
  final bool alreadySelected;
}

class SingleVariantSelection extends StatelessWidget {
  const SingleVariantSelection(this.items, {required this.selectedIndex, this.hasDivider = false});

  @protected
  final List<SelectionItem> items;
  @protected
  final int selectedIndex;
  @protected
  final bool hasDivider;

  Widget _wrapItemWithRadio(int index) {
    final isSelected = index == selectedIndex;
    return GestureDetector(
      onTap: () => _changeSelection(index),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? CupertinoColors.activeBlue.withOpacity(0.09) : Colors.transparent,
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CheckboxCircle(isActive: selectedIndex == index, alreadySelected: items[index].alreadySelected),
            const SizedBox(width: 8),
            Expanded(child: items[index].view),
          ],
        ),
      ),
    );
  }

  void _changeSelection(int index) {
    items[index].onSelect();
  }

  List<Widget> _fetchItems() {
    int i = 0;

    return items.fold(<Widget>[], (array, e) {
      array.add(_wrapItemWithRadio(i++));
      if (hasDivider) {
        array.add(const Separator(height: 6));
      }
      return array;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          ..._fetchItems(),
        ],
      ),
    );
  }
}
