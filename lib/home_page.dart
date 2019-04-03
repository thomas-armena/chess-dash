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
    return Text(this.maxScore.toString());
  }

  Widget _buildTitle(){
    return Text('Chess Dash');
  }

  Widget _buildPlayButton(BuildContext context){
    return RaisedButton(
      child: Text('Play'),
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