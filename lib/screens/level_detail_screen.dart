import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_course/providers/lessons_provider.dart';
import 'package:online_course/theme/color.dart';

class LevelDetailScreen extends ConsumerWidget {
  final int levelId;
  const LevelDetailScreen({Key? key, required this.levelId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonsAsync = ref.watch(lessonsProvider(levelId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Уроки уровня'),
        backgroundColor: AppColor.appBarColor,
      ),
      backgroundColor: AppColor.appBgColor,
      body: Column(
        children: [
          Expanded(
            child: lessonsAsync.when(
              data: (lessons) {
                if (lessons.isEmpty) {
                  return const Center(child: Text('Уроки отсутствуют'));
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  itemCount: lessons.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final lesson = lessons[index];
                    return Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.shadowColor.withOpacity(0.05),
                            blurRadius: 1,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Text(
                        lesson.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColor.textColor,
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) =>
                  Center(child: Text('Ошибка: ${error.toString()}')),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // TODO: implement complete level logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Уровень завершён (заглушка)')),
                    );
                  },
                  child: const Text('Завершить уровень'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
