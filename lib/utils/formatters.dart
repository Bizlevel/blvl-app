String formatLevelCode(int floorId, int levelNumber) {
  if (levelNumber == 0) {
    return 'Ресепшн';
  }
  final code = (floorId * 100) + levelNumber;
  return code.toString();
}
