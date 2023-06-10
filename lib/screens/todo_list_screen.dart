import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:logger/logger.dart';
import 'package:todo_firebase/models/todo_model.dart';
import 'package:todo_firebase/providers/auth_provider.dart';
import 'package:todo_firebase/providers/todo_provider.dart';
import 'package:todo_firebase/screens/components/taskItem.dart';
import 'package:todo_firebase/screens/components/text_field.dart';

class TodoListScreen extends StatelessWidget {
   TodoListScreen({super.key});


  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
   DateTime selectedDate = DateTime.now();


  @override
  Widget build(BuildContext context) {
    Logger().wtf("build");
    final todoProvider = Provider.of<TodoProvider>(context,listen: false);
    todoProvider.fetchTodos();
    return Scaffold(
      floatingActionButton:
      Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: (){
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                authProvider.logout();
              },
              heroTag: null,
              child: const Icon(
                  Icons.logout_outlined
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            FloatingActionButton(
              onPressed: ()=>showAddTaskBox(todoProvider,context),
              heroTag:null,
              child: const Icon(Icons.add)
            ),

          ]
      ),

      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(children: [
              Positioned.fill(
                child: Image.asset('assets/bg.jpg', fit: BoxFit.fill),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10,vertical:10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello,",
                          style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                        Text("Click individual item to edit and delete ",
                            style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                    style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600)),
                        Consumer<TodoProvider>(
                          builder: (context,todoProvider,_) {
                            return Text('Total Todo: ${todoProvider.todos.length}', style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w600));
                          }
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ]),
          ),
          SizedBox(
            height: 3.h,
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Todo",
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w500)),
                  Expanded(
                    child: Consumer<TodoProvider>(
                      builder: (context,todoProvider,_) {
                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: todoProvider.todos.length,
                          itemBuilder: (context, i) {
                            final todo = todoProvider.todos[i];
                            final DateTime date = todoProvider.todos[i].date;
                            final dateFormatted = '${date.day}-${date.month}-${date.year}';
                            return InkWell(onTap:()=>showEditTaskBox(todoProvider,i,todo,context),child: TaskItem(title: todo.title,date: dateFormatted,description: todo.description,));

                          },
                        );
                      }
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  showAddTaskBox(TodoProvider todoProvider,BuildContext context)=>showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(

          backgroundColor:const Color(0xff46539e) ,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)),
          //this right here
          child: Container(
            width: 80.w,
            height: 50.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xff46539e),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(onTap:()=>Navigator.pop(context),child: const Icon(Icons.arrow_back,color: Colors.white,)),
                      Text("Add New Task",style:TextStyle(color: Colors.white,fontSize: 13.sp,fontWeight: FontWeight.w500)),
                      InkWell(onTap:()=>Navigator.pop(context),child: const Icon(Icons.home,color: Colors.white,))
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  TextFieldCustom(textEditingController: _titleController,label:'Title'),
                  TextFieldCustom(textEditingController: _descriptionController,label:'Description'),
                  InkWell(
                      onTap:()async{

                        final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2015, 8),
                            lastDate: DateTime(2101));
                        if (picked != null) {
                          _dateController.text = '${picked.year}-${picked.month}-${picked.day}';
                          selectedDate = picked;
                        }
                      },
                      child: TextFieldCustom(isEnabled: false,textEditingController: _dateController,label:'Date',)),
                  SizedBox(height: 5.h),
                  InkWell(
                    onTap:(){
                      final title = _titleController.text.trim();
                      final description = _descriptionController.text.trim();
                      if (title.isNotEmpty && description.isNotEmpty&&_dateController.text.isNotEmpty) {
                        todoProvider.addTodo(TodoModel(
                          id: '',
                          userId: '',
                          title: title,
                          description: description,
                          date: selectedDate,
                        ));
                        _titleController.clear();
                        _dateController.clear();
                        _descriptionController.clear();
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                        width: double.maxFinite,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius: BorderRadius.circular(8)),
                        child: const Center(child: Text("Add",style: TextStyle(color: Colors.white),))),
                  ),
                ],
              ),
            ),
          ),
        );
      });
  showEditTaskBox(TodoProvider todoProvider,int index,TodoModel todo,BuildContext context)=>showDialog(
      context: context,
      builder: (BuildContext context) {
        _titleController.text = todo.title;
        _descriptionController.text = todo.description;
        return Dialog(
          backgroundColor:const Color(0xff46539e) ,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)),
          //this right here
          child: Container(
            width: 80.w,
            height: 50.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xff46539e),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(onTap:()=>Navigator.pop(context),child: const Icon(Icons.arrow_back,color: Colors.white,)),
                      Text("Edit Task",style:TextStyle(color: Colors.white,fontSize: 13.sp,fontWeight: FontWeight.w500)),
          const SizedBox(),]
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  TextFieldCustom(textEditingController: _titleController,label:'Title'),
                  TextFieldCustom(textEditingController: _descriptionController,label:'Description'),
                  InkWell(
                      onTap:()async{

                        final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2015, 8),
                            lastDate: DateTime(2101));
                        if (picked != null) {
                          _dateController.text = '${picked.year}-${picked.month}-${picked.day}';
                          selectedDate = picked;
                        }
                      },
                      child: TextFieldCustom(isEnabled: false,textEditingController: _dateController,label:'Date',)),
                  SizedBox(height: 3.h),
                  InkWell(
                    onTap:(){
                      final title = _titleController.text.trim();
                      final description = _descriptionController.text.trim();
                      if (title.isNotEmpty && description.isNotEmpty&&_dateController.text.isNotEmpty) {
                        todoProvider.updateTodo(TodoModel(
                          id: todo.id,
                          userId: '',
                          title: title,
                          description: description,
                          date: selectedDate,
                        ),index);
                        _titleController.clear();
                        _dateController.clear();
                        _descriptionController.clear();
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                        width: double.maxFinite,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius: BorderRadius.circular(8)),
                        child: const Center(child: Text("Submit",style: TextStyle(color: Colors.white),))),
                  ),
                  SizedBox(height: 2.h),
                  InkWell(
                    onTap:(){
                      todoProvider.deleteTodo(todo.id,index);
                      _titleController.clear();
                      _dateController.clear();
                      _descriptionController.clear();
                      Navigator.pop(context);
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                        decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(8)),
                        child: const Center(child: Text("Delete",style: TextStyle(color: Colors.white),))),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
