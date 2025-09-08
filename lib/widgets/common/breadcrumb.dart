import 'package:flutter/material.dart';

class BreadcrumbItem {
  final String label;
  final VoidCallback? onTap;
  final bool isCurrent;
  BreadcrumbItem({required this.label, this.onTap, this.isCurrent = false});
}

class Breadcrumb extends StatelessWidget {
  final List<BreadcrumbItem> items;
  final EdgeInsetsGeometry padding;
  final double separatorSpacing;

  const Breadcrumb(
      {super.key,
      required this.items,
      this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      this.separatorSpacing = 6});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final children = <Widget>[];
    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final isLast = i == items.length - 1;
      final text = Text(
        item.label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: isLast || item.isCurrent
            ? theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)
            : theme.textTheme.bodyMedium?.copyWith(color: Colors.blueAccent),
      );
      final widget = item.onTap != null && !isLast
          ? InkWell(onTap: item.onTap, child: text)
          : text;
      children.add(Flexible(child: widget));
      if (!isLast) {
        children.add(SizedBox(width: separatorSpacing));
        children.add(const Text('›', style: TextStyle(color: Colors.grey)));
        children.add(SizedBox(width: separatorSpacing));
      }
    }

    return Semantics(
      label: 'Навигационная цепочка',
      child: Padding(
        padding: padding,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        ),
      ),
    );
  }
}
