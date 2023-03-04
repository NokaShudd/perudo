import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String name = "Player";
String? gameID;

List<String> diceImage = [
  'assets/images/dice1bis.svg',
  // SvgPicture.asset('assets/images/dice1.svg'),
  'assets/images/dice2.svg',
  'assets/images/dice3.svg',
  'assets/images/dice4.svg',
  'assets/images/dice5.svg',
  'assets/images/dice6.svg',
];

List<String> diceImageBlack = [
  // SvgPicture.asset('assets/images/dice1back.svg'),
  'assets/images/dice1bisback.svg',
  'assets/images/dice2back.svg',
  'assets/images/dice3back.svg',
  'assets/images/dice4back.svg',
  'assets/images/dice5back.svg',
  'assets/images/dice6back.svg',
];

List<Color> allColors = [
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
  Colors.red,
  Colors.pink,
  Colors.brown,
  Colors.grey,
  Colors.blueGrey,
];

StreamController<QuickTheme> quickTheme = StreamController();

class QuickTheme {
  const QuickTheme({
    required this.color,
    required this.brightness,
    required this.lang,
  });

  final Color color;
  final ThemeMode brightness;
  final String lang;
}

QuickTheme? currentTheme;

const initialTheme = QuickTheme(
  color: Colors.teal,
  brightness: ThemeMode.system,
  lang: 'fr',
);

Future<QuickTheme> readData() async {
  try {
    Directory dir = await getApplicationDocumentsDirectory();
    File save = File('${dir.path}/saved.json');

    try {
      String rawJson = await save.readAsString();
      Map<String, dynamic> map = jsonDecode(rawJson);
      name = map['name'];
      currentTheme = mapToTheme(map);
      return currentTheme!;
    } catch (e) {
      save.writeAsString(jsonEncode(themeToMap(initialTheme, name)));
    }
  } catch (_) {}
  return initialTheme;
}

Future<void> writeData() async {
  try {
    Directory dir = await getApplicationDocumentsDirectory();
    File save = File('${dir.path}/saved.json');
    save.writeAsString(jsonEncode(themeToMap(currentTheme!, name)));
  } catch (e) {
    print(e);
  }
}

Map<String, dynamic> themeToMap(QuickTheme quickTheme, String name) {
  return {
    'color': quickTheme.color.value,
    'lang': quickTheme.lang,
    'brightness': quickTheme.brightness.index,
    'name': name,
  };
}

QuickTheme mapToTheme(Map<String, dynamic> map) {
  return QuickTheme(
    color: Color(map["color"]),
    brightness: ThemeMode.values[map["brightness"]],
    lang: map["lang"],
  );
}

User? user;

Future<User?> anonymeAuth() async {
  try {
    final userCredential = await FirebaseAuth.instance.signInAnonymously();
    return userCredential.user;
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "operation-not-allowed":
        print("Anonymous auth hasn't been enabled for this project.");
        break;
      default:
        print("Unknown error.");
    }
  }
  return null;
}

class FirebaseService {
  final databaseReference = FirebaseFirestore.instance;

  List<int> getDices(int numbers) {
    Random random = Random();
    return Iterable.generate(numbers, (numb) => random.nextInt(6)).toList();
  }

  Future<void> launchGame(Map<String, dynamic> data, String gameId) async {
    List<int> order = Iterable.generate(
      data['players'].length,
      (value) => value,
    ).toList();

    int numbDices = data['maxDice'];

    for (var element in data['players']) {
      element['dices'] = getDices(
        numbDices,
      );
    }

    order.shuffle();
    await databaseReference.collection('game').doc(gameId).update({
      'order': order,
      'players': data['players'],
    });
  }

  Stream<QuerySnapshot> getGames() {
    return databaseReference
        .collection('game')
        .where('started', isEqualTo: false)
        .snapshots();
  }

  Stream<DocumentSnapshot> getGame(String gameId) {
    return databaseReference.collection("game").doc(gameId).snapshots();
  }

  void startGame(String gameId) {
    databaseReference.collection('game').doc(gameId).update({'started': true});
  }

  Future<void> deleteGame(String gameId) {
    databaseReference.collection('chat').doc(gameId).delete();
    return databaseReference.collection('game').doc(gameId).delete();
  }

  Future<void> quitGame(String gameId, String userId) async {
    final doc = databaseReference.collection('game').doc(gameId);
    final List players = await doc.get().then(
          (value) => value.get('players') as List,
        );
    int playersAlive = await doc.get().then(
          (value) => value.get('playersAlive'),
        );
    players.removeWhere((element) => element['userUid'] == userId);
    if (playersAlive <= 0) {
      playersAlive = 1;
      deleteGame(gameId);
      return;
    }
    doc.update({'players': players, 'playersAlive': playersAlive - 1});
  }

  Future<void> play(int value, int number, String userId, String gameId) async {
    final doc = databaseReference.collection('game').doc(gameId);

    final data = await doc.get().then(
          (value) => value.data() as Map<String, dynamic>,
        );

    int turn = data['turn'] + 1;

    if (data['playersAlive'] > 1) {
      for (var i = 0; i < data['players'].length; i++) {
        if (!data['players'][(turn + i) % data['players'].length]['alive']) {
          turn++;
        } else {
          break;
        }
      }
    }

    doc.update({
      'turn': (turn) % data['players'].length,
      'lastGuess': {
        'lastPlayerUid': userId,
        'value': value,
        'number': number,
      },
    });
  }

