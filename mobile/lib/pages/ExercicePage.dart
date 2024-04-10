import 'package:flutter/material.dart';
import 'package:mobile/Adds/FavoriStar.dart';
import 'package:mobile/components.dart';
import 'package:mobile/pages/FavoriPage.dart';
import 'package:mobile/pages/MyHomePage.dart';
import 'package:mobile/services/ExerciceRoutes.dart';
import 'package:mobile/services/LoginState.dart';
import 'package:mobile/model/Exercice.dart';
import 'package:mobile/model/Programme.dart';
import 'package:mobile/services/ProgrammeRoutes.dart';
import 'package:provider/provider.dart';

class ExercicePage extends StatefulWidget {
  final programmeRoutes = ProgrammeRoutes();
  final exerciceRoutes = ExerciceRoutes();
  bool? Add;
  final Programme? programme;
  List<String>? list_exercices;

  ExercicePage({this.Add, this.programme, this.list_exercices});

  @override
  State<ExercicePage> createState() => _ExercicePageState();
}

class _ExercicePageState extends State<ExercicePage> {
  String? dropdownValue = 'Pomme';
  bool isListVisible_HautPoly = false;
  bool isListVisible_HautIso = false;
  bool isListVisible_BasPoly = false;
  bool isListVisible_BasIso = false;

  late List<dynamic> tabTopPoly = [];
  late List<dynamic> tabTopIso = [];
  late List<dynamic> tabBottomPoly = [];
  late List<dynamic> tabBottomIso = [];

  bool dataLoaded = false;

  var items = ['Pomme', 'Banane', 'Fraise', 'Orange', 'Abricot', 'Melon'];

  @override
  void initState() {
    super.initState();
    getexo(Provider.of<LoginState>(context, listen: false));
    if (widget.programme != null) widget.Add = true;
  }

