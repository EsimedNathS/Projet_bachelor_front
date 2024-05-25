import 'package:flutter/material.dart';
import 'package:mobile/Adds/ChangeDayDialog.dart';
import 'package:mobile/Adds/FavoriStar.dart';
import 'package:mobile/model/Programme.dart';
import 'package:mobile/pages/FavoriPage.dart';
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
  Map<String, List<dynamic>>? tabDays;
  Map<String, bool> isListVisibleMap = {}; // Pour stocker la visibilité de chaque liste

  @override
  void initState() {
    super.initState();
    getprog();
  }


  getprog() {
    Provider.of<LoginState>(context, listen: false);
    widget.programmeRoutes
        .getAll(Provider.of<LoginState>(context, listen: false))
        .then((values) {
      tabDays = {}; // Initialisation de tabDays en tant que Map vide
      values.forEach((value) {
        tabProgramme.add(value);
        if (value['day'] != null && value['day'] != 'null') {
          affiche_semaine = true;
          final day = value['day'];
          tabDays!.putIfAbsent(day, () => []);
          tabDays![day]!.add(value);
          // Initialisation de la visibilité de chaque liste à false
          isListVisibleMap[day] = false;
        }
      });
      // Tri des jours de la semaine
      List<String> weekDays = ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'];
      tabDays = Map.fromEntries(
        tabDays!.entries.toList()..sort((a, b) => weekDays.indexOf(a.key).compareTo(weekDays.indexOf(b.key))),
      );
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
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MyHomePage()),
                  (Route<dynamic> route) => false, // Supprime toutes les routes en dessous
            );
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
                      // Cas en attente de données
                      if (!dataLoaded) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      // Une fois les données chargées
                      } else {
                        return ListView(
                          children: [
                            // Si il y a des pogrammes associé a des jours, on affiche les correspondants
                            if (affiche_semaine)
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: tabDays!.length,
                                itemBuilder: (context, index) {
                                  final day = tabDays!.keys.toList()[index];
                                  final values = tabDays![day];
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10),
                                      // Ajout d'un espace entre les jours
                                      Center(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              // Inversion de la visibilité lorsque l'en-tête est tapé
                                              isListVisibleMap[day] = !isListVisibleMap[day]!;
                                            });
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center, // Centrer le contenu horizontalement
                                            children: [
                                              SizedBox(width: 10),
                                              Text(
                                                "$day",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Icon(
                                                isListVisibleMap[day]!
                                                    ? Icons.keyboard_arrow_down
                                                    : Icons.keyboard_arrow_right,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // Affiche du nom du programme puis des exercices
                                      Visibility(
                                        visible: isListVisibleMap[day]!,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: values!.map<Widget>((item) {
                                            return ListTile(
                                              title: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Programme:  ' + item['name']),
                                                  if (item['exercice'] != null) ...[
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text('Exercice du jour:'),
                                                        for (var exercice in item['exercice'])
                                                          Text('              ${exercice['name']}'),
                                                      ],
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            // Liste des programmes
                            ...tabProgramme.map((programme) {
                              // Créez une ExpansionTile pour chaque programme
                              return ExpansionTile(
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          FavoriStar(programme, programmeRoutes: widget.programmeRoutes, context: context, setStateCallback: setState),
                                          SizedBox(width: 10), // Espacement entre l'étoile et le texte
                                          Expanded(
                                            child: Text(
                                              programme['name'],
                                              overflow: TextOverflow.ellipsis, // Gérer le débordement si nécessaire
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Bouton pour afficher le menu de modification des exercices
                                    IconButton(
                                      icon: Icon(Icons.more_vert),
                                      onPressed: () {
                                        // Affiche le menu déroulant ici
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
                          ],
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
                  heroTag: 'addButton', // Tag unique pour le bouton "Ajouter"
                  onPressed: () => {AddProgDialog(context, widget.programmeRoutes)},
                  tooltip: 'Ajouter',
                  child: Icon(Icons.add), // Icône "plus" pour évoquer l'ajout
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FloatingActionButton(
                  heroTag: 'favoriteButton', // Tag unique pour le bouton "Accès favoris"
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => FavoriPage()),
                  ),
                  tooltip: 'Accès favoris',
                  child: Icon(
                    Icons.star,
                    color: Colors.red, // Couleur rouge pour l'icône
                  ),
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
