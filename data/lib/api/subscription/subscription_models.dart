
import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_models.freezed.dart';

@freezed
class SubscriptionPlan with _$SubscriptionPlan {
  const factory SubscriptionPlan({
    required String id,
    required String name,
    required String planDetail,
    required  String planInfo
  }) = _SubscriptionPlan;
}