import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseCRUD extends StatelessWidget {
  SupabaseCRUD({super.key});

  final supabse = Supabase.instance.client;

  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CRUD')),
      body: Container(
        child: StreamBuilder(
          stream: supabse.from('todo').stream(primaryKey: ['id']),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Text('Error 001');
            }

            final todos = snapshot.data!;

            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(
                    Icons.check_circle,
                    color: todos[index]['check'] ?? true
                        ? Colors.green
                        : Colors.grey,
                  ),
                  title: Text(todos[index]['todo']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                          child: IconButton(
                              onPressed: () {}, icon: Icon(Icons.edit))),
                      Flexible(
                          child: IconButton(
                              onPressed: () {}, icon: Icon(Icons.delete))),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('input'),
                content: TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    hintText: 'input todo',
                  ),
                ),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('CANCEL')),
                  ElevatedButton(
                      onPressed: () async {
                        await supabse.from('todo').insert(
                            {'todo': textController.text}).then((value) {
                          textController.clear();
                          Navigator.pop(context);
                        });
                      },
                      child: Text('ADD')),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
