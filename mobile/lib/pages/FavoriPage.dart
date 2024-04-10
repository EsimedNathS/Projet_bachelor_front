import 'package:flutter/material.dart';
import 'package:mobile/pages/MyHomePage.dart';
import 'package:mobile/services/ExerciceRoutes.dart';
import 'package:mobile/services/LoginState.dart';
import 'package:mobile/model/Exercice.dart';
import 'package:mobile/model/Programme.dart';
import 'package:mobile/services/ProgrammeRoutes.dart';
import 'package:provider/provider.dart';

class FavoriPage extends StatefulWidget {
  final programmeRoutes = ProgrammeRoutes();
  final exerciceRoutes = ExerciceRoutes();

  @override
  State<FavoriPage> createState() => _FavoriPageState();
}

class _FavoriPageState extends State<FavoriPage> {

  Map<String, List<dynamic>>? tabFavoris;
  late List<dynamic> tabProgramme = [];
  late List<dynamic> tabExercice = [];
  bool dataLoaded = false;

  @override
  void initState() {
    super.initState();
    getprog();
  }

  getprog() {
    Provider.of<LoginState>(context, listen: false);
    widget.programmeRoutes.getAll(Provider.of<LoginState>(context, listen: false))
        .then((values_prog) {

            values_prog.forEach((value_prog) {
              if (value_prog['favori'] == true){
                tabProgramme.add(value_prog);
              }
            });

            widget.exerciceRoutes.getAllFavori(Provider.of<LoginState>(context, listen: false)).
            then((values_exo) {

              values_exo.forEach((value_exo) {
                tabExercice.add(value_exo);
              });

              setState(() {
                dataLoaded = true;
              });
            });
        });

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
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) => MyHomePage()));
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
                              return ListTile(
                                title: Text(programme['name']),
                                // Add other properties as needed
                              );
                            }).toList(),
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
                                // Add other properties as needed
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
}
