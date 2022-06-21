import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _collectionref = FirebaseFirestore.instance.collection("todolist");
  var _docref = FirebaseFirestore.instance;
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(buttonTheme: ButtonThemeData(buttonColor: Colors.grey)),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text("To do list"),
          centerTitle: true,
        ),
        body: Column(children: [
          Flexible(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(8),
                  child: Form(
                    child: TextFormField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Notunuzu Giriniz:",
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  /* style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ),*/
                  onPressed: () async {
                    var hld = {"name": _controller.text};
                    await _collectionref.doc().set(hld);
                  },
                  child: Text(
                    "Ekle",
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: _collectionref.snapshots(),
                  builder: (context, snapshot) {
                    var snphld = snapshot.data?.docs;
                    return Flexible(
                      child: ListView.builder(
                        itemCount: snphld?.length,
                        itemBuilder: (context, index) {
                          if (snapshot.hasData) {
                            return Card(
                              margin: EdgeInsets.all(8),
                              color: Colors.grey,
                              child: ListTile(
                                title: !snapshot.hasData
                                    ? null
                                    : Text(
                                        "${snphld?[index].get('name')}",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    await snphld?[index].reference.delete();
                                  },
                                ),
                              ),
                            );
                          } else
                            return CircularProgressIndicator();
                        },
                      ),
                    );
                  },
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
