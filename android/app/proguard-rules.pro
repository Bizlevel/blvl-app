# ProGuard rules for BizLevel release build
# Keep Flutter classes
-keep class io.flutter.** { *; }
-keep class com.sangvaleap.online_course.** { *; }
# Keep Supabase SDK and generated models
-keep class io.supabase.** { *; }
-keep class com.supabase.** { *; }
# Keep Dio/OkHttp/Okio classes used via reflection
-keep class com.supabase.** { *; }
# Keep OkHttp3
-keep class okhttp3.** { *; }
-keep class okio.** { *; }
# Keep Dio
-keep class dio.** { *; }

# Keep Gson / JSON annotations
-keepattributes *Annotation* 