  Future<void> dudo(String gameId, String userId) async {
    final doc = databaseReference.collection('game').doc(gameId);

    final data = await doc.get().then(
          (value) => value.data() as Map<String, dynamic>,
        );

    await doc.update({'checking': true});

    int value = data['lastGuess']['value'];
    int number = data['lastGuess']['number'];
    int realNumber = 0;

    List players = data['players'];

    int deadDiceCount = data['deadDiceCount'];

    for (var i = 0; i < players.length; i++) {
      if (!players[i]['alive']) {
        continue;
      }
      for (var element in players[i]['dices']) {
        if (element == value) {
          realNumber++;
        }
      }
    }

    List newPlayers = [];

    if (realNumber >= number) {
      print('good guess');
      await Future.delayed(const Duration(seconds: 1));

      for (var element in players) {
        Map<String, dynamic> player = element;

        if (element['userUid'] == userId) {
          player['deadDices']++;
          if (player['deadDices'] >= element['dices'].length) {
            player['alive'] = false;
          }
        }
        player['dices'] = getDices(data['maxDice'] - player['deadDices']);

        newPlayers.add(element);
      }
      await doc.update({
        'checking': false,
        'players': newPlayers,
        'deadDiceCount': deadDiceCount + 1,
        'lastGuess': {
          'lastPlayerUid': null,
        },
      });
    } else {
      print("good dudo");
      await Future.delayed(const Duration(seconds: 1));

      for (var element in players) {
        Map<String, dynamic> player = element;
        if (element['userUid'] == data['lastGuess']['lastPlayerUid']) {
          player['deadDices']++;
          if (player['deadDices'] >= element['dices'].length) {
            player['alive'] = false;
          }
        }
        player['dices'] = getDices(data['maxDice'] - player['deadDices']);
        newPlayers.add(element);
      }
      await doc.update(
        {
          'checking': false,
          'players': newPlayers,
          'turn': (data['turn'] - 1) % data['players'].length,
          'deadDiceCount': deadDiceCount + 1,
          'lastGuess': {
            'lastPlayerUid': null,
          },
        },
      );
    }
  }

  Future<void> sendMessage(String gameId, String text) async {
    await databaseReference
        .collection('chat')
        .doc(gameId)
        .collection('messages')
        .add({
      'message': text,
      'sendBy': name,
      'sendAt': DateTime.now(),
      'sendByUid': user!.uid,
    });

    await databaseReference.collection('game').doc(gameId).update({
      'lastMessage': {
        'message': text,
        'sendBy': name,
      },
    });
  }

  Stream<QuerySnapshot> getMessages(String gameId) {
    return databaseReference
        .collection('chat')
        .doc(gameId)
        .collection('messages')
        .orderBy('sendAt', descending: true)
        .snapshots();
  }

  Future<void> joinGame(String gameId, String userId) async {
    final doc = databaseReference.collection('game').doc(gameId);
    final List players = await doc.get().then(
          (value) => value.get('players') as List,
        );

    int playersAlive = await doc.get().then(
          (value) => value.get('playersAlive'),
        );
    if (!players.any((element) => element["userUid"] == userId)) {
      players.add({
        'userUid': userId,
        'alive': true,
        'dices': [],
        'name': name,
        'lastSeenChat': DateTime.now(),
        'unRead': 0,
        'deadDices': 0,
      });
      doc.update({'players': players, 'playersAlive': playersAlive + 1});
    }
  }

  Future<String> createGame(
    String roomName,
    bool public,
    String password,
    bool useDiceCount,
    bool useDiceDeadCount,
    int maxPlayer,
    int maxDice,
    int roundTotal,
    bool isPacoBonus,
    bool isCalzaPossible,
  ) async {
    final doc = await databaseReference.collection("game").add(
      {
        'name': roomName,
        'checking': false,
        'isPublic': public,
        'password': password,
        'useDiceCount': useDiceCount,
        'useDiceDeadCount': useDiceDeadCount,
        'deadDiceCount': 0,
        'maxPlayer': maxPlayer,
        'started': false,
        'maxDice': maxDice,
        'round': 0,
        'roundTotal': roundTotal,
        'isPacoBonus': isPacoBonus,
        'isCalzaPossible': isCalzaPossible,
        'playerCalzaUid': null,
        'turn': 0,
        'playersAlive': 1,
        'order': [],
        'lastMessage': {
          'message': 'startedTheGame'.tr,
          'sendBy': 'system'.tr,
        },
        'lastGuess': {
          'lastPlayerUid': null,
        },
        'players': [
          {
            'userUid': user!.uid,
            'alive': true,
            'name': name,
            'dices': [],
            'lastSeenChat': DateTime.now(),
            'unRead': 0,
            'deadDices': 0,
          },
        ],
        'mod': user!.uid,
      },
    );
    return doc.id;
  }
}
