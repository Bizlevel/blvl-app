import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bizlevel/models/user_skill_model.dart';
import 'package:bizlevel/providers/user_skills_provider.dart';

void main() {
  test('userSkillsProvider отражает инкремент очков после инвалидации',
      () async {
    // Имитация состояния очков для одного навыка (skill_id=2)
    int currentPoints = 0;

    // Подготовим фабрику данных на основе текущего значения очков
    Future<List<UserSkillModel>> fakeFetch() async {
      return [
        UserSkillModel(
          userId: 'uid',
          skillId: 2,
          skillName: 'Денежный контроль',
          points: currentPoints,
        ),
      ];
    }

    // Переопределяем провайдер навыков на фейковую реализацию
    final container = ProviderContainer(
      overrides: [
        userSkillsProvider.overrideWith((ref) async => fakeFetch()),
      ],
    );
    addTearDown(container.dispose);

    // 1) Изначально очки = 0
    final before = await container.read(userSkillsProvider.future);
    expect(before, hasLength(1));
    expect(before.first.skillId, 2);
    expect(before.first.points, 0);

    // 2) «После completeLevel»: инкремент очков и инвалидация провайдера
    currentPoints = 1;
    container.invalidate(userSkillsProvider);

    final after = await container.read(userSkillsProvider.future);
    expect(after.first.points, 1);
  });
}
