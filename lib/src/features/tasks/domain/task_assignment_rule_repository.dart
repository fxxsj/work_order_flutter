abstract class TaskAssignmentRuleRepository {
  Future<Map<String, dynamic>> preview({Map<String, dynamic>? params});

  Future<Map<String, dynamic>> getGlobalState();

  Future<Map<String, dynamic>> setGlobalState(bool enabled);
}
