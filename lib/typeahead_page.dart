import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class TypeaheadPage extends StatefulWidget {
  const TypeaheadPage({Key? key}) : super(key: key);

  @override
  _TypeaheadPageState createState() => _TypeaheadPageState();
}

class _TypeaheadPageState extends State<TypeaheadPage> {
  final TextEditingController _typeAheadController = TextEditingController();
  final TextEditingController typeAheadController = TextEditingController();
  CupertinoSuggestionsBoxController _suggestionsBoxController =
      CupertinoSuggestionsBoxController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: CupertinoTypeAheadFormField(
                getImmediateSuggestions: true,
                suggestionsBoxController: _suggestionsBoxController,
                textFieldConfiguration: CupertinoTextFieldConfiguration(
                  controller: _typeAheadController,
                ),
                suggestionsCallback: (pattern) {
                  return Future.delayed(
                    Duration(seconds: 1),
                    () => CitiesService.getSuggestions(pattern),
                  );
                },
                itemBuilder: (context, String suggestion) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      suggestion,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  );
                },
                onSuggestionSelected: (String suggestion) {
                  _typeAheadController.text = suggestion;
                },
                validator: (value) =>
                    value!.isEmpty ? 'Please select a city' : null,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: typeAheadController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '検索',
                ),
              ),
              suggestionsCallback: (pattern) async {
                return await BackendService.getSuggestions(pattern);
              },
              itemBuilder: (context, Map<String, String> suggestion) {
                return ListTile(
                  leading: Icon(Icons.shopping_cart),
                  title: Text(suggestion['name']!),
                  subtitle: Text('\$${suggestion['price']}'),
                );
              },
              onSuggestionSelected: (Map<String, String> suggestion) {
                typeAheadController.text = suggestion['name']!;
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CitiesService {
  static final List<String> cities = [
    'Beirut',
    'Damascus',
    'San Fransisco',
    'Rome',
    'Los Angeles',
    'Madrid',
    'Bali',
    'Barcelona',
    'Paris',
    'Bucharest',
    'New York City',
    'Philadelphia',
    'Sydney',
  ];

  static List<String> getSuggestions(String query) {
    List<String> matches = <String>[];
    matches.addAll(cities);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}

class BackendService {
  static Future<List<Map<String, String>>> getSuggestions(String query) async {
    await Future<void>.delayed(Duration(seconds: 1));

    return List.generate(3, (index) {
      return {
        'name': query + index.toString(),
        'price': Random().nextInt(100).toString()
      };
    });
  }
}
