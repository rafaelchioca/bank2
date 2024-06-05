import 'package:banco/main.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> createDatabase() {
  return getDatabasesPath().then(
    (dbPath) {
      final String path = join(
        dbPath,
        'bankapp.db',
      );
      return openDatabase(
        path,
        onCreate: (db, version) {
          db.execute('CREATE TABLE contatos('
              'id INTEGER PRIMARY KEY,'
              'nome TEXT,'
              'numeroConta INTEGER)');
        },
        version: 1,
        // onDowngrade: onDatabaseDowngradeDelete,
      );
    },
  );
}

Future<int> save(Contato contato) {
  return createDatabase().then(
    (db) {
      final Map<String, dynamic> contatoMap = {};
      // contatoMap['id'] = contato.id;
      contatoMap['nome'] = contato.nome;
      contatoMap['numeroConta'] = contato.numeroConta;
      return db.insert('contatos', contatoMap);
    },
  );
}

Future<List<Contato>> findAll() {
  return createDatabase().then(
    (db) {
      return db.query('contatos').then(
        (maps) {
          final List<Contato> contatos = [];
          for (Map<String, dynamic> map in maps) {
            final Contato contato = Contato(
              map['id'],
              map['nome'],
              map['numeroConta'],
            );
            contatos.add(contato);
          }
          return contatos;
        },
      );
    },
  );
}
