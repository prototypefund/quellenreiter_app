import 'package:quellenreiter_app/models/player_relation.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';

import '../constants/constants.dart';
import '../models/fact.dart';
import '../models/player.dart';

/// Class containg various utilities for the database connection.
class Queries {
  /// Returns the graphQL query to search for [Statements].
  static String searchStatements(String query) {
    String ret = '''
  query searchStatementsByWord{
  statements(
    where:{
      OR:[
        { ${DbFields.statementText}: { matchesRegex: "$query", options: "i"} }
        { ${DbFields.statementMedia}: { matchesRegex: "$query", options: "i"} }
        { ${DbFields.statementFactcheckIDs} : { have:{ ${DbFields.factText}:{ matchesRegex: "$query", options: "i" } } } }
        { ${DbFields.statementFactcheckIDs} : { have:{ ${DbFields.factMedia}:{ matchesRegex: "$query", options: "i" } } } }
      ]
  }){
    edges{
      node{
        objectId
        ${DbFields.statementText}
        ${DbFields.statementPictureFile}{url}
        ${DbFields.statementYear}
        ${DbFields.statementMonth}
        ${DbFields.statementDay}
        ${DbFields.statementCorrectness}
        ${DbFields.statementMedia}
        ${DbFields.statementLanguage}
        ${DbFields.statementCategory}
        ${DbFields.statementMediatype}
        ${DbFields.statementAuthor}
        ${DbFields.statementLink}
        ${DbFields.statementRectification}
        ${DbFields.statementPictureCopyright}
        ${DbFields.statementFactcheckIDs}{
            edges{
              node{
                objectId
                ${DbFields.factText}
                ${DbFields.factAuthor}
                ${DbFields.statementYear}
                ${DbFields.statementMonth}
                ${DbFields.statementDay}
                ${DbFields.factLanguage}
                ${DbFields.factMedia}
                ${DbFields.factLink}
                ${DbFields.factArchivedLink}
              }
            }
        }
      }
    }
  }
}
  ''';
    return ret;
  }

  /// Returns the graphQL query to get to newest n statements.
  static String getnNewestStatements(int n) {
    String ret = '''
  query getNNewestStatements{
  statements(
      order: [createdAt_DESC],
    	first: $n
  ){
    edges{
      node{
        objectId
        ${DbFields.statementText}
        ${DbFields.statementPictureFile}{url}
        ${DbFields.statementYear}
        ${DbFields.statementMonth}
        ${DbFields.statementDay}
        ${DbFields.statementCorrectness}
        ${DbFields.statementMedia}
        ${DbFields.statementLanguage}
        ${DbFields.statementCategory}
        ${DbFields.statementMediatype}
        ${DbFields.statementAuthor}
        ${DbFields.statementLink}
        ${DbFields.statementRectification}
        ${DbFields.statementPictureCopyright}
        ${DbFields.statementFactcheckIDs}{
          edges{
            node{
              objectId
              ${DbFields.factText}
              ${DbFields.factAuthor}
              ${DbFields.statementYear}
              ${DbFields.statementMonth}
              ${DbFields.statementDay}
              ${DbFields.factLanguage}
              ${DbFields.factMedia}
              ${DbFields.factLink}
              ${DbFields.factArchivedLink}
            }
          }
        }
      }
    }
  }
}
  ''';
    return ret;
  }

  /// Returns the graphQL mutation to create a [Statement].
  static String createStatement() {
    String ret = '''
  mutation createAStatement(\$input: CreateStatementInput!){
  createStatement(
       input: \$input
    ){
  statement{
    objectId
    ${DbFields.statementText}
    ${DbFields.statementPictureFile}{url}
    ${DbFields.statementYear}
    ${DbFields.statementMonth}
    ${DbFields.statementDay}
    ${DbFields.statementCorrectness}
    ${DbFields.statementMedia}
    ${DbFields.statementLanguage}
    ${DbFields.statementCategory}
    ${DbFields.statementMediatype}
    ${DbFields.statementAuthor}
    ${DbFields.statementLink}
    ${DbFields.statementRectification}
    ${DbFields.statementPictureCopyright}
    ${DbFields.statementFactcheckIDs}{
        edges{
          node{
            objectId
              ${DbFields.factText}
              ${DbFields.factAuthor}
              ${DbFields.factYear}
              ${DbFields.factMonth}
              ${DbFields.factDay}
              ${DbFields.factLanguage}
              ${DbFields.factMedia}
              ${DbFields.factLink}
              ${DbFields.factArchivedLink}
          }
        }
      }
    }
  }
}
  ''';
    return ret;
  }

