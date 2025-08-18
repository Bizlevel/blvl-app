import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bizlevel/theme/color.dart';

class BizTowerScreen extends ConsumerWidget {
  const BizTowerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Башня БизЛевел'),
        backgroundColor: AppColor.appBarColor,
      ),
      backgroundColor: AppColor.appBgColor,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _FloorTile(
            title: 'Этаж 0: Ресепшн',
            trailing: const Icon(Icons.check, color: Colors.green),
            onTap: () {},
          ),
          _FloorTile(
            title: 'Этаж 1: База предпринимательства',
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/floor/1'),
          ),
          const _FloorTile(
            title: 'Этаж 2: Продажи',
            trailing: Icon(Icons.lock_outline),
          ),
          const _FloorTile(
            title: 'Этаж 3: Команда',
            trailing: Icon(Icons.lock_outline),
          ),
          const _FloorTile(
            title: 'Этаж 4: Масштабирование',
            trailing: Icon(Icons.lock_outline),
          ),
        ],
      ),
    );
  }
}

class _FloorTile extends StatelessWidget {
  final String title;
  final Widget trailing;
  final VoidCallback? onTap;
  const _FloorTile({required this.title, required this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}


