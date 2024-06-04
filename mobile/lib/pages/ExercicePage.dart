import 'package:flutter/material.dart';
import 'package:mobile/Adds/FavoriStar.dart';
import 'package:mobile/components.dart';
import 'package:mobile/pages/FavoriPage.dart';
import 'package:mobile/pages/MyHomePage.dart';
import 'package:mobile/pages/ProgrammePage.dart';
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
  List<Map<String, dynamic>>? list_exercices;

  ExercicePage({this.Add, this.programme, this.list_exercices});

  @override
  State<ExercicePage> createState() => _ExercicePageState();
}

class _ExercicePageState extends State<ExercicePage> {
  bool isListVisible_HautPoly = false;
  bool isListVisible_HautIso = false;
  bool isListVisible_BasPoly = false;
  bool isListVisible_BasIso = false;

  late List<dynamic> tabTopPoly = [];
  late List<dynamic> tabTopIso = [];
  late List<dynamic> tabBottomPoly = [];
  late List<dynamic> tabBottomIso = [];

  bool dataLoaded = false;

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
          'name': '${exercice0.name}',
          'description': '${exercice0.description}',
          'id': '${exercice0.id}',
          'isFavourite': exercice0.isFavourite,
        });
      });

      exercices[1].forEach((exerciseData) {
        Exercice exercice1 = Exercice.fromJson(exerciseData);
        tabTopIso.add({
          'name': '${exercice1.name}',
          'description': '${exercice1.description}',
          'id': '${exercice1.id}',
          'isFavourite': exercice1.isFavourite,
        });
      });

      exercices[2].forEach((exerciseData) {
        Exercice exercice2 = Exercice.fromJson(exerciseData);
        tabBottomPoly.add({
          'name': '${exercice2.name}',
          'description': '${exercice2.description}',
          'id': '${exercice2.id}',
          'isFavourite': exercice2.isFavourite,
        });
      });

      exercices[3].forEach((exerciseData) {
        Exercice exercice3 = Exercice.fromJson(exerciseData);
        tabBottomIso.add({
          'name': '${exercice3.name}',
          'description': '${exercice3.description}',
          'id': '${exercice3.id}',
          'isFavourite': exercice3.isFavourite,
        });
      });
      setState(() {
        dataLoaded = true;
      });
    });
  }

  bool isExerciceInList(dynamic exercice) {
    return  widget.list_exercices?.any((ex) => ex['id'].toString() == exercice['id'].toString()) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // Titre + bouton de retour à la page précédente
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        title: Text('Exercices'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (widget.Add != null && widget.Add!) {
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) => ProgrammePage()));
            } else {
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) => MyHomePage()));
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder(
            future: Future.value(dataLoaded),
            builder: (context, snapshot) {
              if (!dataLoaded) {
                return CircularProgressIndicator();
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText('Haut du corps :'),
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
                            ],
                          ),
                        ),
                        // Liste des exercices poly du haut
                        Visibility(
                          visible: isListVisible_HautPoly,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: tabTopPoly.map((item) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    title: FavoriStar(item, exerciceRoutes: widget.exerciceRoutes, context: context, setStateCallback: setState),
                                    leading: widget.Add != null && widget.Add!
                                        ? isExerciceInList(item)
                                        ? GestureDetector(
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
                                        : SizedBox.shrink(),
                                  ),
                                  SizedBox(height: 10),
                                ],
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
                        // Liste des exercices Iso du haut
                        Visibility(
                          visible: isListVisible_HautIso,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: tabTopIso.map((item) {
                              return ListTile(
                                title: FavoriStar(item, exerciceRoutes: widget.exerciceRoutes, context: context, setStateCallback: setState),
                                leading: widget.Add != null && widget.Add!
                                    ? isExerciceInList(item)
                                    ? GestureDetector(
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
                                    : SizedBox.shrink(),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: 20),
                        MyText('Bas du corps :'),
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
                        // Liste des exercices Poly du bas
                        Visibility(
                          visible: isListVisible_BasPoly,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: tabBottomPoly.map((item) {
                              return ListTile(
                                title: FavoriStar(item, exerciceRoutes: widget.exerciceRoutes, context: context, setStateCallback: setState),
                                leading: widget.Add != null && widget.Add!
                                    ? isExerciceInList(item)
                                    ? GestureDetector(
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
                                    : SizedBox.shrink(),
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
                        // Liste des exercices Iso du bas
                        Visibility(
                          visible: isListVisible_BasIso,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: tabBottomIso.map((item) {
                              return ListTile(
                                title: FavoriStar(item, exerciceRoutes: widget.exerciceRoutes, context: context, setStateCallback: setState),
                                leading: widget.Add != null && widget.Add!
                                    ? isExerciceInList(item)
                                    ? GestureDetector(
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
                                    : SizedBox.shrink(),
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
      ),

      // Bouton accès favori en bas à droite
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FloatingActionButton(
            onPressed: () {
              if (widget.programme != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => FavoriPage(programme: widget.programme!, list_exercices: widget.list_exercices),
                  ),
                );
              } else {
                // Sinon, aller à la page Favori sans paramètre
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => FavoriPage()),
                );
              }
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

  addExo(exercice) async {
    var token = Provider.of<LoginState>(context, listen: false).getToken();
    var result = await widget.programmeRoutes.addExercice(token, widget.programme!.id!, int.parse(exercice['id']));
    setState(() {
      if (widget.list_exercices == null) {
        widget.list_exercices = [];
      }
      widget.list_exercices!.add({
        'name': exercice['name'],
        'description': exercice['description'],
        'id': int.parse(exercice['id']),
        'isFavourite': exercice['isFavourite']
      });
    });
    return result;
  }

  removeExo(exercice) async {
    var token = Provider.of<LoginState>(context, listen: false).getToken();
    var idToRemove = int.parse(exercice['id']);
    var result = await widget.programmeRoutes.removeExercice(token, widget.programme!.id!, idToRemove);
    if (widget.list_exercices != null) {
      setState(() {
        widget.list_exercices?.removeWhere((item) => item['id'] == idToRemove);
      });
    }
    return result;
  }




}
