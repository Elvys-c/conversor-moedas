import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = 'https://api.hgbrasil.com/finance?format=json&key=fa781f8e';

void main() async {


  runApp(MaterialApp(
    home: Home(),
      theme: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          )
      )
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realControler = TextEditingController();
  final dolarControler = TextEditingController();
  final euroControler = TextEditingController();
  final bitcoinControler = TextEditingController();

  double dolar;
  double euro;
  double bitcoin;

  void _clearAll(){
    realControler.text = "";
    dolarControler.text = "";
    euroControler.text = "";
    bitcoinControler.text = "";

  }

  void _realChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }

    double real = double.parse(text);

    dolarControler.text = (real/dolar).toStringAsFixed(2);
    euroControler.text = (real/euro).toStringAsFixed(2);
    bitcoinControler.text = (real/bitcoin).toStringAsFixed(8);
  }

  void _dolarChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }

    double dolar = double.parse(text);

    realControler.text = (dolar * this.dolar).toStringAsFixed(2);
    euroControler.text = (dolar * this.dolar / euro).toStringAsFixed(2);
    bitcoinControler.text = (dolar * this.dolar / bitcoin).toStringAsFixed(8);
  }

  void _euroChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }

    double euro = double.parse(text);

    realControler.text = (euro * this.euro).toStringAsFixed(2);
    dolarControler.text = (euro * this.euro / dolar).toStringAsFixed(2);
    bitcoinControler.text = (euro * this.euro / bitcoin).toStringAsFixed(8);
  }

  void _bitcoinChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }

    double btc = double.parse(text);

    realControler.text = (btc * this.bitcoin).toStringAsFixed(2);
    dolarControler.text = (btc * this.bitcoin / dolar).toStringAsFixed(2);
    euroControler.text = (btc * this.bitcoin / euro).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text("Carregando Dados...",
                  style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25.0),
                  textAlign: TextAlign.center,)
              );
            default:
              if(snapshot.hasError){
                return Center(
                    child: Text("Erro ao Carregar Dados :(",
                        style: TextStyle(color: Colors.amber,
                            fontSize: 25.0),
                        textAlign: TextAlign.center,)
                );
              }
              else{
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                bitcoin = snapshot.data["results"]["currencies"]["BTC"]["buy"];

                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on, size: 150.0, color: Colors.amber),
                      buildTextFild("Reais", "R\$: ", realControler, _realChanged),
                      Divider(),
                      buildTextFild("Dólares", "USD: ", dolarControler, _dolarChanged),
                      Divider(),
                      buildTextFild("Euros", "€: ", euroControler, _euroChanged),
                      Divider(),
                      buildTextFild("Bitcoin", "BTC: ", bitcoinControler, _bitcoinChanged),
                    ],
                  ),
                );
              }
          }
        }),
    );
  }
}


Widget buildTextFild(String labelCoin, String prefix, TextEditingController control, Function changed){
  return TextField(
    controller: control,
    decoration: InputDecoration(
      labelText: labelCoin,
      labelStyle: TextStyle(color: Colors.amber),
      border: OutlineInputBorder(),
      prefixText: prefix,
      prefixStyle: TextStyle(color: Colors.amber),
    ),
    style: TextStyle(
        color: Colors.amber, fontSize: 25.0
    ),
    onChanged: changed,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
  );
}

