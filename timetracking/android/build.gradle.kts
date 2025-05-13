buildscript {
    repositories {
        google()
        mavenCentral()
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }

//     tasks.withType<JavaCompile> {
//         options.compilerArgs.addAll(listOf("-Xlint:unchecked", "-Xlint:deprecation"))
//         // Add specific flag to help resolve ambiguous method calls
//         options.compilerArgs.add("-Xprefer:source,newer")
//     }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// Removed duplicate clean task
