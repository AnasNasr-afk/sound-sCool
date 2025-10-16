plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services") // ✅ Firebase / Google Sign-In support
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.anasnasr.soundscool"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.anasnasr.soundscool"
        minSdk = flutter.minSdkVersion // ✅ Required for flutter_local_notifications
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }

    // ✅ Enable Java 8+ compatibility + core library desugaring
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "11"
    }
}

flutter {
    source = "../.."
}

dependencies {
    // ✅ Fix for flutter_local_notifications
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")

    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")

    // ✅ Optional but recommended for large apps
    implementation("androidx.multidex:multidex:2.0.1")

    // ✅ Firebase + Google Sign-In (optional)
    implementation("com.google.android.gms:play-services-auth:21.0.1")
    implementation(platform("com.google.firebase:firebase-bom:33.1.2"))
    implementation("com.google.firebase:firebase-auth")
}
