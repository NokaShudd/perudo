import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'firebaseLogic.dart';

class GamePage extends StatefulWidget {
  const GamePage({
    super.key,
  });

  @override
  State<GamePage> createState() => _GamePageState();
}

enum RelativePos {
  top,
  left,
  right,
}

class Position {
  const Position({required this.x, required this.y, required this.pos});
  final double x;
  final double y;
  final RelativePos pos;
}

Position getPosition(Size size, int totalPlayer, int playerIndex) {
  List<Position> allPos = [
    Position(
      x: (size.width * 0.125),
      y: (size.height * 0.5),
      pos: RelativePos.left,
    ), //middle left
    Position(
      x: (size.width * 0.875),
      y: (size.height * 0.5),
      pos: RelativePos.right,
    ), //middle right
    Position(
      x: (size.width * 0.5),
      y: (size.height * 0.2),
      pos: RelativePos.top,
    ), //top middle
    Position(
      x: (size.width * 0.125),
      y: (size.height * 0.25),
      pos: RelativePos.left,
    ), //top left
    Position(
      x: (size.width * 0.875),
      y: (size.height * 0.25),
      pos: RelativePos.right,
    ), //top right
    Position(
      x: (size.width * 0.125),
      y: (size.height * 0.75),
      pos: RelativePos.left,
    ), //bottom left
    Position(
      x: (size.width * 0.875),
      y: (size.height * 0.75),
      pos: RelativePos.right,
    ), //bottom right
  ];
  switch (totalPlayer) {
    case 4:
      return [allPos[5], allPos[3], allPos[4], allPos[6]][playerIndex];
    case 2:
      return [allPos[0], allPos[1]][playerIndex];
    default:
      return [allPos[0], allPos[2], allPos[1]][playerIndex];
  }
}

class _GamePageState extends State<GamePage> {
  FirebaseService firebaseService = FirebaseService();
  bool isMod = false;

  void showSnack(String txt) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(txt.tr)),
    );
  }

  List sortPlayers(List<int> order, List playersIn) {
    List players = [];

    for (var index in order) {
      players.add(playersIn[index]);
    }

    return players;
  }

  List setOtherPlayers(List otherPlayer) {
    List out = otherPlayer.map((e) => e).toList();

    int indexPlayer = out.indexWhere(
      (element) => element['userUid'] == user!.uid,
    );
    for (var _ in Iterable.generate(indexPlayer)) {
      var element = out.first;
      out.removeAt(0);
      out.add(element);
    }

    out.removeAt(0);
    return out;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: firebaseService.getGame(gameID!),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.data() == null) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('gameDontExit'.tr),
                    OutlinedButton(
                      onPressed: () {
                        gameID = null;
                        Navigator.pop(context);
                      },
                      child: Text('quit'.tr),
                    ),
                  ],
                ),
              ),
            );
          }
          final data = snapshot.data!.data() as Map<String, dynamic>;
          isMod = data['mod'] == user!.uid;
          if (!data['started']) {
            bool canStart = (data['playersAlive'] >= 3);
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(canStart ? 'canStart'.tr : 'needPlayers'.tr),
                    Text(
                      '${'currentNumber'.tr} :'
                      ' ${data['playersAlive']}/${data['maxPlayer']}',
                    ),
                    Visibility(
                      visible: canStart && isMod,
                      child: FilledButton.tonal(
                        onPressed: () async {
                          await firebaseService.launchGame(data, gameID!);

                          firebaseService.startGame(gameID!);
                        },
                        child: Text('start'.tr),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        if (isMod) {
                          showSnack('modTryDelete'.tr);
                        } else {
                          showSnack('playerTryQuit'.tr);
                        }
                      },
                      onLongPress: () async {
                        if (isMod) {
                          Navigator.pop(context);
                          await firebaseService.deleteGame(gameID!);
                        } else {
                          Navigator.pop(context);
                          await firebaseService.quitGame(gameID!, user!.uid);
                        }
                        gameID = null;
                      },
                      child: Text('quit'.tr),
                    )
                  ],
                ),
              ),
            );
          }
          List allPlayers = sortPlayers(
            data['order'].cast<int>(),
            data['players'],
          );
          bool isYourTurn = allPlayers.indexWhere(
                (element) => element['userUid'] == user!.uid,
              ) ==
              data['turn'];
          return InGameWidget(
            size: MediaQuery.of(context).size,
            players: setOtherPlayers(allPlayers),
            allPlayers: allPlayers,
            data: data,
            yourTurn: isYourTurn,
          );
        });
  }
}

