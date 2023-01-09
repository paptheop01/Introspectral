import 'main.dart';
import 'habit.dart';
import 'package:flutter/material.dart';

class ViewEditHabitWidget extends StatefulWidget {
  const ViewEditHabitWidget({Key? key}) : super(key: key);

  @override
  _ViewEditHabitWidgetState createState() => _ViewEditHabitWidgetState();
}

class _ViewEditHabitWidgetState extends State<ViewEditHabitWidget> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 202, 212, 211),
      appBar: AppBar(
        title: const Text('View/Edit Habit'),
      ),
      body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                      hintText: 'Title',
                      border: OutlineInputBorder(borderSide: BorderSide())),
                  controller: _titleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Title cannot by empty';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  minLines: 2,
                  maxLines: 10,
                  decoration: const InputDecoration(
                      hintText: 'Goal',
                      border: OutlineInputBorder(borderSide: BorderSide())),
                  controller: _descriptionController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    const Flexible(fit: FlexFit.tight, child: SizedBox()),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.blue),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        child: const Text(
                          'Save',
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final habit = Habit(
                                title: _titleController.text,
                                goal: 5, //int(_descriptionController.text) ,

                                completed: 0);

                            Navigator.pop(context, habit);
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
