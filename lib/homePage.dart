import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'firebaseLogic.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    FlutterNativeSplash.remove();
    super.initState();
  }

  int index = 0;
  FirebaseService firebaseService = FirebaseService();
  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(body: Center(child: Text("Error")));
    }
    return Scaffold(
      body: [
        FirstScreen(goToGames: () => setState(() => index = 1)),
        SecondScreen(firebaseService: firebaseService),
        const ThirdScreen(),
      ][index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (int newIndex) => setState(() {
          index = newIndex;
        }),
        items: [
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.house),
            label: 'home'.tr,
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.gamepad),
            label: 'game'.tr,
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.gear),
            label: 'settings'.tr,
          )
        ],
      ),
      floatingActionButton: (index == 1)
          ? FloatingActionButton(
              onPressed: () {
                if (name == 'Player') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('userName'.tr),
                      action: SnackBarAction(
                        label: 'useAnyway'.tr,
                        onPressed: () {
                          Navigator.pushNamed(context, 'createGame');
                        },
                      ),
                    ),
                  );
                } else {
                  Navigator.pushNamed(context, 'createGame');
                }
              },
              child: const FaIcon(FontAwesomeIcons.plus),
            )
          : null,
    );
  }
}

class ThirdScreen extends StatefulWidget {
  const ThirdScreen({
    super.key,
  });

  @override
  State<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  TextEditingController nameController = TextEditingController(text: name);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        if (kIsWeb) Text('wontSave'.tr),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 5.0),
          child: ListTile(
            subtitle: Text(
              'settingsList'.tr,
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
        ),
        ListTile(
          title: Text('name'.tr),
          subtitle: TextField(
            controller: nameController,
            onSubmitted: (newString) {
              if (newString.isNotEmpty) {
                setState(() {
                  name = newString;
                });
                writeData();
              }
            },
          ),
        ),
        ListTile(
          title: Text('lang'.tr),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: SegmentedButton<String>(
              selected: <String>{currentTheme!.lang},
              segments: [
                ButtonSegment(value: 'fr', label: Text('fr'.tr)),
                ButtonSegment(value: 'en', label: Text('en'.tr)),
              ],
              onSelectionChanged: (selection) {
                setState(() {
                  currentTheme = QuickTheme(
                    brightness: currentTheme!.brightness,
                    color: currentTheme!.color,
                    lang: selection.first,
                  );
                });
                Get.updateLocale(Locale(selection.first));
                writeData();
              },
            ),
          ),
        ),
        ListTile(
          title: Text('brightness'.tr),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: SegmentedButton<ThemeMode>(
              selected: <ThemeMode>{currentTheme!.brightness},
              segments: [
                ButtonSegment(
                    value: ThemeMode.system, label: Text('system'.tr)),
                ButtonSegment(value: ThemeMode.light, label: Text('light'.tr)),
                ButtonSegment(value: ThemeMode.dark, label: Text('dark'.tr)),
              ],
              onSelectionChanged: (selection) {
                setState(() {
                  currentTheme = QuickTheme(
                    brightness: selection.first,
                    color: currentTheme!.color,
                    lang: currentTheme!.lang,
                  );
                });

                quickTheme.add(currentTheme!);
                writeData();
              },
            ),
          ),
        ),
        ListTile(
          title: Text("lightColor".tr),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: allColors
                      .map(
                        (e) => InkWell(
                          onTap: () {
                            setState(() {
                              currentTheme = QuickTheme(
                                color: e,
                                brightness: currentTheme!.brightness,
                                lang: currentTheme!.lang,
                              );
                            });

                            quickTheme.add(currentTheme!);
                            writeData();
                          },
                          child: Container(
                            color: e,
                            height: 25,
                            width: (MediaQuery.of(context).size.width - 32) /
                                allColors.length,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({
    super.key,
    required this.firebaseService,
  });

  final FirebaseService firebaseService;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: firebaseService.getGames(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('noGames'.tr),
            );
          }
          return ListView.builder(
            itemCount: (snapshot.hasData ? snapshot.data!.docs.length : 0),
            itemBuilder: (context, index) {
              return GameTileWidget(
                firebaseService: firebaseService,
                data: snapshot.data!.docs[index].data() as Map<String, dynamic>,
                snapshot: snapshot,
                index: index,
              );
            },
          );
        });
  }
}

class GameTileWidget extends StatefulWidget {
  const GameTileWidget({
    super.key,
    required this.firebaseService,
    required this.data,
    required this.snapshot,
    required this.index,
  });

  final FirebaseService firebaseService;
  final Map<String, dynamic> data;
  final snapshot;
  final int index;

  @override
  State<GameTileWidget> createState() => _GameTileWidgetState();
}

class _GameTileWidgetState extends State<GameTileWidget> {
  bool showPassWord = false;

  void joinGame() {
    if (!widget.data['isPublic']) {
      setState(() {
        showPassWord = !showPassWord;
      });
      return;
    }
    gameID = widget.snapshot.data!.docs[widget.index].id;
    widget.firebaseService.joinGame(gameID!, user!.uid);
    Navigator.pushNamed(context, 'game');
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (name == 'Player') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('userName'.tr),
              action: SnackBarAction(
                label: 'useAnyway'.tr,
                onPressed: joinGame,
              ),
            ),
          );
        } else {
          joinGame();
        }
      },
      subtitle: (showPassWord)
          ? TextField(
              onSubmitted: (String txt) {
                print(txt);
                if (txt.trim() == widget.data['password']) {
                  gameID = widget.snapshot.data!.docs[widget.index].id;
                  widget.firebaseService.joinGame(gameID!, user!.uid);
                  Navigator.pushNamed(context, 'game');
                }
              },
            )
          : null,
      title: Text(widget.data["name"]),
      leading: widget.data["isPublic"]
          ? const FaIcon(FontAwesomeIcons.lockOpen)
          : const FaIcon(FontAwesomeIcons.lock),
      trailing: Text(
        "${'place_left'.tr} ${widget.data["playersAlive"]}"
        "/${widget.data["maxPlayer"]}",
      ),
    );
  }
}

class FirstScreen extends StatelessWidget {
  const FirstScreen({
    super.key,
    required this.goToGames,
  });

  final Function() goToGames;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        children: [
          const Spacer(flex: 2),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: Image(image: diceImage[0]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              'perudo'.tr,
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          const Spacer(),
          FilledButton(onPressed: goToGames, child: Text('play'.tr)),
          FilledButton(onPressed: () {}, child: Text('how2play'.tr)),
          FilledButton.tonal(onPressed: () {}, child: Text('credit'.tr)),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
