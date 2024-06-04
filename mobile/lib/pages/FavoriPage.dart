import 'package:flutter/material.dart';
import 'package:mobile/model/Programme.dart';
import 'package:mobile/pages/MyHomePage.dart';
import 'package:mobile/pages/ProgrammePage.dart';
import 'package:mobile/services/ExerciceRoutes.dart';
import 'package:mobile/services/LoginState.dart';
import 'package:mobile/services/ProgrammeRoutes.dart';
import 'package:provider/provider.dart';

class FavoriPage extends StatefulWidget {
  final programmeRoutes = ProgrammeRoutes();
  final exerciceRoutes = ExerciceRoutes();
  final Programme? programme;
  List<Map<String, dynamic>>? list_exercices;

  FavoriPage({Key? key, this.programme, this.list_exercices}) : super(key: key);

  @override
  State<FavoriPage> createState() => _FavoriPageState();
}

class _FavoriPageState extends State<FavoriPage> {
  Map<String, List<dynamic>>? tabFavoris;
  late List<dynamic> tabProgramme = [];
  late List<dynamic> tabExercice = [];
  bool dataLoaded = false;
  List<String> selectedExercises = [];

  @override
  void initState() {
    super.initState();
    getProgAndExo();
  }

  getProgAndExo() {
    Provider.of<LoginState>(context, listen: false);
    widget.programmeRoutes.getAll(Provider.of<LoginState>(context, listen: false))
        .then((values_prog) {
      values_prog.forEach((value_prog) {
        if (value_prog['favori'] == true) {
          tabProgramme.add(value_prog);
        }
      });

      widget.exerciceRoutes.getAllFavori(Provider.of<LoginState>(context, listen: false))
          .then((values_exo) {
        values_exo.forEach((value_exo) {
          tabExercice.add(value_exo);
        });

        setState(() {
          dataLoaded = true;
        });
      });
    });
  }

  bool isExerciceInList(dynamic exercice) {
    return  widget.list_exercices?.any((ex) => ex['id'].toString() == exercice['id'].toString()) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        title: Text('Favoris'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (widget.list_exercices != null && widget.list_exercices!.isNotEmpty) {
              Navigator.of(context).pop(widget.list_exercices);
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: FutureBuilder(
                    future: Future.value(dataLoaded),
                    builder: (context, snapshot) {
                      if (!dataLoaded) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView(
                          children: [
                            // Affichage des programmes
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Programmes',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ...tabProgramme.map((programme) {
                              return ExpansionTile(
                                title: Text(programme['name']),
                                children: [
                                  if (programme['exercice'] == null)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                      child: Text('Aucun exercice trouvé.'),
                                    )
                                  else
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: (programme['exercice'] as List<dynamic>).map((exercice) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                                          child: Text(exercice['name']),
                                        );
                                      }).toList(),
                                    ),
                                ],
                              );
                            }).toList(),
                            // Affichage des exercices
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Exercices',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ...tabExercice.map((exercice) {
                              return ListTile(
                                title: Text(exercice['name']),
                                trailing: widget.programme != null
                                    ? IconButton(
                                  icon: isExerciceInList(exercice)
                                      ? Icon(Icons.remove)
                                      : Icon(Icons.add),
                                  onPressed: () {
                                    if (isExerciceInList(exercice)) {
                                      removeExo(exercice);
                                    } else {
                                      addExo(exercice);
                                    }
                                  },
                                )
                                    : null,
                              );
                            }).toList(),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  addExo(exercice) async {
    var token = Provider.of<LoginState>(context, listen: false).getToken();
    try {
      // Ajouter l'exercice au programme
      var result = await widget.programmeRoutes.addExercice(token, widget.programme!.id!, exercice['id']);

      // Vérifier si l'ajout a réussi
      if (result != null) {
        setState(() {
          //On ajoute à la liste des exercices
          widget.list_exercices!.add({
            'name': exercice['name'],
            'description': exercice['description'],
            'id': exercice['id'],
            'isFavourite': true
          });

          // On modifie si jamais le programme est dans les favoris
          tabProgramme.forEach((prog) {
            if (prog['id'] == widget.programme!.id!){
              prog['exercice'].add(exercice);
            }
          });
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  removeExo(exercice) async {
    var token = Provider.of<LoginState>(context, listen: false).getToken();

    try {
      // Supprimer l'exercice du programme
      var result = await widget.programmeRoutes.removeExercice(token, widget.programme!.id!, exercice['id']);

      // Supprésion de la liste des exercices
      if (result != null) {
        setState(() {
          widget.list_exercices?.removeWhere((item) => item['id'] == exercice['id']);

          // On modifie si jamais le programme est dans les favoris
          tabProgramme.forEach((prog) {
            if (prog['id'] == widget.programme!.id!){
              prog['exercice'].remove(exercice);
            }
          });
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
