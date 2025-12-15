// Репозитории определяются в settings.gradle.kts через dependencyResolutionManagement.
// Здесь не держим buildscript/allprojects repositories, чтобы не конфликтовать с настройками.

val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    project.layout.buildDirectory.value(newBuildDir.dir(project.name))
    project.evaluationDependsOn(":app")
}


tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
