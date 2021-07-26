abstract class Model {
  int? getId();

  void setId(int v);

  Model.fromMap(Map<String, dynamic> map);

  Map<String, dynamic> toMap();
}
