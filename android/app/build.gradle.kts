plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // Firebase plugin
}

android {
    namespace = "com.example.book_store_app"

    // ✅ Updated SDK and NDK to satisfy all plugins
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.book_store_app"
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = 1
        versionName = "1.0.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

   buildTypes {
    getByName("release") {
        signingConfig = signingConfigs.getByName("debug")
        isMinifyEnabled = false
        isShrinkResources = false  // ✅ Correct way in Kotlin DSL
    }
 }
}

flutter {
    source = "../.."
}

dependencies {
    // ✅ Firebase BOM
    implementation(platform("com.google.firebase:firebase-bom:34.2.0"))

    // ✅ Firebase products
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-firestore")

    // Other dependencies required by Flutter plugins
    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("androidx.core:core-ktx:1.10.1")
}
