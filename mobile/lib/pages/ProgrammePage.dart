import 'package:flutter/material.dart';
import 'package:mobile/pages/MyHomePage.dart';
import 'package:mobile/services/ProgrammeRoutes.dart';

class ProgrammePage extends StatefulWidget {
  final ProgrammeRoutes programmeRoutes;

  ProgrammePage() : programmeRoutes = ProgrammeRoutes();

  @override
  State<ProgrammePage> createState() => _ProgrammePageState();
}

class _ProgrammePageState extends State<ProgrammePage> {

  bool dataLoaded = false;


  @override
  void initState() {
    super.initState();
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
              );
            }
          },
        ),
      ),
    );
  }
}
