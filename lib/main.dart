import 'dart:convert';
import "package:universal_html/html.dart" as html;
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:radial_button/widget/circle_floating_button.dart';

void main() => runApp(MyApp());

class PlayerStore {
  String name = "";
  int gender = 0;
  int count = 1;
  int finalCash = 0;
  String last = "";

  PlayerStore(String name, int gender, int count, int finalCash, String last) {
    print("$name $gender $count $last $finalCash");
    this.name = name;
    this.gender = gender;
    this.count = count;
    this.last = last;
    this.finalCash = finalCash;
  }

  factory PlayerStore.fromJson(Map<String, dynamic> parsedJson){
    return PlayerStore(
      parsedJson['name'],
      parsedJson['gender'],
      parsedJson['count'],
      parsedJson['finalCash'],
      parsedJson['last'],
    );
  }

  Player playerStore2Player() {
    print("44444444");
    return Player(
      this.name,
      this.gender,
      this.count,
      this.finalCash,
      this.last,
    );
  }
}
class Player {
  String name = "";
  int gender = 0;
  int count = 1;
  int finalCash = 0;
  final last = TextEditingController();
  Player(String name, int gender, int count, int finalCash, [String last]) {
    this.name = name;
    this.gender = gender;
    this.count = count;
    this.finalCash = finalCash;
    this.last.text = last;
  }

  PlayerStore player2PlayerStore() {
    return PlayerStore(
      this.name,
      this.gender,
      this.count,
      this.finalCash,
      this.last.text,
    );
  }


}

class SumaryArguments {
  List<PlayerStore> players;
  String ratio;

  SumaryArguments(this.players, this.ratio);
  
