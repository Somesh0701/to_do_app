import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/Screens/add_and_update_todo.dart';
import 'package:to_do_app/Screens/todos_screen.dart';
import 'package:to_do_app/api_service/api_service.dart';
import 'package:to_do_app/models/get_all_todos.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  GetAllTodoModel getAllTodoModel = GetAllTodoModel();
  List<Items> inCompleteTodo = [];
  List<Items> CompleteTodo = [];
  bool isLoading = false ;


  getAllTodos () async{
    setState(() {
      isLoading = true;
      getAllTodoModel.items?.clear();
      inCompleteTodo.clear();
      CompleteTodo.clear();

    });
    await ApiServices().getAllTodos().then((value){
      getAllTodoModel = value;

      for(var todo in value.items!){

        if(todo.isCompleted == true){
          CompleteTodo.add(todo);
        }else{
          inCompleteTodo.add(todo);
        }
        isLoading = false;
        setState(() {});
      }
      setState(() {});
    }).onError((error, stackTrace){
      debugPrint(error.toString());
    });
  }
  @override
  void initState() {
    getAllTodos ();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Todo List'),
          bottom: const TabBar(
            labelPadding: EdgeInsets.symmetric(vertical: 10),
              labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
              unselectedLabelStyle:TextStyle(fontWeight: FontWeight.w400,fontSize: 20) ,
              tabs:[
                Text('All'),
                Text('Incomplete'),
                Text('Complete')
              ]),


        ),

        body: TabBarView(
            children: [
              TodosScreen(todoList: getAllTodoModel.items??[]),
              TodosScreen(todoList: inCompleteTodo,),
              TodosScreen(todoList: CompleteTodo,),
            ]),

        
        floatingActionButton: FloatingActionButton(
            onPressed: ()async{
           bool loading = await   Navigator.push(context, MaterialPageRoute(builder: (context)=> const AddAndUpdateTodo()));

           if(loading == true){
             getAllTodos();
           }

         },
            child: Icon(Icons.add),
    
            
      ),
      ),
    );
  }
}
