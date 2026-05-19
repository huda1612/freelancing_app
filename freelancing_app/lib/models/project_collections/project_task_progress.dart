class ProjectTaskProgress {
  final int done;
  final int total;

  const ProjectTaskProgress({required this.done, required this.total});

  String get label {
    if (total == 0) return '0 / 0';
    return '$done / $total';
  }
}
