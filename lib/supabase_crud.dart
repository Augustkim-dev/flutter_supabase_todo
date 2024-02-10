import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseCRUD extends StatelessWidget {
  SupabaseCRUD({super.key});

  final supabase = Supabase.instance.client;

  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CRUD')),
      body: Container(
        child: StreamBuilder(
          stream: supabase.from('todo').stream(primaryKey: ['id']).order('id'),
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
                  // title: Text(todos[index]['todo']),
                  title: Row(
                    children: [
                      Text(todos[index]['id'].toString()),
                      Text('   |    '),
                      Text(todos[index]['todo']),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 수정버튼
                      Flexible(
                          child: IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (contet) {
                                      return AlertDialog(
                                        title: Text('Edit todo'),
                                        content: TextField(
                                          controller: textController,
                                          decoration: InputDecoration(
                                            hintText: todos[index]['todo'],
                                          ),
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Icon(Icons.cancel),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              await supabase
                                                  .from('todo')
                                                  .update({
                                                    'todo': textController.text
                                                  })
                                                  .eq('id', todos[index]['id'])
                                                  .then((value) {
                                                    textController.clear();
                                                    Navigator.pop(context);
                                                  });
                                            },
                                            child: Icon(Icons.edit),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              icon: Icon(Icons.edit))),
                      // 삭제 버튼
                      Flexible(
                          child: IconButton(
                              onPressed: () async {
                                await supabase
                                    .from('todo')
                                    .delete()
                                    .eq('id', todos[index]['id']);
                              },
                              icon: Icon(Icons.delete))),
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
                        await supabase.from('todo').insert(
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
