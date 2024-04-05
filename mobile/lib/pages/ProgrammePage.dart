import 'package:flutter/material.dart';
import 'package:mobile/Adds/ChangeDayDialog.dart';
import 'package:mobile/model/Programme.dart';
import 'package:mobile/pages/MyHomePage.dart';
import 'package:mobile/services/LoginState.dart';
import 'package:mobile/services/ProgrammeRoutes.dart';
import 'package:mobile/Adds/AddProgDialog.dart';
import 'package:mobile/Adds/ChangeNameDialog.dart';
import 'package:provider/provider.dart';
import 'ExercicePage.dart';

class ProgrammePage extends StatefulWidget {
  final ProgrammeRoutes programmeRoutes;

  ProgrammePage() : programmeRoutes = ProgrammeRoutes();

  @override
  State<ProgrammePage> createState() => _ProgrammePageState();
}

class _ProgrammePageState extends State<ProgrammePage> {
  late List<dynamic> tabProgramme = [];
  bool dataLoaded = false;
  bool affiche_semaine = false;

  @override
  void initState() {
    super.initState();
    getprog();
  }

  getprog(){
    Provider.of<LoginState>(context, listen: false);
    widget.programmeRoutes.getAll(Provider.of<LoginState>(context, listen: false)).
    then((values) {
      values.forEach((value) {
        tabProgramme.add(value);
        if (value['day'] != null){
          affiche_semaine = true;
        }
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
        title: Text('Programmes'),
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
                      }
                      else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: tabProgramme.map((programme) {
                            // Créez une ExpansionTile pour chaque programme
                            return ExpansionTile(
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      programme['name'],
                                      overflow: TextOverflow.ellipsis, // Gérer le débordement si nécessaire
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.more_vert),
                                    onPressed: () {
                                      // Action à effectuer lorsque vous appuyez sur l'icône
                                      // Afficher le menu déroulant ici
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                title: Text('Modifier les exercices'),
                                                onTap: () {
                                                  List<String> list_exercice = [];
                                                  programme['exercice'].forEach((element) => {
                                                    list_exercice.add('${element['name']} : ${element['description']}')
                                                  });
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(builder: (BuildContext context) =>
                                                        ExercicePage(
                                                            programme: Programme(name: programme['name'],day: programme['day'],favori: programme['favori'],IDUser: programme['IDUser'], id: programme['id']),
                                                            list_exercices: list_exercice
                                                        )
                                                    ),
                                                  );
                                                },
                                              ),
                                              ListTile(
                                                title: Text('Changer le nom'),
                                                onTap: () {
                                                  ChangeNameDialog(context, widget.programmeRoutes, programme['id']);
                                                },
                                              ),
                                              ListTile(
                                                title: Text('Associer à une journée'),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  ChangeDayDialog(context, widget.programmeRoutes, programme['id']);
                                                },
                                              ),
                                              ListTile(
                                                title: Text(
                                                  'Supprimer le programme',
                                                  style: TextStyle(color: Colors.red),
                                                ),
                                                onTap: () {
                                                  DeleteProg(programme['id']);
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                              children: [
                                // Vérifiez si programme['exercices'] est null ou vide
                                if (programme['exercice'] == null)
                                // Affiche un message si la liste des exercices est vide
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                    child: Text('Aucun exercice trouvé.'),
                                  )
                                else
                                // Liste des noms des exercices dans le programme
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: (programme['exercice'] as List<dynamic>).map((exercice) {
                                      return Text(exercice['name']);
                                    }).toList(),
                                  ),
                              ],
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            // Bouton flottant en bas à gauche
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FloatingActionButton(
                  onPressed: () => {AddProgDialog(context, widget.programmeRoutes)},
                  tooltip: 'Ajouter',
                  child: Icon(Icons.add), // Icône "plus" pour évoquer l'ajout
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DeleteProg(programme_id){
    var loginState = Provider.of<LoginState>(context, listen: false);
    var token = Provider.of<LoginState>(context, listen: false).getToken();
    widget.programmeRoutes.delete(token, programme_id);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => ProgrammePage()),
    );
  }
}
