import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/models/livro.dart';
import '../../data/repositorio/livroRepositorio.dart';
import '../cadastro/cadastroPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Livros'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Sobre'),
            ),
          ],
        ),
      ),
      body: ValueListenableBuilder<Box<Livro>>(
        valueListenable: Hive.box<Livro>(LivroRepositorio.boxName).listenable(),
        builder: (context, box, _) {
          if (box.values.isEmpty) {
            return const Center(child: Text('Nenhum livro cadastrado.'));
          }
          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              final livro = box.getAt(index)!;
              return ListTile(
                title: Text(livro.titulo),
                subtitle: Text(livro.autor),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CadastroPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}