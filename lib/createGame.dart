import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:perudo/firebaseLogic.dart';

class CreateGamePage extends StatefulWidget {
  const CreateGamePage({
    super.key,
  });

  @override
  State<CreateGamePage> createState() => _CreateGamePageState();
}

class _CreateGamePageState extends State<CreateGamePage> {
  TextEditingController name = TextEditingController();
  bool isPublic = true;
  TextEditingController passWord = TextEditingController();
  double numbPlayer = 6;
  double numbDice = 5;
  double numbRound = 1;
  bool isPacoBonus = false;
  bool isCalzaPossible = false;
  bool useDiceCount = false;
  bool useDiceDeadCount = false;

  void showSnack(String txt) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(txt.tr)),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color textDisativated = Theme.of(context).disabledColor;
    Color textEnabled = Theme.of(context).colorScheme.onPrimaryContainer;
    return Scaffold(
      appBar: AppBar(
        title: Text('createGame'.tr),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (name.value.text.isEmpty) {
            return showSnack('needName'.tr);
          }
          if (!isPublic && passWord.value.text.isEmpty) {
            return showSnack('needPassword'.tr);
          }
          gameID = await FirebaseService().createGame(
            name.value.text,
            isPublic,
            passWord.value.text,
            useDiceCount,
            useDiceDeadCount,
            numbPlayer.toInt(),
            numbDice.toInt(),
            numbRound.toInt(),
            isPacoBonus,
            isCalzaPossible,
          );
          // ignore: use_build_context_synchronously
          Navigator.popAndPushNamed(context, 'game');
        },
        child: const FaIcon(FontAwesomeIcons.check),
      ),
      body: ListView(
        padding: const EdgeInsets.all(4.0),
        children: [
          ListTile(
            title: Text('roomName'.tr),
            subtitle: TextField(
              controller: name,
            ),
          ),
          ListTile(
            title: Text('isPublic'.tr),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'no'.tr,
                  style: TextStyle(
                      color: isPublic ? textDisativated : textEnabled),
                ),
                Switch(
                  value: isPublic,
                  onChanged: (newBool) => setState(
                    () {
                      isPublic = newBool;
                    },
                  ),
                ),
                Text(
                  'yes'.tr,
                  style: TextStyle(
                      color: !isPublic ? textDisativated : textEnabled),
                ),
              ],
            ),
          ),
          (!isPublic)
              ? ListTile(
                  title: Text('password'.tr),
                  subtitle: TextField(
                    controller: passWord,
                  ),
                )
              : const SizedBox.shrink(),
          ListTile(
            title: Text('numbPlayer'.tr),
            subtitle: Slider(
              value: numbPlayer,
              onChanged: (newValue) => setState(() {
                numbPlayer = newValue;
              }),
              label: numbPlayer.round().toString(),
              min: 3,
              max: 9,
              divisions: 6,
            ),
          ),
          ListTile(
            title: Text('numbDice'.tr),
            subtitle: Slider(
              value: numbDice,
              onChanged: (newValue) => setState(() {
                numbDice = newValue;
              }),
              min: 4,
              max: 10,
              label: numbDice.round().toString(),
              divisions: 6,
            ),
          ),
          ListTile(
            title: Text('numbRound'.tr),
            subtitle: Slider(
              value: numbRound,
              onChanged: (newValue) => setState(() {
                numbRound = newValue;
              }),
              min: 1,
              max: 5,
              label: numbRound.round().toString(),
              divisions: 4,
            ),
          ),
          ListTile(
            title: Text('isPacoBonus'.tr),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'no'.tr,
                  style: TextStyle(
                      color: isPacoBonus ? textDisativated : textEnabled),
                ),
                Switch(
                  value: isPacoBonus,
                  onChanged: (newBool) => setState(
                    () {
                      isPacoBonus = newBool;
                    },
                  ),
                ),
                Text(
                  'yes'.tr,
                  style: TextStyle(
                      color: !isPacoBonus ? textDisativated : textEnabled),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('isCalzaPossible'.tr),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'no'.tr,
                  style: TextStyle(
                      color: isCalzaPossible ? textDisativated : textEnabled),
                ),
                Switch(
                  value: isCalzaPossible,
                  onChanged: (newBool) => setState(
                    () {
                      isCalzaPossible = newBool;
                    },
                  ),
                ),
                Text(
                  'yes'.tr,
                  style: TextStyle(
                      color: !isCalzaPossible ? textDisativated : textEnabled),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('useDiceDeadCount'.tr),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'no'.tr,
                  style: TextStyle(
                      color: useDiceDeadCount ? textDisativated : textEnabled),
                ),
                Switch(
                  value: useDiceDeadCount,
                  onChanged: (newBool) => setState(
                    () {
                      useDiceDeadCount = newBool;
                    },
                  ),
                ),
                Text(
                  'yes'.tr,
                  style: TextStyle(
                      color: !useDiceDeadCount ? textDisativated : textEnabled),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('useDiceCount'.tr),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'no'.tr,
                  style: TextStyle(
                      color: useDiceCount ? textDisativated : textEnabled),
                ),
                Switch(
                  value: useDiceCount,
                  onChanged: (newBool) => setState(
                    () {
                      useDiceCount = newBool;
                    },
                  ),
                ),
                Text(
                  'yes'.tr,
                  style: TextStyle(
                      color: !useDiceCount ? textDisativated : textEnabled),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
