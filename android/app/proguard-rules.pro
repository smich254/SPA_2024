# Add general project-specific ProGuard rules here.
# By default, the flags in this file are appended to flags specified
# in your project. If you want to replace the default ProGuard flags, use
# the -include directive to point to your custom file.

# Flutter's ProGuard configuration.
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }

# Keep Firebase classes
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Keep Google Sign-in classes
-keep class com.google.android.gms.auth.api.signin.** { *; }
-keep class com.google.api.client.extensions.** { *; }
-keep class com.google.api.client.googleapis.** { *; }
-keep class com.google.api.client.json.gson.** { *; }
