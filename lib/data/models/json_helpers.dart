extension JsonMapReader on Map<String, dynamic> {
  Map<String, dynamic> object(String key) => this[key] as Map<String, dynamic>;

  List<Map<String, dynamic>> objectList(String key) => (this[key] as List).cast<Map<String, dynamic>>();

  double decimal(String key) => (this[key] as num).toDouble();
}
