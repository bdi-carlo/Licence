
/*
retourne tous les ID des joueurs présents dans une liste de type
{
	"friendslist": {
		"friends": [
			{
				"steamid": "XXXXXXXXXXXXXX",
				"relationship": "friend",
				"friend_since": 000
			}...
		]
		
	}
}
*/

var friendlistobj = {
	"friendslist": {
		"friends": [
			{
				"steamid": "76561197970590123",
				"relationship": "friend",
				"friend_since": 1435604683
			},
			{
				"steamid": "76561197976550358",
				"relationship": "friend",
				"friend_since": 1424271055
			}
		]
		
	}
}

$scope.id = function(){  
  var jsonfriend = JSON.stringify(friendlistobj)
  var obj = JSON.parse(jsonfriend)   
  var jsonData = JSON.stringify(obj.friendslist)
  var retour = '' 
  var jsonParse = JSON.parse(jsonData)
  for (var i = 0; i < jsonParse.friends.length; i++) {
    var counter = jsonParse.friends[i];
    retour = retour+counter.steamid+" "
  }
  return retour

};
