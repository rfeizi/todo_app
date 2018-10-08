import 'package:flutter/material.dart';
import 'package:todo_app/util/dbhelper.dart';
import 'package:todo_app/screens/tododetail.dart';
import 'package:todo_app/model/todo.dart';

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TodoListState();
}

class TodoListState extends State {
  DbHelper helper = DbHelper();
  List<Todo> todos;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (todos == null) {
      todos = List<Todo>();
      getData();
    }
    return Scaffold(
      body: todoListItems(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(Todo('', 2, ''));
        },
        tooltip: "Add new Todo",
        child: new Icon(Icons.add),
      ),
    );
  }

  void getData() {
    final dbFuture = helper.initializedb();
    dbFuture.then((result) {
      final todosFuture = helper.getTodos();
      todosFuture.then((result) {
        List<Todo> todoList = List<Todo>();
        count = result.length;
        for (int i = 0; i < count; i++) {
          todoList.add(Todo.fromObject(result[i]));
          debugPrint(todoList[i].title + "hahahahahahhahahaha");
        }
        setState(() {
          todos = todoList;
          count = count;
        });
        debugPrint("items " + count.toString() + "hahahaCount");
      });
    });
  }

  ListView todoListItems() {

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Dismissible(
          //color: Colors.white,
          //elevation: 2.0,
          key: Key(this.todos[position].id.toString()),
          onDismissed: (direction) {
            // Remove the item from our data source.

            setState(() async {
              int result = await helper.deleteTodo(this.todos[position].id);
              //getData();
            });
            Scaffold.of(context)
                .showSnackBar(SnackBar(
                content: Text(this.todos[position].title + "dismissed")));
          },
          background: Container(color: Colors.red),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getColor(this.todos[position].priority),
              child: Text(this.todos[position].id.toString()),
            ),
            title: Text(todos[position].title),
            subtitle: Text(todos[position].date),
            onTap: () {
              debugPrint("Tapped on " + todos[position].id.toString());
              navigateToDetail(this.todos[position]);
            },
          ),
        );
      },
    );
  }

  Color getColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.orange;
        break;
      case 3:
        return Colors.green;
        break;
      default:
        return Colors.green;
    }
  }

  void navigateToDetail(Todo todo) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TodoDetail(todo)),
    );
    if (result == true) {
      getData();
    }
  }
}