  factory SumaryArguments.fromJson(Map<String, dynamic> parsedJson){
    var list = parsedJson['players'] as List;
    List<PlayerStore> players = list.map((i) => PlayerStore.fromJson(i)).toList();
    return SumaryArguments(
      players,
      parsedJson['ratio'],
    );
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Texas Hold\'em Calculator',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: MyHomePage(title: 'Texas Hold\'em Calculator'),
      // initialRoute: '/',
      // routes: {
      //   '/': (context) => MyHomePage(title: 'Texas Hold\'em Calculator'),
      //   '/sumary': (context) => SumaryPage(),
      // },
      // routes: <String, WidgetBuilder>{
      //   '/': (BuildContext context) {
      //     return MyHomePage(title: 'Texas Hold\'em Calculator');
      //   },
      //   '/sumary': (BuildContext context) {
      //     return SumaryPage();
      //   }
      // },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _newPlayerNameController = TextEditingController();
  final _ratioController = TextEditingController();
  int _gender = 0;
  String _ratio = '200';
  List<Player> _players = <Player>[];

  @override
  void initState() {
    super.initState();
    // SumaryArguments settings;
    if (html.window.localStorage.containsKey('texas_holdem')) {
      var settingString = html.window.localStorage['texas_holdem'];
      print("111111111");
      Map<String, dynamic> settingMap = json.decode(settingString);
      var list = settingMap["players"] as List;
      print("222222222" + json.encode(list));
      List<Player> players = list.map((f) => PlayerStore(f["name"], f["gender"], f["count"], f["finalCash"], f["last"]).playerStore2Player()).toList();
      print("333333333");
      _players = players;
      _ratio = settingMap["ratio"];
    } else {
      Map<String, dynamic> settingMap = {
        "players": [],
        "ratio": _ratio,
      };
      html.window.localStorage['texas_holdem'] = json.encode(settingMap);
    }
    _ratioController.text = _ratio;
  }

  void dispose() {
    _newPlayerNameController.dispose();
    super.dispose();
  }

  void _setPlayerLocalStorage(List<Player> pPlayers) {
    if (html.window.localStorage.containsKey('texas_holdem')) {
      var settingString = html.window.localStorage['texas_holdem'];
      Map<String, dynamic> settingMap = json.decode(settingString);
      var players = pPlayers.map((f) => {
        "name": f.name,
        "gender": f.gender,
        "count": f.count,
        "finalCash": f.finalCash,
        "last": f.last.text,
      }).toList();
      settingMap["players"] = players;
      html.window.localStorage['texas_holdem'] = json.encode(settingMap);
    }
  }

  void _setRatioLocalStorage(String ratio) {
    if (html.window.localStorage.containsKey('texas_holdem')) {
      var settingString = html.window.localStorage['texas_holdem'];
      Map<String, dynamic> settingMap = json.decode(settingString);
      settingMap["ratio"] = ratio;
      html.window.localStorage['texas_holdem'] = json.encode(settingMap);
    }
  }
  
  void _dismissDialog() {
      Navigator.pop(_scaffoldKey.currentContext);
  }

  void handleGenderChanged(StateSetter setState, int value) {
    print('onChanged' + value.toString());
    setState(() {
      _gender = value;
    });
  }

  void _addPlayer() {
    showDialog(
      context: _scaffoldKey.currentContext,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
              title: Text('New Player'),
              content: new SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: new ListBody(
                  children: <Widget>[
                    new TextField(
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      controller: _newPlayerNameController,
                      decoration: new InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Player\'s name',
                      ),
                    ),
                    RadioListTile<int>(
                      dense: true,
                      title: const Text('Male'),
                      value: 0,
                      groupValue: _gender,
                      onChanged: (value) {
                        handleGenderChanged(setState, value);
                      },
                    ),
                    RadioListTile<int>(
                      dense: true,
                      title: const Text('Female'),
                      value: 1,
                      groupValue: _gender,
                      onChanged: (value) {
                        handleGenderChanged(setState, value);
                      },
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: _dismissDialog,
                ),
                FlatButton(
                  child: Text('Confirm'),
                  onPressed: _newPlayer,
                ),
              ],
            );
            },
        );
      },
    );
  }

  void _newPlayer() {
    String name = _newPlayerNameController.text;
    if (name.isEmpty) {
      Toast.show("Please input player's name", _scaffoldKey.currentContext, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM, backgroundColor: Colors.redAccent);
      return;
    }
    int index = _players.indexWhere((player) => player.name == name);
    if (index > -1) {
      Toast.show("Player's name existed", _scaffoldKey.currentContext, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM, backgroundColor: Colors.redAccent);
      return;
    }
    Player newPlayer = new Player(name, _gender, 1, 0);
    setState(() {
      _gender = 0;
      _players.add(newPlayer);
    });
    _setPlayerLocalStorage(_players);
    print("Text field: $newPlayer");
    _dismissDialog();
    _newPlayerNameController.clear();
  }

  void _removePlayer(player) {
    int index = _players.indexOf(player);
    print('delete ' + index.toString());
    if (index > -1) {
      _players.removeAt(index);
      setState(() {
        _players = _players;
      });
      _setPlayerLocalStorage(_players);
    }
    _dismissDialog();
  }

  void _deletePlayer(Player player) {
    showDialog(
      context: _scaffoldKey.currentContext,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Are you sure to delete this player?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: _dismissDialog,
                ),
                FlatButton(
                  child: Text('Confirm'),
                  onPressed: () {
                    _removePlayer(player);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  _settingRatio () {
    setState(() {
      _ratio = _ratioController.text;
    });
    _setRatioLocalStorage(_ratioController.text);
    _dismissDialog();
  }

  void _showRatioSettingDialog() {
    _ratioController.text = _ratio;
    showDialog(
      context: _scaffoldKey.currentContext,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
              title: Text('Ratio Setting'),
              content: new SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: new ListBody(
                  children: <Widget>[
                    new TextField(
                      keyboardType: TextInputType.text,
                      autofocus: true,
                      controller: _ratioController,
                      decoration: new InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Player\'s name',
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: _dismissDialog,
                ),
                FlatButton(
                  child: Text('Confirm'),
                  onPressed: _settingRatio,
                ),
              ],
            );
            },
        );
      },
    );
  }

  Widget _buildPlayerWidget(BuildContext context, Player player) {
    Image image;
    if (player.gender == 0) {
      image = new Image.asset("assets/male.png");
    } else {
      image = new Image.asset("assets/female.png");
    }
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ListTile(
                    leading: image,
                    isThreeLine: true,
                    title: Flex(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        Expanded(
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Expanded(
                                flex: 1,
                                child: Text(player.name, style: TextStyle(color: Colors.black87, fontSize: 20)),
                              ),
                              new Expanded(
                                child: IconButton(
                                  icon: Icon(Icons.remove_circle, color: Colors.deepPurple,),
                                  onPressed: () {
                                    int index = _players.indexOf(player);
                                    if (index > -1) {
                                      _players[index].count -= 1;
                                      setState(() {
                                        _players = _players;
                                      });
                                      _setPlayerLocalStorage(_players);
                                    }
                                  },
                                ),
                              ),
                              Text(player.count.toString(), style: TextStyle(color: Colors.brown, fontSize: 15, fontWeight: FontWeight.bold)),
                              new Expanded(
                                child: IconButton(
                                  icon: Icon(Icons.add_circle, color: Colors.deepPurple,),
                                  onPressed: () {
                                    int index = _players.indexOf(player);
                                    if (index > -1) {
                                      _players[index].count += 1;
                                      setState(() {
                                        _players = _players;
                                      });
                                      _setPlayerLocalStorage(_players);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    subtitle: Flex(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: new InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Last',
                            ),
                            controller: player.last,
                            onChanged: (String value) {
                              int index = _players.indexOf(player);
                              if (index > -1) {
                                _players[index].last.text = value;
                                setState(() {
                                  _players = _players;
                                });
                                _setPlayerLocalStorage(_players);
                              }
                            },
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            icon: Icon(Icons.delete_outline, color: Colors.deepPurple,),
                            // child: Text("Delete", style: TextStyle(color: Colors.deepPurple),),
                            onPressed: () {
                              _deletePlayer(player);
                            },
                          )
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
    );
  }

  @override
  Widget build(BuildContext context) {
    var itemsActionBar = [
      FloatingActionButton(
        heroTag: 'btn1',
        backgroundColor: Colors.pinkAccent,
        onPressed: _addPlayer,
        child: Icon(Icons.add),
      ),
      FloatingActionButton(
        heroTag: 'btn2',
        backgroundColor: Colors.orangeAccent,
        onPressed: _showRatioSettingDialog,
        child: Icon(Icons.attach_money),
      ),
      FloatingActionButton(
        heroTag: 'btn3',
        backgroundColor: Colors.purpleAccent,
        onPressed: () {
          for (var i = 0; i < _players.length; i++) {
            if (_players[i].last.text.isEmpty) {
              Toast.show("Please input the last of ${_players[i].name}'s money", _scaffoldKey.currentContext, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM, backgroundColor: Colors.redAccent);
              return;
            }
          }
          // Navigator.pushNamed(context, '/sumary', arguments: SumaryArguments(_players, _ratio));
          Navigator.push(context, SlideLeftRoute(enterWidget: SumaryPage(_players, _ratio)));
        },
        child: Icon(Icons.check),
      ),
    ];
    Widget body;
    if (_players.isEmpty) {
      body = Center(
        child: Text("To add a player, click add button", style: TextStyle(color: Colors.black87),),
      );
    } else {
      body = Center(
        child: ListView.builder(
          itemCount: _players.length,
          itemBuilder: (context, index) {
            return _buildPlayerWidget(context, _players[index]);
          }
        ),
      );
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (_) {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: body,
        floatingActionButton: CircleFloatingButton.floatingActionButton(
          items: itemsActionBar,
          color: Colors.deepPurple,
          icon: Icons.settings,
          duration: Duration(milliseconds: 500),
          curveAnim: Curves.ease
        ),
      ),
    );
  }
}

class SumaryPage extends StatelessWidget {
  final List<Player> players;
  final String ratio;
  SumaryPage(
    this.players,
    this.ratio,
  );

  Widget _buildFinalPlayerWidget(BuildContext context, Player player) {
    Image image;
    if (player.gender == 0) {
      image = new Image.asset("assets/male.png");
    } else {
      image = new Image.asset("assets/female.png");
    }
    var intRatio = int.tryParse(ratio, radix: 10);
    var intLast = int.tryParse(player.last.text, radix: 10);
    player.finalCash = intLast - (player.count * intRatio);
    Image icon;
    if (player.finalCash >= 0) {
      icon = new Image.asset("assets/win.png", width: 30, height: 30,);
    } else {
      icon = new Image.asset("assets/lose.png", width: 30, height: 30,);
    }
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        leading: image,
        title: Text('${player.name} Final Cash: ${player.finalCash}', style: TextStyle(color: Colors.black87),),
        trailing: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (players.isNotEmpty) {
      print(players[0].name);
      body = Center(
        child: ListView.builder(
          itemCount: players.length,
          itemBuilder: (context, index) {
            return _buildFinalPlayerWidget(context, players[index]);
          }
        ),
      );
    } else {
      body = Center(
        child: Text("No data", style: TextStyle(color: Colors.black87),),
      );
    }
    print(ratio.toString());
    return Scaffold(
      appBar: AppBar(title: Text('Sumary'),),
      body: body,
    );
  }
}

class SlideLeftRoute extends PageRouteBuilder {
  final Widget enterWidget;
  SlideLeftRoute({this.enterWidget})
      : super(
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return enterWidget;
      },
      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        return SlideTransition(
          position: new Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child
        );
      },

  );
}