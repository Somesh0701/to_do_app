import 'package:flutter/material.dart';
import 'package:to_do_app/Screens/todo_list_screen.dart';
import 'package:to_do_app/api_service/api_service.dart';
import 'package:to_do_app/models/get_all_todos.dart';
import 'package:to_do_app/utils/common_toast.dart';

class AddAndUpdateTodo extends StatefulWidget {
  final Items? items;
  const AddAndUpdateTodo({super.key, this.items});

  @override
  State<AddAndUpdateTodo> createState() => _AddAndUpdateTodoState();
}

class _AddAndUpdateTodoState extends State<AddAndUpdateTodo> {

  TextEditingController title = TextEditingController();
  TextEditingController Description = TextEditingController();
  bool isComplete = false;
  bool isLoading = false;

  @override
  void initState() {
   if(widget.items != null){
     title.text = widget.items?.title??"";
     Description.text = widget.items?.description??"";
     isComplete = widget.items?.isCompleted??false;
     setState(() {});
   }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title:  Text(widget.items == null? 'Add Todo': "Update Todo"),

      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextFormField(
              controller: title,
              autofocus: widget.items == null? true:false,
              style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 20),
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none
              ),
            ),
            TextFormField(
              controller: Description,
              style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 18),
              decoration: const InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none
              ),
            ),

            const Divider(),

            Row(
              children: [
                Text('Complete', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
              Switch(
              value: isComplete,
              activeColor: Colors.deepPurple,
              onChanged: (bool value) {
                setState(() {
                  isComplete = value;
                });
              },
            )
              ],
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(title.text.isEmpty){
            commonToast(context, 'Please enter title');
          }else if(Description.text.isEmpty){
            commonToast(context, 'Please enter Description');
          }else{

            setState(() {isLoading = true;});

            if(widget.items == null){
              ApiServices().addTodo(title.text.toString(), Description.text.toString(), isComplete).then((value){
                setState(() {isLoading = false;});

                Navigator.pop(context, true);}

              ).onError((error , stackTrace){
                debugPrint(error.toString());
                setState(() {isLoading = false;});
                commonToast(context, 'Somehting went wrong');              });
            }else{

              ApiServices().updateTodo(widget.items!.sId!, title.text.toString(), Description.text.toString(), isComplete).then((value){setState(() {
                isLoading = false;});

              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> TodoListScreen()));
              }).onError((error , stackTrace){
                debugPrint(error.toString());
                setState(() {isLoading = false;});
                commonToast(context, 'Somehting went wrong');              });
            }

          }

        },
        child:isLoading? const CircularProgressIndicator(): const Icon(Icons.done),


      ),
    );
  }
}
