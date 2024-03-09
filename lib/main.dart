import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        home: Scaffold(
          body: const Column(
            children: [
              Card(
                child: ListTile(
                  leading: Icon(Icons.monetization_on, color: Colors.green),
                  title: Text('1015-8'),
                  subtitle: Text('R\$ 875,00'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.monetization_on, color: Colors.green),
                  title: Text('2030-7'),
                  subtitle: Text('R\$ 555,00'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.monetization_on, color: Colors.green),
                  title: Text('7890-1'),
                  subtitle: Text('R\$ 1.150,00'),
                ),
              ),
            ],
          ),
          appBar: AppBar(
            backgroundColor: Colors.orange,
            title: const Text(
              'Transferências',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.orange,
            onPressed: () {},
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
