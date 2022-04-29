import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:quellenreiter_app/widgets/enemy_card.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({Key? key, required this.appState}) : super(key: key);
  final QuellenreiterAppState appState;
  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  late TextEditingController searchController;

  /// Initialize [searchController] to query value, if it exists. If not,
  /// inittialize with default constructor.
  /// Add listener [widget.onQueryChanged]
  @override
  void initState() {
    searchController = widget.appState.friendsQuery == null
        ? TextEditingController()
        : TextEditingController(text: widget.appState.friendsQuery);
    searchController.addListener(() {
      widget.appState.friendsQuery = searchController.text;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Freund:in hinzufügen"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            constraints: const BoxConstraints(
              // Max width of the search results.
              maxWidth: 1000,
            ),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          hintText:
                              "Gebe den exakten Namen eine:r Freund:in ein.",
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          contentPadding: EdgeInsets.all(10),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              widget.appState.friendsSearchResult != null
                  ? Flexible(
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context)
                            .copyWith(scrollbars: false),
                        child: AnimationLimiter(
                          child: ListView.builder(
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            itemCount: widget
                                .appState.friendsSearchResult!.enemies.length,
                            itemBuilder: (BuildContext context, int index) {
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 400),
                                child: SlideAnimation(
                                  horizontalOffset: 30,
                                  child: FadeInAnimation(
                                    child: EnemyCard(
                                      enemy: widget.appState
                                          .friendsSearchResult!.enemies[index],
                                      onTapped:
                                          widget.appState.sendFriendRequest,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    )
                  : const Center(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Ergebnisse laden..."),
                      ),
                    ),
            ]),
          ),
        ),
      ),
    );
  }
}
