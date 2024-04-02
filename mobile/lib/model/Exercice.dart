class Exercice {
  int? id;
  String? name;
  String? description;
  String? groupe;
  String? type;

  Exercice({ required this.name, this.description, this.groupe, this.type });

  Exercice.fromJson(Map<String, dynamic> map){
    id = map['id'];
    name = map['name'];
    description = map['description'];
    groupe = map['groupe'];
    type = map['type'];
  }

  Map<String, dynamic> toJson() => {
    'name' : name,
    'description' : description,
    'groupe' : groupe,
    'type' : type
  };

}