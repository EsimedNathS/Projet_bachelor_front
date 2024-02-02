import 'package:flutter/material.dart';
import 'package:mobile/components.dart';
import 'package:mobile/services/ExerciceRoutes.dart';

class ExercicePage extends StatefulWidget {
  final exerciceRoutes = ExerciceRoutes();

  @override
  State<ExercicePage> createState() => _ExercicePageState();
}

class _ExercicePageState extends State<ExercicePage> {
  String? dropdownValue = 'Pomme';
  bool isListVisible_HautPoly = false;
  bool isListVisible_HautIso = false;
  bool isListVisible_BasPoly = false;
  bool isListVisible_BasIso = false;

  late List<dynamic> tabTopPoly;
  late List<dynamic> tabTopIso;
  late List<dynamic> tabBottomPoly;
  late List<dynamic> tabBottomIso;

  bool dataLoaded = false;

  var items = ['Pomme', 'Banane', 'Fraise', 'Orange', 'Abricot', 'Melon'];

  getexo() {
    widget.exerciceRoutes.getAll().then((exercices) {
      tabTopPoly = exercices[0]['name'];
      tabTopIso = exercices[1]['name'];
      tabBottomPoly = exercices[2]['name'];
      tabBottomIso = exercices[3]['name'];
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: getexo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting || !dataLoaded) {
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
                              dropdownValue!,
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
                              dropdownValue!,
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
                              dropdownValue!,
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: isListVisible_BasPoly,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: items.map((item) {
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
                              dropdownValue!,
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: isListVisible_BasIso,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: items.map((item) {
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
