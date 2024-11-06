import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:data/api/subscription/subscription_models.dart';

part 'subscription_view_model.freezed.dart';

const freePlan = "free_plan";
const proPlan = "pro_plan";

final subscriptionViewProvider = StateNotifierProvider.autoDispose<
    SubscriptionViewNotifier, SubscriptionState>(
  (ref) => SubscriptionViewNotifier(),
);

class SubscriptionViewNotifier extends StateNotifier<SubscriptionState> {
  SubscriptionViewNotifier() : super(const SubscriptionState()) {
    _setData();
  }

  void _setData() {
    final plans = [
      const SubscriptionPlan(
          id: freePlan,
          name: "Free",
          planDetail: "100 call/month",
          planInfo: "Basic plan"),
      const SubscriptionPlan(
          id: proPlan,
          name: "Pro",
          planDetail: "\u{20B9}200 /month",
          planInfo: "Unlimited or higher threshold")
    ];
    state = state.copyWith(plans: plans, selectedPlan: plans.first);
  }

  void onSelectPlan(SubscriptionPlan plan) {
    state = state.copyWith(selectedPlan: plan);
  }
}

@freezed
class SubscriptionState with _$SubscriptionState {
  const factory SubscriptionState({
    @Default(false) bool loading,
    SubscriptionPlan? selectedPlan,
    @Default([]) List<SubscriptionPlan> plans,
  }) = _SubscriptionState;
}
