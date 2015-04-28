app = angular.module 'alter'

app.factory 'stateUtil', ($state) ->
  func = {}

  func.getCurrentParentsState = (reverse = false) ->
    result = []
    _state = $state.$current
    loop
      result.push _state.self
      _state = _state.parent
      break unless _state? and _state.parent?
    if reverse is true
      result = result.reverse()
    result

  func
