import 'package:flutter/material.dart';
import 'package:to_do_app/Screens/todo_list_screen.dart';
import 'package:to_do_app/api_service/api_service.dart';
import 'package:to_do_app/utils/common_toast.dart';

class DeleteButton extends StatefulWidget {
 final String id;
  const DeleteButton({super.key, required this.id});

  @override
  State<DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<DeleteButton> {

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: (){
        setState(() {
          isLoading = true;});
        ApiServices().deleteTodos(widget.id).then((value){
          commonToast(context, 'Delete Successfully', bgColor: Colors.green);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const TodoListScreen()));

          setState(() {
            isLoading = false;});

        }).onError((error, stackTrace){
          debugPrint(error.toString());
          commonToast(context, 'Somehting went wrong');
        });
      },
      child: Container(
        height: 45,width: 100,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 5),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.inversePrimary,
            borderRadius: BorderRadius.circular(50)
        ),
        child:isLoading? const SizedBox(
          child: SizedBox(
              height: 20, width: 30,
              child: CircularProgressIndicator()),
        ) :const Icon(Icons.delete_outline, color: Colors.red,),
      ),
    );
  }
}
