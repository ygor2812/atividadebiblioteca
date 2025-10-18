import 'package:hive/hive.dart';
import '../models/livro.dart';

class LivroRepositorio{
  static const boxName = 'livros';
  Box<Livro> get _box => Hive.box<Livro>(boxName); 
  Future<void> addLivro(Livro livro) async{
    await _box.add(livro);
  }
  List<Livro> getAllLivros(){
    return _box.values.toList();
  }
}