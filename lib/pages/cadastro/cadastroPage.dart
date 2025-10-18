import 'package:flutter/material.dart';
import 'package:atividadebiblioteca/data/models/livro.dart';
import 'package:atividadebiblioteca/data/repositorio/livroRepositorio.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({Key? key}) : super(key: key);

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _autorController = TextEditingController();
  final TextEditingController _anoController = TextEditingController();
  final TextEditingController _editoraController = TextEditingController();

  bool _isSaving = false;

  @override
  void dispose() {
    _tituloController.dispose();
    _autorController.dispose();
    _anoController.dispose();
    _editoraController.dispose();
    super.dispose();
  }

  Future<void> _salvarLivro() async {
    if (!_formKey.currentState!.validate()) return;

    final String titulo = _tituloController.text.trim();
    final String autor = _autorController.text.trim();
    final String anoText = _anoController.text.trim();
    final String editora = _editoraController.text.trim();

    int ano;
    try {
      ano = int.parse(anoText);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe um ano válido (número).')),
      );
      return;
    }

    final Livro livro = Livro(
      titulo: titulo,
      autor: autor,
      anoPublicacao: ano,
      editora: editora,
    );

    setState(() => _isSaving = true);
    try {
      await LivroRepositorio().addLivro(livro);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Livro salvo com sucesso!')),
      );
      Navigator.of(context).pop(true); // retorna true para indicar salvamento
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Livro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Informe o título' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _autorController,
                decoration: const InputDecoration(
                  labelText: 'Autor',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Informe o autor' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _anoController,
                decoration: const InputDecoration(
                  labelText: 'Ano de Publicação',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Informe o ano de publicação';
                  }
                  if (int.tryParse(v.trim()) == null) {
                    return 'Ano inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _editoraController,
                decoration: const InputDecoration(
                  labelText: 'Editora',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.done,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Informe a editora'
                    : null,
              ),
              const SizedBox(height: 20),

              SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _salvarLivro,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: Text(_isSaving ? 'Salvando...' : 'Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