class InGameWidget extends StatefulWidget {
  const InGameWidget({
    super.key,
    required this.size,
    required this.players,
    required this.allPlayers,
    required this.data,
    required this.yourTurn,
  });

  final Size size;
  final List players;
  final List allPlayers;
  final Map<String, dynamic> data;
  final bool yourTurn;

  @override
  State<InGameWidget> createState() => _InGameWidgetState();
}

class _InGameWidgetState extends State<InGameWidget> {
  FirebaseService firebaseService = FirebaseService();
  TextEditingController msg = TextEditingController();
  Map player = {};

  PageController pagecontroller = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
  }

  void showSnack(String txt) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(txt.tr),
        showCloseIcon: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String turnUid = widget.allPlayers[widget.data['turn']]['userUid'];
    bool canUseCalza = (widget.data['isCalzaPossible'] &&
        widget.data['lastGuess']['lastPlayerUid'] != null &&
        widget.data['lastGuess']['lastPlayerUid'] != user!.uid &&
        player['deadDices'] > 0);
    player = widget.allPlayers
        .where((element) => element['userUid'] == user!.uid)
        .first;

    return PageView(
      controller: pagecontroller,
      children: [
        Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              pagecontroller.animateToPage(
                1,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInQuad,
              );
            },
            child: const FaIcon(FontAwesomeIcons.paperPlane),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: Stack(
            children: [
              Positioned(
                top: widget.size.height * 0.2,
                left: widget.size.width * 0.125,
                child: Container(
                  height: widget.size.height * 0.6,
                  width: widget.size.width * 0.75,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.green,
                  ),
                  child: Center(
                    child: Visibility(
                      visible: widget.data['useDiceDeadCount'],
                      child: Text(
                        '${'deadDice'.tr} :'
                        ' ${widget.data['deadDiceCount']}',
                      ),
                    ),
                  ),
                ),
              ),
              ...Iterable.generate(widget.players.length, (index) {
                Position pos = getPosition(
                  widget.size,
                  widget.players.length,
                  index,
                );
                double dimension =
                    widget.players[index]['dices'].length * 15.0 + 2;
                bool isPlayerTurn = widget.players[index]['userUid'] == turnUid;
                return Positioned(
                  top: (pos.pos == RelativePos.top)
                      ? pos.y - 26
                      : pos.y - dimension * 0.5,
                  left: (pos.pos == RelativePos.top)
                      ? pos.x - dimension * 0.5
                      : pos.x - 26,
                  child: Container(
                    decoration: isPlayerTurn
                        ? BoxDecoration(
                            color: Colors.amber.withOpacity(0.1),
                            border: Border.all(color: Colors.amber),
                            borderRadius: BorderRadius.circular(
                              10.0,
                            ),
                          )
                        : null,
                    width: (pos.pos == RelativePos.top) ? dimension : 52,
                    height: (pos.pos == RelativePos.top) ? 62 : dimension,
                    child: (pos.pos == RelativePos.top)
                        ? Column(
                            children: [
                              SizedBox(
                                height: widget.data['checking'] ? 35 : 30,
                                child: Text(
                                  widget.players[index]['name'],
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              DicesVertWidget(widget: widget, index: index),
                            ],
                          )
                        : Row(
                            children: (pos.pos == RelativePos.left)
                                ? [
                                    RotatedBox(
                                      quarterTurns: -1,
                                      child: SizedBox(
                                        height:
                                            widget.data['checking'] ? 35 : 30,
                                        child: Text(
                                          widget.players[index]['name'],
                                          overflow: TextOverflow.fade,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                        ),
                                      ),
                                    ),
                                    DicesWidget(widget: widget, index: index),
                                  ]
                                : [
                                    DicesWidget(widget: widget, index: index),
                                    RotatedBox(
                                      quarterTurns: 1,
                                      child: SizedBox(
                                        height:
                                            widget.data['checking'] ? 35 : 30,
                                        child: Text(
                                          widget.players[index]['name'],
                                          overflow: TextOverflow.fade,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                          ),
                  ),
                );
              }).toList(),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.8 - 30,
                left: MediaQuery.of(context).size.width * 0.5 -
                    player['dices'].length * 12.5,
                child: Column(
                  children: [
                    Row(
                      children: player['dices']
                          .map(
                            (e) => (Theme.of(context).brightness ==
                                    Brightness.light)
                                ? SvgPicture.asset(
                                    diceImage[e],
                                    height: 25,
                                    width: 25,
                                  )
                                : SvgPicture.asset(
                                    diceImageBlack[e],
                                    height: 25,
                                    width: 25,
                                  ),
                          )
                          .toList()
                          .cast<Widget>(),
                    ),
                    SizedBox(
                      height: 35,
                      child: Center(
                        child: Text(
                          name,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                right: 0,
                child: SafeArea(
                  child: Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    height: widget.size.height * 0.05,
                    child: Center(
                      child: Text(
                        widget.data['lastMessage']['sendBy'] +
                            " - " +
                            widget.data['lastMessage']['message'],
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: widget.size.height * 0.05,
                right: 0,
                child: SafeArea(
                  child: Container(
                    constraints: const BoxConstraints(
                      minHeight: 40,
                    ),
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    child: (widget.data['lastGuess']['lastPlayerUid'] != null)
                        ? Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: (widget.data['lastGuess']['number'] *
                                          40 <
                                      widget.size.width)
                                  ? Iterable.generate(
                                      widget.data['lastGuess']['number'],
                                      (_) => (Theme.of(context).brightness ==
                                              Brightness.light)
                                          ? SvgPicture.asset(
                                              diceImage[widget.data['lastGuess']
                                                  ['value']],
                                              height: 40,
                                              width: 40,
                                            )
                                          : SvgPicture.asset(
                                              diceImageBlack[widget
                                                  .data['lastGuess']['value']],
                                              height: 40,
                                              width: 40,
                                            ),
                                    ).toList()
                                  : [
                                      Text(
                                        '${widget.data['lastGuess']['number']}'
                                        'x',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondaryContainer,
                                            ),
                                      ),
                                      (Theme.of(context).brightness ==
                                              Brightness.light)
                                          ? SvgPicture.asset(
                                              diceImage[widget.data['lastGuess']
                                                  ['value']],
                                              height: 40,
                                              width: 40,
                                            )
                                          : SvgPicture.asset(
                                              diceImageBlack[widget
                                                  .data['lastGuess']['value']],
                                              height: 40,
                                              width: 40,
                                            ),
                                    ],
                            ),
                          )
                        : Center(
                            child: Text(
                              '${'noMove'.tr} '
                              '${widget.allPlayers[widget.data['turn']]['name']}',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondaryContainer),
                            ),
                          ),
                  ),
                ),
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.05,
                height: MediaQuery.of(context).size.height * 0.05,
                left: 0,
                right: 0,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          if (widget.data['mod'] == user!.uid) {
                            showSnack('modTryDelete'.tr);
                          } else {
                            showSnack('playerTryQuit'.tr);
                          }
                        },
                        onLongPress: () async {
                          if (widget.data['mod'] == user!.uid) {
                            Navigator.pop(context);
                            await firebaseService.deleteGame(gameID!);
                          } else {
                            Navigator.pop(context);
                            await firebaseService.quitGame(gameID!, user!.uid);
                          }

                          gameID = null;
                        },
                        child: Text(
                          'quit'.tr,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      if (canUseCalza)
                        FilledButton(
                          onPressed: () {},
                          child: Text('calza'.tr),
                        ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Visibility(
                  visible: widget.yourTurn && !widget.data['checking'],
                  child: ChoiceWidget(
                    widget: widget,
                    canUseCalza: canUseCalza,
                  ),
                ),
              )
            ],
          ),
        ),
        Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              pagecontroller.animateToPage(
                0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInQuad,
              );
            },
            child: const FaIcon(FontAwesomeIcons.dice),
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseService().getMessages(gameID!),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final List listData = snapshot.data!.docs;
                    return ListView.builder(
                      reverse: true,
                      itemCount: listData.length,
                      itemBuilder: (context, index) {
                        bool isSendbyUser =
                            listData[index]['sendByUid'] == user!.uid;

                        return Row(
                          mainAxisAlignment: isSendbyUser
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Card(
                              color: isSendbyUser
                                  ? Theme.of(context)
                                      .colorScheme
                                      .onTertiaryContainer
                                  : Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  constraints: BoxConstraints(
                                    minWidth: 10,
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.85,
                                  ),
                                  child: Text(
                                    '${listData[index]['sendBy']} '
                                    '- ${listData[index]['message']}',
                                    softWrap: true,
                                    maxLines: null,
                                    style: TextStyle(
                                      color: isSendbyUser
                                          ? Theme.of(context)
                                              .colorScheme
                                              .tertiaryContainer
                                          : Theme.of(context)
                                              .colorScheme
                                              .secondaryContainer,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.5),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: TextField(
                              controller: msg,
                              keyboardType: TextInputType.multiline,
                              scrollPhysics: const ScrollPhysics(),
                              maxLines: null,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Write your message",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        if (msg.value.text.isNotEmpty) {
                          firebaseService.sendMessage(
                            gameID!,
                            msg.value.text,
                          );
                          msg.clear();
                        }
                      },
                      icon: const FaIcon(FontAwesomeIcons.paperPlane),
                      label: const Text("Send"),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class ChoiceWidget extends StatefulWidget {
  const ChoiceWidget({
    super.key,
    required this.widget,
    required this.canUseCalza,
  });

  final InGameWidget widget;
  final bool canUseCalza;

  @override
  State<ChoiceWidget> createState() => _ChoiceWidgetState();
}

class _ChoiceWidgetState extends State<ChoiceWidget> {
  FirebaseService firebaseService = FirebaseService();
  double numbers = 0.0;
  int value = 0;
  double maxNumber = 0;
  bool canBid = false;
  Map<String, dynamic> data = {};
  double lastGuessNumb = 0.0;
  double minNumber = 0.0;
  int lastGuessVal = 0;
  bool firstBid = true;

  @override
  void initState() {
    data = widget.widget.data;
    firstBid = data['lastGuess']['lastPlayerUid'] == null;
    lastGuessNumb = !firstBid ? data['lastGuess']['number'] + 0.0 : 0.0;
    lastGuessVal = !firstBid ? data['lastGuess']['value'] : 0;
    numbers = lastGuessNumb + 1.0;
    minNumber = (!firstBid && value <= data['lastGuess']['value'])
        ? data['lastGuess']['number'] + 1.0
        : 1.0;
    for (var element in data['players']) {
      List dices = element['dices'] as List;
      maxNumber += dices.where((dice) => dice != 6).toList().length;
    }
    if (numbers > maxNumber) {
      numbers = maxNumber;
    }
    super.initState();
  }

  void checkCanBid() {
    if (firstBid || value > lastGuessVal || numbers > lastGuessNumb) {
      canBid = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: size.width,
      color: Colors.black.withOpacity(0.4),
      child: Center(
        child: Container(
          width: size.width * 0.7,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'yourTurn'.tr,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  'chooseBid'.tr,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                ListTile(
                  title: Text('number'.tr),
                  subtitle: Slider(
                    value: numbers,
                    max: maxNumber,
                    min: minNumber,
                    label: numbers.round().toString(),
                    divisions:
                        (!firstBid && value <= data['lastGuess']['value'])
                            ? (maxNumber - (lastGuessNumb + 1)).round()
                            : maxNumber.round(),
                    onChanged: (double valueSlide) {
                      checkCanBid();
                      setState(() => numbers = valueSlide);
                    },
                  ),
                ),
                ListTile(
                  title: Text('value'.tr),
                  subtitle: Wrap(
                    children: Iterable.generate(
                      6,
                      (index) => InkWell(
                        onTap: () {
                          checkCanBid();
                          setState(() {
                            if (index <= lastGuessVal) {
                              minNumber = lastGuessNumb + 1.0;
                              if (minNumber > numbers) {
                                numbers = minNumber;
                              }
                            } else {
                              minNumber = 1.0;
                            }
                            value = index;
                          });
                        },
                        child:
                            (Theme.of(context).brightness == Brightness.light)
                                ? SvgPicture.asset(
                                    diceImage[index],
                                    height: 15,
                                    width: 15,
                                  )
                                : SvgPicture.asset(
                                    diceImageBlack[index],
                                    height: 15,
                                    width: 15,
                                  ),
                      ),
                    ).toList(),
                  ),
                ),
                canBid
                    ? OutlinedButton(
                        onPressed: () {
                          firebaseService.play(
                            value,
                            numbers.round(),
                            user!.uid,
                            gameID!,
                          );
                        },
                        child: Text(
                            '${'bid'.tr} ${numbers.round()} x ${value + 1}'),
                      )
                    : Text('cantBid'.tr),
                Visibility(
                  visible: widget.canUseCalza,
                  child: Text(
                    'orCalza'.tr,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Visibility(
                  visible: widget.canUseCalza,
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Text('calza'.tr),
                  ),
                ),
                Visibility(
                  visible: !firstBid,
                  child: Text(
                    'or'.tr,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Visibility(
                  visible: !firstBid,
                  child: OutlinedButton(
                    onPressed: () {
                      firebaseService.dudo(gameID!, user!.uid);
                    },
                    child: Text('dudo'.tr),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DicesVertWidget extends StatelessWidget {
  const DicesVertWidget({
    super.key,
    required this.widget,
    required this.index,
  });

  final InGameWidget widget;
  final int index;

  @override
  Widget build(BuildContext context) {
    if (widget.data['checking']) {
      List dices = widget.players[index]['dices'];
      return Row(
        children: dices
            .map(
              (e) => (Theme.of(context).brightness == Brightness.light)
                  ? SvgPicture.asset(
                      diceImage[e],
                      height: 15,
                      width: 15,
                    )
                  : SvgPicture.asset(
                      diceImageBlack[e],
                      height: 15,
                      width: 15,
                    ),
            )
            .toList()
            .cast<Widget>(),
      );
    }
    return Container(
      width: 20.0,
      height: 30.0,
      decoration: const BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      child: widget.data['useDiceCount']
          ? FittedBox(
              child: Text(widget.players[index]['dices'].length.toString()),
            )
          : null,
    );
  }
}

class DicesWidget extends StatelessWidget {
  const DicesWidget({
    super.key,
    required this.widget,
    required this.index,
  });

  final InGameWidget widget;
  final int index;

  @override
  Widget build(BuildContext context) {
    if (widget.data['checking']) {
      return Column(
        children: widget.players[index]['dices']
            .map(
              (e) => (Theme.of(context).brightness == Brightness.light)
                  ? SvgPicture.asset(
                      diceImage[e],
                      height: 15,
                      width: 15,
                    )
                  : SvgPicture.asset(
                      diceImageBlack[e],
                      height: 15,
                      width: 15,
                    ),
            )
            .toList()
            .cast<Widget>(),
      );
    }
    return Container(
      height: 30.0,
      width: 20.0,
      decoration: const BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      child: widget.data['useDiceCount']
          ? FittedBox(
              child: Text(
                widget.players[index]['dices'].length.toString(),
              ),
            )
          : null,
    );
  }
}
