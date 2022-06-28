import 'dart:math';

import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:quellenreiter_app/constants/constants.dart';
import 'package:quellenreiter_app/models/game.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:quellenreiter_app/models/statement.dart';
import 'package:quellenreiter_app/widgets/results_app_bar.dart';
import 'package:quellenreiter_app/widgets/start_game_button.dart';

import '../../widgets/error_banner.dart';
import '../../widgets/statement_card.dart';

class ReadyToStartScreen extends StatefulWidget {
  const ReadyToStartScreen({Key? key, required this.appState})
      : super(key: key);
  final QuellenreiterAppState appState;
  @override
  State<ReadyToStartScreen> createState() => _ReadyToStartScreenState();
}

class _ReadyToStartScreenState extends State<ReadyToStartScreen> {
  var greyCircle = const Padding(
    padding: EdgeInsets.all(10),
    child: CircleAvatar(
      backgroundColor: DesignColors.black,
    ),
  );
  List<Widget> statementCardsWithAnswers = [];
  int commonLength = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    statementCardsWithAnswers = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    commonLength = min(
        widget.appState.currentEnemy!.openGame!.playerAnswers.length,
        widget.appState.currentEnemy!.openGame!.enemyAnswers.length);

    // Check if statements are loaded. If not, load them.
    if (widget.appState.currentEnemy!.openGame!.statements == null) {
      widget.appState.getCurrentStatements();
      return Scaffold(
          appBar: AppBar(),
          body: const Center(child: CircularProgressIndicator()));
    }
    // build the list of statementcards
    statementCardsWithAnswers = [];
    for (int i = 0;
        i < widget.appState.currentEnemy!.openGame!.playerAnswers.length;
        i++) {
      var tempStatement =
          widget.appState.currentEnemy!.openGame!.statements!.statements[i];
      statementCardsWithAnswers.add(
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: StatementCard(
                  statement: tempStatement,
                  appState: widget.appState,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (widget
                          .appState.currentEnemy!.openGame!.playerAnswers[i] ==
                      true)
                    CircleAvatar(
                      backgroundColor: DesignColors.green,
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    )
                  else
                    CircleAvatar(
                      backgroundColor: DesignColors.red,
                      child: Icon(
                        Icons.not_interested,
                        color: Colors.white,
                      ),
                    ),
                  if (commonLength <= i)
                    CircleAvatar(
                      backgroundColor: DesignColors.lightGrey,
                      child: Icon(Icons.watch_later_outlined),
                    )
                  else if (widget
                          .appState.currentEnemy!.openGame!.enemyAnswers[i] ==
                      true)
                    CircleAvatar(
                      backgroundColor: DesignColors.green,
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    )
                  else
                    CircleAvatar(
                        backgroundColor: DesignColors.red,
                        child: Icon(
                          Icons.not_interested,
                          color: Colors.white,
                        )),
                ],
              ),
            ],
          ),
        ),
      );
    }

    // Show error is there is one !
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.appState.showError(context);
    });
    return Scaffold(
      appBar: ResultsAppBar(
        appState: widget.appState,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ListView(
            padding: const EdgeInsets.all(10),
            children: [
              if (widget.appState.currentEnemy!.openGame!.gameFinished())
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (widget.appState.currentEnemy!.openGame!
                              .getGameResult() ==
                          GameResult.playerWon)
                        Text("Gewonnen",
                            style: Theme.of(context)
                                .textTheme
                                .headline2!
                                .copyWith(color: DesignColors.green))
                      else if (widget.appState.currentEnemy!.openGame!
                              .getGameResult() ==
                          GameResult.tied)
                        Text("Unentschieden",
                            style: Theme.of(context)
                                .textTheme
                                .headline2!
                                .copyWith(color: DesignColors.green))
                      else
                        Text("Verloren",
                            style: Theme.of(context)
                                .textTheme
                                .headline2!
                                .copyWith(color: DesignColors.red)),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("+ "),
                            const Icon(
                              Icons.monetization_on,
                              color: DesignColors.yellow,
                              size: 24,
                            ),
                            Countup(
                              begin: 0,
                              end: widget.appState.currentEnemy!.openGame!
                                  .getPlayerXp()
                                  .toDouble(),
                              duration: const Duration(seconds: 1),
                              style: Theme.of(context).textTheme.subtitle1,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              // display the statementcards
              ...statementCardsWithAnswers,
              // if error
            ],
          ),
          if (widget.appState.currentEnemy == null ||
              widget.appState.currentEnemy!.openGame == null)
            const Text("Fehler.")
          //if is players turn
          else if (widget.appState.currentEnemy!.openGame!.isPlayersTurn())
            // if not played any quests
            if (widget.appState.currentEnemy!.openGame!.playerAnswers.isEmpty)
              SafeArea(
                child: Flexible(
                  child: FloatingActionButton.extended(
                    backgroundColor: DesignColors.pink,
                    label: Text("Spielen",
                        style: Theme.of(context).textTheme.headline4),
                    onPressed: () => {widget.appState.playGame()},
                  ),
                ),
              )
            // if already played in this game
            else
              SafeArea(
                child: Flexible(
                  child: FloatingActionButton.extended(
                    backgroundColor: DesignColors.pink,
                    label: Text("Weiter spielen",
                        style: Theme.of(context).textTheme.headline4),
                    onPressed: () => {widget.appState.playGame()},
                  ),
                ),
              )
          else if (widget.appState.currentEnemy!.openGame!.gameFinished() &&
              widget.appState.currentEnemy!.openGame!.requestingPlayerIndex ==
                  widget.appState.currentEnemy!.openGame!.playerIndex)
            SafeArea(
              child: Flexible(
                child: FloatingActionButton.extended(
                  backgroundColor: DesignColors.lightGrey,
                  label: Text("Warten...",
                      style: Theme.of(context).textTheme.headline4),
                  onPressed: null,
                ),
              ),
            )
          else if (widget.appState.currentEnemy!.openGame!.gameFinished())
            SafeArea(
              child: Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Das spiel ist beendet."),
                    Flexible(
                      child: StartGameButton(
                        appState: widget.appState,
                        enemy: widget.appState.currentEnemy!,
                      ),
                    )
                  ],
                ),
              ),
            )
          else
            SafeArea(
              child: Flexible(
                child: FloatingActionButton.extended(
                  backgroundColor: DesignColors.lightGrey,
                  label: Text("Warten...",
                      style: Theme.of(context).textTheme.headline4),
                  onPressed: null,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
