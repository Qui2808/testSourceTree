import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String host = "https://vn-public-apis.fpo.vn/provinces/";

  List<dynamic> cityData = [];

  @override
  void initState() {
    super.initState();
    fetchCityData();
  }

  Future<void> fetchCityData() async {
    try {
      final response = await http.get(Uri.parse(host + "getAll?limit=-1"));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
          // final List<dynamic> data = responseData["data"];
          setState(() {
            cityData = responseData['data']['data'];
          });
          print(cityData[0]['name_with_type'].toString());
        }
      } else {
        throw Exception('Failed to load data from API');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách tỉnh thành'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: cityData.length,
          itemBuilder: (context, index) {
            final province = cityData[index];
            final provinceNameWithType = province["name_with_type"];
            // print(provinceNameWithType);
            return ListTile(
              title: Text(provinceNameWithType,
                style: TextStyle(color: Colors.black),
              ),

            );
          },
        ),
      ),
    );
  }
}
