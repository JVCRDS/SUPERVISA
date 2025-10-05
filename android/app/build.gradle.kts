plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // ✅ Firebase
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.flutter_application_1"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.flutter_application_1"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true // ✅ ADICIONE ESTA LINHA (IMPORTANTE!)
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// ✅ ADICIONE ESTA SEÇÃO DE DEPENDÊNCIAS:
dependencies {
    implementation("androidx.multidex:multidex:2.0.1") // ✅ MULTIDEX OBRIGATÓRIO
    implementation(platform("com.google.firebase:firebase-bom:32.7.0")) // ✅ FIREBASE BOM
    implementation("com.google.firebase:firebase-analytics") // ✅ ANALYTICS
}