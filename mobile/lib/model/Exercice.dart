class Exercice {
  int? id;
  String? name;
  String? description;
  String? groupe;
  String? type;
  bool? isFavourite;

  Exercice({ required this.name, this.description, this.groupe, this.type });

  Exercice.fromJson(Map<dynamic, dynamic> map){
    id = map['id'];
    name = map['name'];
    description = map['description'];
    groupe = map['groupe'];
    type = map['type'];
    isFavourite = map['isFavourite'];
  }

  Map<dynamic, dynamic> toJson() => {
    'name' : name,
    'description' : description,
    'groupe' : groupe,
    'type' : type
  };

}