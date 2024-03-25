import 'package:flutter/material.dart';
import 'package:mobile/components.dart';
import 'package:mobile/pages/MyHomePage.dart';
import 'package:mobile/services/ExerciceRoutes.dart';
import 'package:mobile/services/LoginState.dart';
import 'package:mobile/model/Exercice.dart';
import 'package:provider/provider.dart';

class ExercicePage extends StatefulWidget {
  final ExerciceRoutes exerciceRoutes;

  ExercicePage() : exerciceRoutes = ExerciceRoutes();

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
  }

  getexo( LoginState loginState) {
    widget.exerciceRoutes.getAll(loginState).then((exercices) {
      exercices[0].forEach((exerciseData) {
        Exercice exercice0 = Exercice.fromJson(exerciseData);
        String nameWithDesc0 = '${exercice0.name}  :  ${exercice0.description}';
        tabTopPoly.add(nameWithDesc0);
      });

      exercices[1].forEach((exerciseData) {
        Exercice exercice1 = Exercice.fromJson(exerciseData);
        String nameWithDesc1 = '${exercice1.name}  :  ${exercice1.description}';
        tabTopIso.add(nameWithDesc1);
      });

      exercices[2].forEach((exerciseData) {
        Exercice exercice2 = Exercice.fromJson(exerciseData);
        String nameWithDesc2 = '${exercice2.name}  :  ${exercice2.description}';
        tabBottomPoly.add(nameWithDesc2);
      });

      exercices[3].forEach((exerciseData) {
        Exercice exercice3 = Exercice.fromJson(exerciseData);
        String nameWithDesc3 = '${exercice3.name}  :  ${exercice3.description}';
        tabBottomIso.add(nameWithDesc3);
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
      body: Padding(
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
                          ],
                        ),
                      ),
                      Visibility(
                        visible: isListVisible_HautPoly,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: tabTopPoly.map((item) {
                            return ListTile(
                              title: Text(item),
                              onTap: () {
                                setState(() {
                                  dropdownValue = item;
                                  isListVisible_HautPoly = false;
                                });
                              },
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
                              title: Text(item),
                              onTap: () {
                                setState(() {
                                  dropdownValue = item;
                                  isListVisible_HautIso = false;
                                });
                              },
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
                              title: Text(item),
                              onTap: () {
                                setState(() {
                                  dropdownValue = item;
                                  isListVisible_BasPoly = false;
                                });
                              },
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
                              title: Text(item),
                              onTap: () {
                                setState(() {
                                  dropdownValue = item;
                                  isListVisible_BasIso = false;
                                });
                              },
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
    );
  }
}
