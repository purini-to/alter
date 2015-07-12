app = angular.module 'alter'

app.factory 'sessionService', ($cookieStore, $cookies, userModel, topNavModel, roomModel) ->
  session = {}

  getFavoriteRoomIds = (favoriteRooms) ->
    result = []
    for room in favoriteRooms
      result.push room._id
    result

  setFavoriteRoomMenu = (favoriteRooms) ->
    for room in favoriteRooms
      topNavModel.addToggleInMenu 'お気に入り', room.name, "chat.chatLog({roomId:'#{room._id}'})"

  session.create = (token, user) ->
    topNavModel.resetDynamicMenus()
    favoriteRoomIds = getFavoriteRoomIds user.favoriteRooms
    userModel.set user._id, user.id, user.name, user.email, favoriteRoomIds, user.avator
    $cookieStore.put 'token', token
    $cookieStore.put 'userId', userModel.user._id
    setFavoriteRoomMenu user.favoriteRooms
    session

  session.destroy = ->
    userModel.clear()
    roomModel.clear()
    topNavModel.resetDynamicMenus()
    $cookieStore.remove 'token'
    $cookieStore.remove 'userId'
    session

  session.get = (name) ->
    if (name of $cookies) is false
      return null
    $cookieStore.get name

  session
