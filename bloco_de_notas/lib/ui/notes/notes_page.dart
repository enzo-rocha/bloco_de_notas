import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/note.dart';
import '../state/notes_state.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotesState(),
      child: Consumer<NotesState>(
        builder: (_, state, __) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Bloco de notas'),
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      content: SizedBox(
                        width: 100,
                        height: 200,
                        child: Form(
                          key: state.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFormField(
                                controller: state.titleController,
                                decoration: const InputDecoration(
                                  label: Text("Título"),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Campo obrigatório";
                                  }

                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: state.descriptionController,
                                decoration: const InputDecoration(
                                  label: Text("Descrição"),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Campo obrigatório";
                                  }

                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);

                                state.clearFields();
                              },
                              child: const Text("Cancelar"),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (!state.formKey.currentState!.validate()) {
                                  return;
                                }

                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);

                                await state.insert();

                                state.clearFields();

                               // ignore: use_build_context_synchronously
                               ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text("Anotação adicionada com sucesso"),
                                  ),
                                );
                              },
                              child: const Text("Inserir"),
                            ),
                          ],
                        )
                      ],
                    );
                  },
                );
              },
            ),
            body: SingleChildScrollView(
              child: SafeArea(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: const _NotesList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NotesList extends StatelessWidget {
  const _NotesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<NotesState>(context);

    return state.isLoading
        ? const Center(child: CircularProgressIndicator())
        : state.notesList.isNotEmpty
            ? ListView.builder(
                itemCount: state.notesList.length,
                itemBuilder: (context, index) {
                  final note = state.notesList[index];

                  return _NoteItem(
                    note: note,
                  );
                },
              )
            : const Center(
                child: Text("Nenhuma anotação."),
              );
  }
}

class _NoteItem extends StatelessWidget {
  const _NoteItem({
    Key? key,
    required this.note,
  }) : super(key: key);

  final Note note;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<NotesState>(context);

    return Card(
      color: Colors.blueGrey,
      child: ListTile(
        title: Text(note.title ?? ''),
        subtitle: Text(note.description ?? ''),
        trailing: SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        content: SizedBox(
                          width: 100,
                          height: 200,
                          child: Form(
                            key: state.formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextFormField(
                                  controller: state.titleController,
                                  decoration: const InputDecoration(
                                    label: Text("Título"),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Campo obrigatório";
                                    }

                                    return null;
                                  },
                                ),
                                TextFormField(
                                  controller: state.descriptionController,
                                  decoration: const InputDecoration(
                                    label: Text("Descrição"),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Campo obrigatório";
                                    }

                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);

                                  state.clearFields();
                                },
                                child: const Text("Cancelar"),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (!state.formKey.currentState!.validate()) {
                                    return;
                                  }

                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(state.formKey.currentContext!);

                                  await state.update(note.id ?? 0);

                                  state.clearFields();


                                },
                                child: const Text("Alterar"),
                              ),
                            ],
                          )
                        ],
                      );
                    },
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  await state.delete(note.id ?? 0);


                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
