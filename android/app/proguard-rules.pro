# ProGuard rules for BizLevel release build
# Keep Flutter classes
-keep class io.flutter.** { *; }
-keep class com.sangvaleap.online_course.** { *; }
# Keep Supabase generated models
-keep class com.supabase.** { *; }
# Keep Gson / JSON annotations
-keepattributes *Annotation* 