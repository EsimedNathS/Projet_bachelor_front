class Programme {
  int? id;
  String? name;
  String? day;
  bool? favori;
  int? IDUser;

  Programme({ required this.name, this.day, this.favori, this.IDUser, this.id = null });

  Programme.fromJson(Map<String, dynamic> map){
    id = map['id'];
    name = map['name'];
    day = map['day'];
    favori = map['favori'];
    IDUser = map['IDUser'];
  }

  Map<String, dynamic> toJson() => {
    'name' : name,
    'day' : day,
    'favori' : favori,
    'IDUser' : IDUser
  };

}