  /// Returns the graphQL mutation to update a [Statement].
  static String updateStatement() {
    String ret = '''
  mutation updateAStatement(\$input: UpdateStatementInput!){
  updateStatement(
       input: \$input
    ){
  statement{
    objectId
    ${DbFields.statementText}
    ${DbFields.statementPictureFile}{url}
    ${DbFields.statementYear}
    ${DbFields.statementMonth}
    ${DbFields.statementDay}
    ${DbFields.statementCorrectness}
    ${DbFields.statementMedia}
    ${DbFields.statementLanguage}
    ${DbFields.statementCategory}
    ${DbFields.statementMediatype}
    ${DbFields.statementAuthor}
    ${DbFields.statementLink}
    ${DbFields.statementRectification}
    ${DbFields.statementPictureCopyright}
    ${DbFields.statementFactcheckIDs}{
        edges{
          node{
            objectId
              ${DbFields.factText}
              ${DbFields.factAuthor}
              ${DbFields.factYear}
              ${DbFields.factMonth}
              ${DbFields.factDay}
              ${DbFields.factLanguage}
              ${DbFields.factMedia}
              ${DbFields.factLink}
              ${DbFields.factArchivedLink}
          }
        }
      }
    }
  }
}
  ''';
    return ret;
  }

  /// Returns the graphQL mutation to delete a [Fact] by [Fact.objectId].
  static String deleteFact(String factId) {
    // how to ensure that facts are not duplicated but changes
    // are still updated..??

    String ret = '''
  mutation deleteAFact{
  deleteFactcheck(
    input:{
      id: "$factId"
    }
    ){
    factcheck{
      fact
    }
  }
}
  ''';
    return ret;
  }

  /// Returns the graphQL mutation to login.
  static String login(String username, String password) {
    String ret = '''
mutation LogIn{
  logIn(input: {
    username: "$username"
    password: "$password"
  }){
    viewer{
      user{
        objectId
        ${DbFields.userName}
        ${DbFields.userData}{
          objectId
          ${DbFields.userGamesTied}
          ${DbFields.userGamesWon}
          ${DbFields.userEmoji}
          ${DbFields.userPlayedGames}
          ${DbFields.userTrueCorrectAnswers}
          ${DbFields.userFalseCorrectAnswers}
          ${DbFields.userTrueFakeAnswers}
          ${DbFields.userFalseFakeAnswers}
          ${DbFields.userNumFriends}
          ${DbFields.userSafedStatements}{
            ... on Element{
              value
            }
          }
          ${DbFields.userPlayedStatements}{
            ... on Element{
              value
            }
          }
        }
      }
      sessionToken
    }
  }
}
''';
    return ret;
  }

  /// Returns the graphQL mutation to login.
  static String signUp(String username, String password, String emoji) {
    String ret = '''
mutation SignUp{
  signUp(input: {
    fields: {
      username: "$username"
      password: "$password"
    }
  }){
    viewer{
      user{
        objectId
        ${DbFields.userName}
        ${DbFields.userData}{
          objectId
          ${DbFields.userGamesTied}
          ${DbFields.userGamesWon}
          ${DbFields.userEmoji}
          ${DbFields.userPlayedGames}
          ${DbFields.userTrueCorrectAnswers}
          ${DbFields.userFalseCorrectAnswers}
          ${DbFields.userTrueFakeAnswers}
          ${DbFields.userFalseFakeAnswers}
          ${DbFields.userNumFriends}
          ${DbFields.userSafedStatements}{
            ... on Element{
              value
            }
          }
          ${DbFields.userPlayedStatements}{
            ... on Element{
              value
            }
          }
        }
      }
      sessionToken
    }
  }
}
''';
    return ret;
  }

  /// Returns the graphQL query to check the current user.
  static String getCurrentUser() {
    String ret = '''
query GetCurrentUser{
  viewer{
    user{
      objectId
      ${DbFields.userName}
      ${DbFields.userData}{
        objectId
        ${DbFields.userGamesTied}
        ${DbFields.userGamesWon}
        ${DbFields.userEmoji}
        ${DbFields.userPlayedGames}
        ${DbFields.userTrueCorrectAnswers}
        ${DbFields.userFalseCorrectAnswers}
        ${DbFields.userTrueFakeAnswers}
        ${DbFields.userFalseFakeAnswers}
        ${DbFields.userNumFriends}
        ${DbFields.userSafedStatements}{
          ... on Element{
            value
          }
        }
        ${DbFields.userPlayedStatements}{
          ... on Element{
            value
          }
        }
      }
    }
    sessionToken
  }
}
''';
    return ret;
  }