  getexo(LoginState loginState) {
    widget.exerciceRoutes.getAll(loginState).then((exercices) {
      exercices[0].forEach((exerciseData) {
        Exercice exercice0 = Exercice.fromJson(exerciseData);
        tabTopPoly.add({
          'nameWithDesc': '${exercice0.name} : ${exercice0.description}',
          'id': '${exercice0.id}',
          'isFavourite' : exercice0.isFavourite,
        });

      });

      exercices[1].forEach((exerciseData) {
        Exercice exercice1 = Exercice.fromJson(exerciseData);
        tabTopIso.add({
          'nameWithDesc': '${exercice1.name} : ${exercice1.description}',
          'id': '${exercice1.id}',
          'isFavourite' : exercice1.isFavourite,
        });
      });

      exercices[2].forEach((exerciseData) {
        Exercice exercice2 = Exercice.fromJson(exerciseData);
        tabBottomPoly.add({
          'nameWithDesc': '${exercice2.name} : ${exercice2.description}',
          'id': '${exercice2.id}',
          'isFavourite' : exercice2.isFavourite,
        });
      });

      exercices[3].forEach((exerciseData) {
        Exercice exercice3 = Exercice.fromJson(exerciseData);
        tabBottomIso.add({
          'nameWithDesc': '${exercice3.name} : ${exercice3.description}',
          'id': '${exercice3.id}',
          'isFavourite' : exercice3.isFavourite,
        });
      });
      setState(() {
        dataLoaded = true;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        title: Text('Exercices'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) => MyHomePage()));
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder(
              future: Future.value(dataLoaded),
              builder: (context, snapshot) {
                if (!dataLoaded ) {
                  // Attendez que les données soient chargées
                  return CircularProgressIndicator();
                } else {
                  // Les données sont chargées, construisez le widget
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            'Haut du corps :',
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isListVisible_HautPoly = !isListVisible_HautPoly;
                              });
                            },
                            child: Row(
                              children: [
                                Icon(Icons.keyboard_arrow_down),
                                SizedBox(width: 10),
                                Text(
                                  "Polymusculaire",
                                  style: TextStyle(fontSize: 16),
                                ),
                                //if (widget.Add != null && widget.Add) // Vérifier si Add est vrai
                              ],
                            ),
                          ),
                          Visibility(
                            visible: isListVisible_HautPoly,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: tabTopPoly.map((item) {
                                return ListTile(
                                  title: FavoriStar(item, exerciceRoutes: widget.exerciceRoutes, context: context, setStateCallback: setState),
                                  leading:
                                  widget.Add != null && widget.Add! ?
                                  widget.list_exercices != null && widget.list_exercices!.contains(item['nameWithDesc']) ?
                                  GestureDetector(
                                    onTap: () {
                                      removeExo(item);
                                    },
                                    child: Icon(Icons.remove),
                                  )
                                      : GestureDetector(
                                    onTap: () {
                                      addExo(item);
                                    },
                                    child: Icon(Icons.add),
                                  )
                                      : SizedBox.shrink(), // Affiche null si widget.exercices est null
                                );
                              }).toList(),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isListVisible_HautIso = !isListVisible_HautIso;
                              });
                            },
                            child: Row(
                              children: [
                                Icon(Icons.keyboard_arrow_down),
                                SizedBox(width: 10),
                                Text(
                                  "Isolation",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: isListVisible_HautIso,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: tabTopIso.map((item) {
                                return ListTile(
                                  title: FavoriStar(item, exerciceRoutes: widget.exerciceRoutes, context: context, setStateCallback: setState),
                                  leading: widget.Add != null && widget.Add! ?
                                  widget.list_exercices != null && widget.list_exercices!.contains(item['nameWithDesc']) ?
                                  GestureDetector(
                                    onTap: () {
                                      removeExo(item);
                                    },
                                    child: Icon(Icons.remove),
                                  )
                                      : GestureDetector(
                                    onTap: () {
                                      addExo(item);
                                    },
                                    child: Icon(Icons.add),
                                  )
                                      : SizedBox.shrink(), // Affiche null si widget.exercices est null
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(height: 20),
                          MyText(
                            'Bas du corps :',
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isListVisible_BasPoly = !isListVisible_BasPoly;
                              });
                            },
                            child: Row(
                              children: [
                                Icon(Icons.keyboard_arrow_down),
                                SizedBox(width: 10),
                                Text(
                                  "Polymusculaire",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: isListVisible_BasPoly,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: tabBottomPoly.map((item) {
                                return ListTile(
                                  title: FavoriStar(item, exerciceRoutes: widget.exerciceRoutes, context: context, setStateCallback: setState),
                                  leading: widget.Add != null && widget.Add! ?
                                  widget.list_exercices != null && widget.list_exercices!.contains(item['nameWithDesc']) ?
                                  GestureDetector(
                                    onTap: () {
                                      removeExo(item);
                                    },
                                    child: Icon(Icons.remove),
                                  )
                                      : GestureDetector(
                                    onTap: () {
                                      addExo(item);
                                    },
                                    child: Icon(Icons.add),
                                  )
                                      : SizedBox.shrink(), // Affiche null si widget.exercices est null
                                );
                              }).toList(),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isListVisible_BasIso = !isListVisible_BasIso;
                              });
                            },
                            child: Row(
                              children: [
                                Icon(Icons.keyboard_arrow_down),
                                SizedBox(width: 10),
                                Text(
                                  "Isolation",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: isListVisible_BasIso,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: tabBottomIso.map((item) {
                                return ListTile(
                                  title: FavoriStar(item, exerciceRoutes: widget.exerciceRoutes, context: context, setStateCallback: setState),
                                  leading: widget.Add != null && widget.Add! ?
                                  widget.list_exercices != null && widget.list_exercices!.contains(item['nameWithDesc']) ?
                                  GestureDetector(
                                    onTap: () {
                                      removeExo(item);
                                    },
                                    child: Icon(Icons.remove),
                                  )
                                      : GestureDetector(
                                    onTap: () {
                                      addExo(item);
                                    },
                                    child: Icon(Icons.add),
                                  )
                                      : SizedBox.shrink(), // Affiche null si widget.exercices est null
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) => FavoriPage()),
              );
            },
            tooltip: 'Accès favoris',
            child: Icon(
              Icons.star,
              color: Colors.red, // Couleur rouge pour l'icône
            ),
          ),
        ),
      ),
    );
  }


  addExo(exercice){
    var token = Provider.of<LoginState>(context, listen: false).getToken();
    var result = widget.programmeRoutes.addExercice(token, widget.programme!.id!, int.parse(exercice['id']));
    if (widget.list_exercices == null) {
      setState(() {
        widget.list_exercices = [exercice['nameWithDesc']];
      });
    } else {
      setState(() {
        widget.list_exercices!.add(exercice['nameWithDesc']);
      });
    }
    return result;
  }

  removeExo(exercice){
    var token = Provider.of<LoginState>(context, listen: false).getToken();
    var result = widget.programmeRoutes.removeExercice(token, widget.programme!.id!, int.parse(exercice['id']));
    setState(() {
      widget.list_exercices!.remove(exercice['nameWithDesc']);
    });
    return result;
  }
}