import 'package:shared_preferences/shared_preferences.dart';

class ReferralStorage {
  static const String _pendingReferralKey = 'pending_referral_code';
  static const String _pendingPromoKey = 'pending_promo_code';

  static String? normalizeCode(String? raw) {
    if (raw == null) return null;
    final cleaned = raw.trim().replaceAll(' ', '').toUpperCase();
    return cleaned.isEmpty ? null : cleaned;
  }

  static Future<void> savePendingReferralCode(String code) async {
    final normalized = normalizeCode(code);
    if (normalized == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pendingReferralKey, normalized);
  }

  static Future<void> savePendingPromoCode(String code) async {
    final normalized = normalizeCode(code);
    if (normalized == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pendingPromoKey, normalized);
  }

  static Future<String?> getPendingReferralCode() async {
    final prefs = await SharedPreferences.getInstance();
    return normalizeCode(prefs.getString(_pendingReferralKey));
  }

  static Future<void> clearPendingReferralCode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pendingReferralKey);
  }

  static Future<String?> getPendingPromoCode() async {
    final prefs = await SharedPreferences.getInstance();
    return normalizeCode(prefs.getString(_pendingPromoKey));
  }

  static Future<void> clearPendingPromoCode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pendingPromoKey);
  }
}
