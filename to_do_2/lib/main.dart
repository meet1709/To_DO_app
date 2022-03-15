import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(

    options: FirebaseOptions(apiKey: "AIzaSyCuMHylqm14Os_ultalrSFlQXuZ-T0YeMY", appId:"com.example.to_do_app" , messagingSenderId: "822388492469-2tm5l38dd89bj1nkjek7qigqn6808lbn.apps.googleusercontent.com", projectId: "mytodoapp-a3aba")
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        //dividerColor: Colors.amber
      ),
      home: const MyHomePage(title: "TO DO.. ",),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List todos = List.empty();
  String title = "";
  String description = "";
  @override
  void initState() {
    super.initState();
    todos = ["Hello", "Hey There"];
  }

  createToDo() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(title);

    Map<String, String> todoList = {
      "todoTitle": title,
      "todoDesc": description
    };

    documentReference
        .set(todoList)
        .whenComplete(() => print("Data stored successfully"));
  }

  deleteTodo(item) {

    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(item);

        documentReference.delete().whenComplete(() => print("deleted successfully"));
  }

  final Shader linearGradient = LinearGradient(
  colors: <Color>[Colors.purple, Colors.white],
).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));


  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.black, Colors.blue])),

      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(widget.title    , style: TextStyle(fontWeight: FontWeight.bold ,foreground: Paint()..shader = linearGradient ),),
          centerTitle: true,
          //backgroundColor: Colors.blueGrey,
          flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[Colors.blueAccent, Colors.purpleAccent]),
        ),
      ),
        ),
        body: StreamBuilder<QuerySnapshot>(
    
          stream: FirebaseFirestore.instance.collection("MyTodos").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            } else if (snapshot.hasData || snapshot.data != null) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    QueryDocumentSnapshot<Object?>? documentSnapshot =
                        snapshot.data?.docs[index];
                    return Dismissible(
                        key: Key(index.toString()),
                        child: Card(

                          color: Colors.orangeAccent,

                          elevation: 4,
                          child: ListTile(
                            title: Text((documentSnapshot != null) ? (documentSnapshot["todoTitle"]) : ""),
                            subtitle: Text((documentSnapshot != null)
                                ? ((documentSnapshot["todoDesc"] != null)
                                    ? documentSnapshot["todoDesc"]
                                    : "")
                                : ""),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () {
                                setState(() {
                                  //todos.removeAt(index);
                                  deleteTodo((documentSnapshot != null) ? (documentSnapshot["todoTitle"]) : "");
                                });
                              },
                            ),
                          ),
                        ));
                  });
            }
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.red,
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    title: const Text("Add Todo"  , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),),
                    content: Container(
                      width: 400,
                      height: 100,
                      child: Column(
                        children: [
                          TextField(
                            onChanged: (String value) {
                              title = value;
                            },
                          ),
                          TextField(
                            onChanged: (String value) {
                              description = value;
                            },
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () {
                            setState(() {
                              //todos.add(title);
                              createToDo();
                            });
                            Navigator.of(context).pop();
                          },
                          child: const Text("Add",style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold)))
                    ],
                  );
                });
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Colors.orange.shade400,
          
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        
        
    
        //floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      ),
    );
  }
}