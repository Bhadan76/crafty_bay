plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
    // END: FlutterFire Configuration
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.crafty_bay"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    signingConfigs {
        create("customDebug") {
            storeFile = file("E:/crafty_bay/crafty-bay-new.jks")
            storePassword = "123456"
            keyAlias = "crafty-bay"
            keyPassword = "123456"
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.crafty_bay"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Enable multidex for better memory management on older devices
        multiDexEnabled = true

        // Reduce app size by enabling resource shrinking at build time
        // This removes unused resources from the final APK
        resourceConfigurations += setOf("en", "bn")
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    buildTypes {
        debug {
            signingConfig = signingConfigs.getByName("customDebug")
            // Enable code shrinking for debug builds to catch issues early
            isMinifyEnabled = false
            isShrinkResources = false
        }

        release {
            signingConfig = signingConfigs.getByName("customDebug")
            // Enable code and resource shrinking for release builds
            isMinifyEnabled = true
            isShrinkResources = true
            // ProGuard rules for further optimization
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

//kotlin {
//    compilerOptions {
//        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
//    }
//}

flutter {
    source = "../.."
}
