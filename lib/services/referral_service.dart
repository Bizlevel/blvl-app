import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:bizlevel/services/referral_storage.dart';

class ReferralFailure implements Exception {
  final String message;
  ReferralFailure(this.message);
  @override
  String toString() => 'ReferralFailure: $message';
}

class PromoFailure implements Exception {
  final String message;
  PromoFailure(this.message);
  @override
  String toString() => 'PromoFailure: $message';
}

class ReferralService {
  ReferralService(this._client);

  final SupabaseClient _client;

  Future<String> getMyReferralCode() async {
    try {
      final data = await _client.rpc('get_referral_code');
      final code = _asString(data);
      if (code == null || code.isEmpty) {
        throw ReferralFailure('Не удалось получить код приглашения');
      }
      return code;
    } on PostgrestException catch (e) {
      throw ReferralFailure(_mapReferralError(e.message));
    }
  }

  Future<bool> applyReferralCode(String code) async {
    final normalized = ReferralStorage.normalizeCode(code);
    if (normalized == null) {
      throw ReferralFailure('Введите корректный код');
    }
    try {
      final data = await _client
          .rpc('apply_referral_code', params: {'p_code': normalized});
      final applied = _asBool(data);
      return applied ?? true;
    } on PostgrestException catch (e) {
      throw ReferralFailure(_mapReferralError(e.message));
    }
  }

  Future<int> redeemPromoCode(String code) async {
    final normalized = ReferralStorage.normalizeCode(code);
    if (normalized == null) {
      throw PromoFailure('Введите корректный промокод');
    }
    try {
      final data = await _client
          .rpc('redeem_promo_code', params: {'p_code': normalized});
      final balance = _asBalanceAfter(data);
      if (balance == null) {
        throw PromoFailure('Промокод применён, но баланс не обновился');
      }
      return balance;
    } on PostgrestException catch (e) {
      throw PromoFailure(_mapPromoError(e.message));
    }
  }

  Future<void> applyPendingCodesBestEffort() async {
    try {
      final referral = await ReferralStorage.getPendingReferralCode();
      if (referral != null) {
        await applyReferralCode(referral);
        await ReferralStorage.clearPendingReferralCode();
      }
    } catch (_) {}
    try {
      final promo = await ReferralStorage.getPendingPromoCode();
      if (promo != null) {
        await redeemPromoCode(promo);
        await ReferralStorage.clearPendingPromoCode();
      }
    } catch (_) {}
  }

  String? _asString(dynamic data) {
    if (data is String) return data;
    if (data is List && data.isNotEmpty) {
      final first = data.first;
      if (first is String) return first;
      if (first is Map) {
        final v = first['get_referral_code'];
        if (v is String) return v;
      }
    }
    return null;
  }

  bool? _asBool(dynamic data) {
    if (data is bool) return data;
    if (data is List && data.isNotEmpty) {
      final first = data.first;
      if (first is bool) return first;
      if (first is Map) {
        final v = first['apply_referral_code'];
        if (v is bool) return v;
      }
    }
    return null;
  }

  int? _asBalanceAfter(dynamic data) {
    if (data is int) return data;
    if (data is num) return data.toInt();
    if (data is List && data.isNotEmpty) {
      final first = data.first;
      if (first is Map) {
        final v = first['balance_after'];
        if (v is num) return v.toInt();
      }
    }
    return null;
  }

  String _mapReferralError(String message) {
    if (message.contains('referral_invalid_code')) {
      return 'Код приглашения не найден';
    }
    if (message.contains('referral_self')) {
      return 'Нельзя использовать свой код приглашения';
    }
    if (message.contains('referral_already_applied')) {
      return 'Код приглашения уже применён';
    }
    if (message.contains('referral_code_generation_failed')) {
      return 'Не удалось сгенерировать код, попробуйте позже';
    }
    return 'Не удалось применить код приглашения';
  }

  String _mapPromoError(String message) {
    if (message.contains('promo_invalid_code')) {
      return 'Промокод не найден';
    }
    if (message.contains('promo_expired')) {
      return 'Срок действия промокода истёк';
    }
    if (message.contains('promo_exhausted')) {
      return 'Лимит промокода исчерпан';
    }
    if (message.contains('promo_already_used')) {
      return 'Промокод уже использован';
    }
    return 'Не удалось применить промокод';
  }
}
