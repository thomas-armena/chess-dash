import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  int maxScore;

  void initState(){
    super.initState();
    maxScore = 0;
    this._updateMaxScore();
  } 

  _updateMaxScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.setState((){
      maxScore = prefs.getInt('maxScore') ?? 0;
    });
  }

  Widget _buildScore(){
    return Text(
      this.maxScore.toString(),
      style: TextStyle(
        fontSize: 20.0,
      ),
    );
  }

  Widget _buildTitle(){
    return Text(
      'Chess Dash',
      style: TextStyle(
        fontSize: 30.0,
      ),
    );
  }

  Widget _buildPlayButton(BuildContext context){
    return MaterialButton(
      child: Text(
        'Play',
        style: TextStyle(
          fontSize: 25.0,
        ),
      ),
      color: Colors.blue,
      textColor: Colors.white,
      padding: EdgeInsets.all(10.0),
      onPressed: (){
        Navigator.of(context).pushNamed("/GameView");
      },
    );
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:<Widget>[
            this._buildScore(),
            this._buildTitle(),
            this._buildPlayButton(context),
          ]
        ),
      ),
    );
  }

}