import 'dart:developer';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';


//for testing purposes created a default user
final int userId = 1;
final String baseUrl = '10.0.2.2:8000';
//Made this list because I do not know how to get data out of a dynamic list
List<Todo> _todoItems = [];



Future<List> fetchTodo() async {

  try {
    final response = await http.get(Uri.http(baseUrl, 'api/todos'));

    // If the server did return a 200 OK response,
    print("fetch success");

    // then parse the JSON.
    List<Todo> myTodo = [];
    List test = json.decode(response.body) as List;
    for (var i = 0; i < test.length; i++) {
      myTodo.add(Todo.fromJson(test[i]));
    }
    _todoItems = myTodo;
    return myTodo;

  } catch (err) {
      print('Caught error: $err');
      makeToast();
}

}

Future<List> createTodo(String title) async {
  final response = await http.post(
    Uri.http(baseUrl, 'api/todos'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
      'userId': userId.toString(),
    }),
  );
  if (response.statusCode == 200) {
    List<Todo> myTodo = [];
    List test = json.decode(response.body) as List;
    for (var i = 0; i < test.length; i++) {
      myTodo.add(Todo.fromJson(test[i]));
    }
    _todoItems = myTodo;
    return myTodo;
  } else {
    throw Exception('Failed to load todo');
  }
}

Future<List> updateTodo(Todo todo, String val) async {
  //turn the boolean in a 0 or a 1 else Laravel does not know what to do with it
  int completed = todo.completed == false ? 0 : 1;
  final response = await http.put(
    Uri.http(baseUrl, 'api/todos/' + todo.id.toString()),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': val,
      'completed': completed.toString(),
    }),
  );

  if (response.statusCode == 200) {
    List<Todo> myTodo = [];
    List test = json.decode(response.body) as List;
    for (var i = 0; i < test.length; i++) {
      myTodo.add(Todo.fromJson(test[i]));
    }
    _todoItems = myTodo;
    return myTodo;
  } else {
    throw Exception('Failed to put');
  }
}


void makeToast(){
  print("fetch failed");
  Fluttertoast.showToast(
      msg: "Start de laravel api ",
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      fontSize: 16.0
  );
}



class Todo {
  final int userId;
  final int id;
  final String title;
  bool completed;

  Todo({this.userId, this.id, this.title, this.completed});

  factory Todo.fromJson(json) {
    return Todo(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: json['completed'] == 0 ? false : true,
    );
  }
}

void main() => runApp(new TodoApp());

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(title: 'Todo List', home: new TodoList());
  }
}

class TodoList extends StatefulWidget {
  @override
  createState() => new TodoListState();
}

class TodoListState extends State<TodoList> {
  Future<List> futureTodo;


  @override
  void initState() {
    super.initState();
    futureTodo = fetchTodo();

  }


  //build a list with all the todo's
  Widget projectWidget() {
    return FutureBuilder(
        future: futureTodo,
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Container(
                child: ListView.builder(
                    itemCount: _todoItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildTodoItem(_todoItems[index], index);
                    }));
          }
        });
  }

  Widget _buildTodoItem(Todo todo, int index) {
    return new CheckboxListTile(
      title: Text(todo.title),
      value: todo.completed,
      secondary: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () => _pushAddTodoScreen(todo),
      ),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (bool value) {
        setState(() {
          todo.completed = value;
          futureTodo = updateTodo(todo, todo.title);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('Todo List')),
      body: projectWidget(),
      floatingActionButton: new FloatingActionButton(
          onPressed: () => _pushAddTodoScreen(null),
          tooltip: 'Add task',
          child: new Icon(Icons.add)),
    );
  }

  void _pushAddTodoScreen(Todo todo ) {
    // Push this page onto the stack
    Navigator.of(context).push(
        new MaterialPageRoute(builder: (context) {
        return new Scaffold(
            appBar: new AppBar(title: new Text(todo == null ? "Maak een nieuwe todo" : "Pas todo aan")),
            body: new TextField(
              autofocus: true,
              controller: TextEditingController()..text = (todo == null ? "" : todo.title),
              onSubmitted: (val) {
                setState(() {
                  futureTodo = (todo == null ? createTodo(val) : updateTodo(todo, val));
                });
                Navigator.pop(context); // Close the add todo screen
              },
              decoration: new InputDecoration(
                  hintText: 'Titel van de todo',
                  contentPadding: const EdgeInsets.all(16.0)),
            ));
    }));
  }
}