  static String updateFriendshipStatus(String id) {
    String ret = '''
mutation updateFriendship{
  updateFriendship(
    input:{
      id: "$id"
      fields:{
        ${DbFields.friendshipApproved1}: true
        ${DbFields.friendshipApproved2}: true
      }
    }
  ){
    friendship{
      objectId
    }
  }
}
''';
    return ret;
  }

  static String updateFriendship() {
    String ret = '''
mutation updateFriendship(\$friendship: UpdateFriendshipInput!){
  updateFriendship(
    input: \$friendship
  ){
    friendship{
      objectId
    }
  }
}
''';
    return ret;
  }

  /// Returns the graphQL query to check the friend requests.
  static String getFriends(Player player) {
    String ret = '''
query GetOpenFriendRequests{
  friendships(
    where:{
      OR:[
        {${DbFields.friendshipPlayer1}: { have: {objectId : { equalTo: "${player.id}"}}}}
        {${DbFields.friendshipPlayer2}: { have: {objectId : { equalTo: "${player.id}"}}}}
      ]
    }
  ){
    edges{
      node{
        objectId
        ${DbFields.friendshipPlayer1}{
          objectId
          ${DbFields.userName}
          ${DbFields.userData}{
            objectId
            ${DbFields.userGamesTied}
            ${DbFields.userGamesWon}
            ${DbFields.userEmoji}
            ${DbFields.userPlayedGames}
            ${DbFields.userTrueCorrectAnswers}
            ${DbFields.userFalseCorrectAnswers}
            ${DbFields.userTrueFakeAnswers}
            ${DbFields.userFalseFakeAnswers}
            ${DbFields.userNumFriends}
            ${DbFields.userPlayedStatements}{
              ... on Element{
                value
              }
            }
          }
        }
        ${DbFields.friendshipPlayer2}{
          objectId
          ${DbFields.userName}
          ${DbFields.userData}{
            objectId
            ${DbFields.userGamesTied}
            ${DbFields.userGamesWon}
            ${DbFields.userEmoji}
            ${DbFields.userPlayedGames}
            ${DbFields.userTrueCorrectAnswers}
            ${DbFields.userFalseCorrectAnswers}
            ${DbFields.userTrueFakeAnswers}
            ${DbFields.userFalseFakeAnswers}
            ${DbFields.userNumFriends}
            ${DbFields.userPlayedStatements}{
              ... on Element{
                value
              }
            }
          }
        }
        ${DbFields.friendshipOpenGame}{
          ${DbFields.gameRequestingPlayerIndex}
          createdAt
          objectId
          ${DbFields.gameWithTimer}
          ${DbFields.gameAnswersPlayer1}{
            ... on Element{
                value
            }
          }
          ${DbFields.gameAnswersPlayer2}{
            ... on Element{
                value
            }
          }
          ${DbFields.gameStatementIds}{
            ... on Element{
                value
            }
          }
          ${DbFields.gamePointsAccessed}
        }
        ${DbFields.friendshipWonGamesPlayer1}
        ${DbFields.friendshipWonGamesPlayer2}
        ${DbFields.friendshipNumGamesPlayed}
        ${DbFields.friendshipApproved1}
        ${DbFields.friendshipApproved2}
      }
    }
  }
}
''';
    return ret;
  }

  static String searchFriends(String query, List<String> friendNames) {
    String friendsString = "[";
    for (String word in friendNames) {
      friendsString += "\"$word\",";
    }
    friendsString += "]";

    String ret = '''
query GetOpenFriendRequests{
  users(
    where:{
      AND:[
        { ${DbFields.userName}: { equalTo: "$query"} }
        { ${DbFields.userName}: { notIn: $friendsString} }
      ]
    }
  ){
    edges{
      node{
        objectId
        ${DbFields.userName}
        ${DbFields.userData}{
          objectId
          ${DbFields.userGamesTied}
          ${DbFields.userGamesWon}
          ${DbFields.userEmoji}
          ${DbFields.userPlayedGames}
          ${DbFields.userTrueCorrectAnswers}
          ${DbFields.userFalseCorrectAnswers}
          ${DbFields.userTrueFakeAnswers}
          ${DbFields.userFalseFakeAnswers}
          ${DbFields.userNumFriends}
          ${DbFields.userPlayedStatements}{
            ... on Element{
              value
            }
          }
          ${DbFields.userSafedStatements}{
            ... on Element{
              value
            }
          }
        }
      }
    }
  }
}

''';
    return ret;
  }

