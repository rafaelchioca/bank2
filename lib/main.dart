import 'package:flutter/material.dart';
import 'package:banco/app_database.dart';

void main() {
  runApp(
    const BankApp(),
  );
}

class BankApp extends StatelessWidget {
  const BankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 56, 168, 1.0),
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
                'https://asbraf.com/wp-content/uploads/2020/04/bb3.png'),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ListaContatos(),
                  ),
                );
              },
              child: Container(
                height: 140,
                width: 120,
                padding: const EdgeInsets.all(8.0),
                color: const Color.fromRGBO(0, 56, 168, 1.0),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.people,
                      color: Colors.white,
                      size: 30,
                    ),
                    Text(
                      'Contatos',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListaContatos extends StatefulWidget {
  const ListaContatos({super.key});

  @override
  _ListaContatosState createState() => _ListaContatosState();
}

class _ListaContatosState extends State<ListaContatos> {
  final List<Contato> contatos = [];

  @override
  void initState() {
    super.initState();
    _reloadContacts();
  }

  void _reloadContacts() {
    findAll().then((contacts) {
      setState(() {
        contatos.clear();
        contatos.addAll(contacts);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 56, 168, 1.0),
        title: const Text(
          'Contatos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<List<Contato>>(
        future: findAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Erro ao carregar contatos'),
            );
          } else if (snapshot.hasData) {
            final List<Contato> contatos = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: contatos.length,
              itemBuilder: (context, index) {
                final Contato contato = contatos[index];
                return _ContatoItem(contato);
              },
            );
          } else {
            return const Center(
              child: Text('Nenhum contato encontrado'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(0, 56, 168, 1.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FormularioContatos(),
            ),
          ).then((_) => _reloadContacts());
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 35.0,
        ),
      ),
    );
  }
}

class FormularioContatos extends StatefulWidget {
  const FormularioContatos({super.key});

  @override
  _FormularioContatosState createState() => _FormularioContatosState();
}

class _FormularioContatosState extends State<FormularioContatos> {
  final TextEditingController _controladorNome = TextEditingController();
  final TextEditingController _controladorNumeroConta = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 56, 168, 1.0),
        title: const Text(
          'Novo Contato',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controladorNome,
              decoration: const InputDecoration(
                labelText: 'Nome Completo',
              ),
              style: const TextStyle(
                fontSize: 24.0,
              ),
            ),
            TextField(
              controller: _controladorNumeroConta,
              decoration: const InputDecoration(
                labelText: 'Número da Conta',
              ),
              style: const TextStyle(
                fontSize: 24.0,
              ),
              keyboardType: TextInputType.number,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      const Color.fromRGBO(0, 56, 168, 1.0),
                    ),
                  ),
                  onPressed: () {
                    final String nome = _controladorNome.text;
                    final int? numeroConta =
                        int.tryParse(_controladorNumeroConta.text);
                    final Contato novoContato = Contato(0, nome, numeroConta);
                    save(novoContato).then((id) {
                      Navigator.pop(context, novoContato);
                    });
                  },
                  child: const Text(
                    'Salvar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Contato {
  final int id;
  final String nome;
  final int? numeroConta;

  Contato(this.id, this.nome, this.numeroConta);

  @override
  String toString() {
    return 'Contato{id: $id, nome: $nome, numeroConta: $numeroConta}';
  }
}

class _ContatoItem extends StatelessWidget {
  final Contato contato;

  const _ContatoItem(this.contato);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          contato.nome,
          style: const TextStyle(fontSize: 24.0),
        ),
        subtitle: Text(
          contato.numeroConta.toString(),
          style: const TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
