import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../models/get_all_todos.dart';
import '../models/todo_model.dart';


class ApiServices{
  String baseUrl = "https://api.nstack.in";

  //get all todos
Future<GetAllTodoModel> getAllTodos () async{
  var response = await http.get(Uri.parse('$baseUrl/v1/todos'));

  if(response.statusCode == 200){


    final data = GetAllTodoModel.fromJson(jsonDecode(response.body));
    return data;

  }else{
    throw Exception('API ERROR');
  }
}




  //add todos
  Future<TodoModel> addTodo (String title, String description, bool isComplete) async{
    var response = await http.post(Uri.parse('$baseUrl/v1/todos'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": title,
        "description": description,
        "is_completed": isComplete
      })

    );


    if(response.statusCode == 201){
      final data = json.decode(response.body);
      final response1 = TodoModel.fromJson(data);
      return response1;

    }else{
      throw Exception('API ERROR');
    }
  }




  //update todos
  Future<TodoModel> updateTodo (String id, String title, String description, bool isComplete) async{
    var response = await http.put(Uri.parse('$baseUrl/v1/todos/$id'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "title": title,
          "description": description,
          "is_completed": isComplete
        })

    );


    if(response.statusCode == 200){
      final data = json.decode(response.body);
      return TodoModel.fromJson(data);

    }else{
      throw Exception('API ERROR');
    }
  }


  //delete todos
  Future<GetAllTodoModel> deleteTodos (String id) async{
    var response = await http.delete(Uri.parse('$baseUrl/v1/todos/$id'));

    if(response.statusCode == 200){


      final data = GetAllTodoModel.fromJson(jsonDecode(response.body));
      return data;

    }else{
      throw Exception('API ERROR');
    }
  }





}