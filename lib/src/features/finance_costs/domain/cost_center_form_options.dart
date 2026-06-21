class CostCenterFormOptions {
  const CostCenterFormOptions({
    required this.parents,
    required this.managers,
  });

  final List<CostCenterOption> parents;
  final List<CostCenterOption> managers;
}

class CostCenterOption {
  const CostCenterOption({this.id, required this.label});

  final int? id;
  final String label;
}
