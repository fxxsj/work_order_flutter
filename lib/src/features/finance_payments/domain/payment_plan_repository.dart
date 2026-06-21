/// 收款计划仓库抽象，封装列表外的状态变更等操作。
abstract class PaymentPlanRepository {
  Future<void> updateStatus(int id);
}
