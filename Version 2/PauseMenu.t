class PauseMenu
    import Position, PauseButtonFunction, Timer, Game, GameStatus
    export Init, IsMouseOn, DrawButton, Execute

    var button : PauseButtonFunction
    var buttonLabel : string
    var font : int
    var colorCurrent : int
    var colorNormal : int
    var colorHover : int
    var position : Position
    var height : int
    var width : int
    var pauseMenuBoard : int

    proc Init (_buttonLabel : string, _font, _colorNormal, _colorHover, x, y, _width, _height : int, buttonFuncition : PauseButtonFunction)
	buttonLabel := _buttonLabel
	font := _font
	colorNormal := _colorNormal
	colorHover := _colorHover
	colorCurrent := _colorNormal
	position.x := x
	position.y := y - 20
	width := _width
	height := _height
	button := buttonFuncition
    end Init

    function IsMouseOn (x, y : int) : boolean
	if x > position.x and x < position.x + width and y > position.y and y < position.y + height then
	    colorCurrent := colorHover
	    result true
	else
	    colorCurrent := colorNormal
	    result false
	end if
    end IsMouseOn

    proc DrawButton
	Draw.Text (buttonLabel, position.x, position.y, font, colorCurrent)
    end DrawButton

    proc Execute (gameTimer : pointer to Timer, game : pointer to Game, var endGame, startGame : boolean)
	if button = PauseButtonFunction.Resume then
	    gameTimer -> Resume
	elsif button = PauseButtonFunction.MainMenu then
	    endGame := true
	    game -> status := GameStatus.Main
	else
	    game -> status := GameStatus.Play
	    endGame := true
	    startGame := true
	end if

    end Execute

end PauseMenu
