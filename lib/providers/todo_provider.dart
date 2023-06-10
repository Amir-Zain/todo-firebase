import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_firebase/models/todo_model.dart';
class TodoProvider with ChangeNotifier {
  List<TodoModel> _todos = [];
  List<TodoModel> get todos => _todos;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> fetchTodos() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        Logger().e('no user');
        _todos = [];
      } else {
        final snapshot = await _firestore
            .collection('todos')
            .where('userId', isEqualTo: user.uid)
            .orderBy('date', descending: true)
            .get();
        _todos = snapshot.docs.map((doc) {
          final data = doc.data();
          return TodoModel(
            id: data['id'],
            userId: user.uid,
            title: data['title'],
            description: data['description'],
            date: data['date'].toDate(),
          );
        }).toList();
      }
      notifyListeners();
    } catch (error) {
      print('Error fetching todos: $error');
    }
  }

  Future<void> addTodo(TodoModel todo) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }
      final  ref =  _firestore.collection('todos').doc();
    await  ref.set({
          'userId': user.uid,
          'title': todo.title,
          'id': ref.id,
          'description': todo.description,
          'date': todo.date,
          });
      final newTodo = TodoModel(
        id: ref.id,
        userId: user.uid,
        title: todo.title,
        description: todo.description,
        date: todo.date,
      );
      _todos.add(newTodo);
      notifyListeners();
    } catch (error) {
      print('Error adding todo: $error');
    }
  }

  Future<void> updateTodo(TodoModel todo,int index) async {
    try {
      await _firestore.collection('todos').doc(todo.id).update({
        'title': todo.title,
        'description': todo.description,
        'date': todo.date,
      });
        _todos[index] = todo;
        notifyListeners();
    } catch (error) {
      Logger().e(error);
      print('Error updating todo: $error');
    }
  }

  Future<void> deleteTodo(String todoId,int index) async {
    try {
      await _firestore.collection('todos').doc(todoId).delete();
      _todos.removeAt(index);
      notifyListeners();
    } catch (error) {
      print('Error deleting todo: $error');
    }
  }
}