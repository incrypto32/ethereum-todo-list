import 'dart:convert';

import 'package:blockchain_todo_flutter/abi/TodoList.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blockchain Todo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Blockchain Todo List',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool loading = false;
  List<Tasks> tasks = [];
  String rpcUrl = 'http://0.0.0.0:7545';
  String? newTaskContent;
  String privateKey =
      '68cc10fd3f3fdfda2004fa8122f35c836189d5a1uao41bc5aa7612a388af003bdd96e28';
  late Client httpClient;
  late Web3Client ethClient;
  late Credentials credentials;
  late EthereumAddress myAddress;
  late TodoList todoList;

  int taskCount = 0;

  late EthereumAddress contractAddress;
  late DeployedContract contract;

// Get the deployedContract
  Future<TodoList> getDeployedContract() async {
    String abiString = await rootBundle.loadString(
      'smart_contracts/build/contracts/TodoList.json',
    );
    var abiJson = jsonDecode(abiString);

    EthereumAddress contractAddress =
        EthereumAddress.fromHex(abiJson['networks']['5777']['address']);
    return TodoList(address: contractAddress, client: ethClient);
  }

// setup function
  Future<void> initialSetup() async {
    setState(() {
      loading = true;
    });

    httpClient = Client();
    ethClient = Web3Client(rpcUrl, httpClient);
    credentials = await ethClient.credentialsFromPrivateKey(privateKey);
    myAddress = await credentials.extractAddress();
    todoList = await getDeployedContract();
    await getTodoItems();

    todoList.taskCreatedEvents().listen((e) {
      print("${e.id}, ${e.content},${e.completed}");
      setState(() {
        tasks.add(Tasks([e.id, e.content, e.completed]));
      });
    });

    todoList.taskCompletedEvents().listen((event) {
      int i = tasks.indexWhere((element) => element.id == event.id);
      setState(() {
        tasks[i] = Tasks([tasks[i].id, tasks[i].content, event.completed]);
      });
    });

    setState(() {
      loading = false;
    });
  }

  Future<void> getTodoItems() async {
    print("1");
    var taskCount = await todoList.taskCount().then((value) => value.toInt());
    print("2");
    for (var i = 0; i < taskCount; i++) {
      print("${3 + i}");
      var todo = await todoList.tasks(BigInt.from(i + 1));
      tasks.add(todo);
    }
  }

  @override
  void initState() {
    initialSetup();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Column(
          children: loading
              ? []
              : [
                  Container(
                    padding: EdgeInsets.all(10),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(child: TextField(
                          onChanged: (value) {
                            newTaskContent = value;
                          },
                        )),
                        IconButton(
                          onPressed: () async {
                            if (newTaskContent != null &&
                                (newTaskContent?.length ?? 0) > 3) {
                              await todoList.createTask(newTaskContent!,
                                  credentials: credentials);
                            }
                          },
                          icon: Icon(Icons.send),
                        )
                      ],
                    ),
                  ),
                  ...tasks
                      .map(
                        (e) => ListTile(
                          leading: Text(e.id.toInt().toString()),
                          title: Text(e.content),
                          trailing: Checkbox(
                            value: e.completed,
                            onChanged: (val) async {
                              var a = await todoList.toggleCompleted(e.id,
                                  credentials: credentials);
                              print("Result of toggle completed $a");
                            },
                          ),
                        ),
                      )
                      .toList(),
                ],
        ),
      ),
    );
  }
}
