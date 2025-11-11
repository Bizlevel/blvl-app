int videoPageFor(int lessonIndex) => 1 + lessonIndex * 2;
int quizPageFor(int lessonIndex) => videoPageFor(lessonIndex) + 1;

