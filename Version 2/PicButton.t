% must include "type Postion :" located in Types.t
class PicButton
    import Position, GameStatus
    export Init, IsMouseOn, DrawButton, var position, var picCurrent, var buttonStatus

    var buttonStatus : GameStatus
    var picCurrent : int
    var picNormal : int
    var picHover : int
    var selected : boolean
    var position : Position
    var height, width : int

    proc Init (picNormalFileName, picHoverFileName : string, x, y : int, status : GameStatus)
	picNormal := Pic.FileNew (picNormalFileName)
	picHover := Pic.FileNew (picHoverFileName)
	picCurrent := picNormal
	height := Pic.Height (picCurrent)
	width := Pic.Width (picCurrent)
	position.x := x
	position.y := y
	buttonStatus := status
    end Init

    function IsMouseOn (x, y : int) : boolean
	if x > position.x and x < position.x + width and y > position.y and y < position.y + height then
	    picCurrent := picHover
	    result true
	else
	    picCurrent := picNormal
	    result false
	end if
    end IsMouseOn

    proc DrawButton
	Pic.Draw (picCurrent, position.x, position.y, picMerge)
    end DrawButton
end PicButton