  /// Returns the graphQL query to send a friend requests.
  static String sendFriendRequest(String _playerId, String _playerRelationId) {
    String ret = '''
mutation sendFriendRequest {
  createFriendship(
    input: {
      fields:{
        ${DbFields.friendshipPlayer1}:{
          link:"$_playerId"
        }
        ${DbFields.friendshipPlayer1Id}: "$_playerId"
        ${DbFields.friendshipPlayer2}:{
          link: "$_playerRelationId"
        }
        ${DbFields.friendshipPlayer2Id}: "$_playerRelationId"
        ${DbFields.friendshipApproved1}: true
        ${DbFields.friendshipApproved2}: false
      }
    }
  ) {
    friendship{
      objectId
    }
  }
}


''';
    return ret;
  }

  /// Returns the graphQL query to check the friend requests.
  static String updateUserData() {
    String ret = '''
mutation updateUser(\$user: UpdateUserDataInput!){
  updateUserData(
    input: \$user
  ){
    userData{
      objectId
      ${DbFields.userGamesTied}
      ${DbFields.userGamesWon}
      ${DbFields.userEmoji}
      ${DbFields.userPlayedGames}
      ${DbFields.userTrueCorrectAnswers}
      ${DbFields.userFalseCorrectAnswers}
      ${DbFields.userTrueFakeAnswers}
      ${DbFields.userFalseFakeAnswers}
      ${DbFields.userNumFriends}
      ${DbFields.userSafedStatements}{
        ... on Element{
          value
        }
      }
      ${DbFields.userPlayedStatements}{
        ... on Element{
          value
        }
      }
    }
  }
}
''';
    return ret;
  }

  /// Returns the graphQL query to check the friend requests.
  static String updateUser() {
    String ret = '''
mutation updateUser(\$user: UpdateUserInput!){
  updateUser(
    input: \$user
  ){
    user{
      objectId
      ${DbFields.userName}
      ${DbFields.userData}{
        objectId
        ${DbFields.userGamesTied}
        ${DbFields.userGamesWon}
        ${DbFields.userEmoji}
        ${DbFields.userPlayedGames}
        ${DbFields.userTrueCorrectAnswers}
        ${DbFields.userFalseCorrectAnswers}
        ${DbFields.userTrueFakeAnswers}
        ${DbFields.userFalseFakeAnswers}
        ${DbFields.userNumFriends}
        ${DbFields.userSafedStatements}{
          ... on Element{
            value
          }
        }
        ${DbFields.userPlayedStatements}{
          ... on Element{
            value
          }
        }
      }
    }
  }
}
''';
    return ret;
  }

  /// Returns the graphQL query to update a game.
  static String updateGame() {
    String ret = '''
mutation updateGame(\$openGame: UpdateOpenGameInput!){
  updateOpenGame(
    input: \$openGame
  ){
    openGame{
      ${DbFields.gameRequestingPlayerIndex}
      createdAt
      objectId
      ${DbFields.gameWithTimer}
      ${DbFields.gamePlayer1Id}
      ${DbFields.gameAnswersPlayer1}{
        ... on Element{
            value
        }
      }
      ${DbFields.gamePlayer2Id}
      ${DbFields.gameAnswersPlayer2}{
        ... on Element{
            value
        }
      }
      ${DbFields.gameStatementIds}{
        ... on Element{
            value
        }
      }
      ${DbFields.gamePointsAccessed}
    }
  }
}
''';
    return ret;
  }

  /// Returns the graphQL query to upload a game.
  static String uploadGame() {
    String ret = '''
mutation uploadGame(\$openGame: CreateOpenGameInput!){
  createOpenGame(
    input: \$openGame
  ){
    openGame{
      createdAt
      objectId
      ${DbFields.gameRequestingPlayerIndex}
      ${DbFields.gameWithTimer}
      ${DbFields.gamePlayer1Id}
      ${DbFields.gameAnswersPlayer1}{
        ... on Element{
            value
        }
      }
      ${DbFields.gamePlayer2Id}
      ${DbFields.gameAnswersPlayer2}{
        ... on Element{
            value
        }
      }
      ${DbFields.gameStatementIds}{
        ... on Element{
            value
        }
      }
      ${DbFields.gamePointsAccessed}
    }
  }
}
''';
    return ret;
  }

