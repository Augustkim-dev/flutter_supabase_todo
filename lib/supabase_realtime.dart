import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseRealTime extends StatelessWidget {
  SupabaseRealTime({super.key});

  final supabse = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('RealTime')),
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
                );
              },
            );
          },
        ),
      ),
    );
  }
}