  /// Returns the graphQL query to get a [Statement] by [Statement.objectId].
  static String getStatements() {
    String ret = '''
query getStatement(\$ids: StatementWhereInput!){
  statements(
    	where: \$ids
  ){
  edges{
    node{
      objectId
        ${DbFields.statementText}
        ${DbFields.statementPictureFile}{url}
        ${DbFields.statementYear}
        ${DbFields.statementMonth}
        ${DbFields.statementDay}
        ${DbFields.statementCorrectness}
        ${DbFields.statementMedia}
        ${DbFields.statementLanguage}
        ${DbFields.statementCategory}
        ${DbFields.statementMediatype}
        ${DbFields.statementAuthor}
        ${DbFields.statementLink}
        ${DbFields.statementRectification}
        ${DbFields.statementPictureCopyright}
        ${DbFields.statementFactcheckIDs}{
          edges{
            node{
              objectId
              ${DbFields.factText}
              ${DbFields.factAuthor}
              ${DbFields.factYear}
              ${DbFields.factMonth}
              ${DbFields.factDay}
              ${DbFields.factLanguage}
              ${DbFields.factMedia}
              ${DbFields.factLink}
              ${DbFields.factArchivedLink}
            }
          }
        }
      }
    }
  }
}
''';
    return ret;
  }

  /// Returns the graphQL query to get a [Statement] by [Statement.objectId].
  static String getStatement(String id) {
    String ret = '''
query getStatement{
  statement(
    	id: "$id"
  ){
    objectId
    ${DbFields.statementText}
    ${DbFields.statementPictureFile}{url}
    ${DbFields.statementYear}
    ${DbFields.statementMonth}
    ${DbFields.statementDay}
    ${DbFields.statementCorrectness}
    ${DbFields.statementMedia}
    ${DbFields.statementLanguage}
    ${DbFields.statementCategory}
    ${DbFields.statementMediatype}
    ${DbFields.statementAuthor}
    ${DbFields.statementLink}
    ${DbFields.statementRectification}
    ${DbFields.statementPictureCopyright}
    ${DbFields.statementFactcheckIDs}{
      edges{
        node{
          objectId
          ${DbFields.factText}
          ${DbFields.factAuthor}
          ${DbFields.factYear}
          ${DbFields.factMonth}
          ${DbFields.factDay}
          ${DbFields.factLanguage}
          ${DbFields.factMedia}
          ${DbFields.factLink}
          ${DbFields.factArchivedLink}
        }
      }
    }
  }
}
''';
    return ret;
  }

  static String removeGame() {
    String ret = '''
mutation removeGame(\$game:DeleteOpenGameInput!){
  deleteOpenGame(
    input: \$game
  ){
    openGame{
      objectId
    }
  }
}
''';
    return ret;
  }

  static String deleteUser(QuellenreiterAppState appState) {
    String deleteOpenGames = "";
    String deleteFriendships = "";
    List<PlayerRelation> friends = appState.playerRelations.friends;
    if (friends.isNotEmpty) {
      for (PlayerRelation playerRelation in friends) {
        deleteFriendships += '''
${playerRelation.opponent.name}Friendship: deleteFriendship(
  input: {
    id: "${playerRelation.friendshipId}"
  }
){
  friendship{
    objectId
  }
}
''';
        if (playerRelation.openGame != null) {
          deleteOpenGames += '''
${playerRelation.opponent.name}Game: deleteOpenGame(
  input: {
    id: "${playerRelation.openGame!.id}"
  }
){
  openGame{
    objectId
  }
}
''';
        }
      }
    }

    String ret = '''
mutation removeUser(\$user:DeleteUserInput!){
  $deleteOpenGames
  $deleteFriendships
  deleteUserData(
    input:{
      id: "${appState.player!.dataId}"
    }
  ){
    userData{
      objectId
    }
  }
  deleteUser(
    input: \$user
  ){
    user{
      objectId
    }
  }
}
''';
    return ret;
  }

  static String getUser() {
    String ret = '''
query getUser(\$user:ID!){
  user(id: \$user){
    objectId
    ${DbFields.userName}
    ${DbFields.userData}{
      objectId
      ${DbFields.userGamesTied}
      ${DbFields.userGamesWon}
      ${DbFields.userEmoji}
      ${DbFields.userPlayedGames}
      ${DbFields.userTrueCorrectAnswers}
      ${DbFields.userFalseCorrectAnswers}
      ${DbFields.userTrueFakeAnswers}
      ${DbFields.userFalseFakeAnswers}
      ${DbFields.userSafedStatements}{
        ... on Element{
          value
        }
      }
      ${DbFields.userPlayedStatements}{
        ... on Element{
          value
        }
      }
    }
  }
}
''';
    return ret;
  }
}
