var window : int := Window.Open ("graphics: max;max, offscreenonly")
var currentMusic : string

function Distance (x1, y1, x2, y2 : int) : int
    var distance : int := round (sqrt (round ((x1 - x2) ** 2 + (y1 - y2) ** 2)))
    result distance
end Distance

process EatingSound
    Music.PlayFileReturn ("Music/EatingSound.wav")
end EatingSound

include "Types.t"
include "PicButton.t"
include "Game.t"
include "Timer.t"
var HighTowerTextSize20 : int := Font.New ("High Tower Text:20")
var gameTime : int := 180
var gameTimer : pointer to Timer
new Timer, gameTimer
gameTimer -> Init (gameTime, HighTowerTextSize20)

include "PauseMenu.t"
include "Pictures.t"
include "AiFish.t"
include "Player.t"
include "Variables.t"
include "Procedures.t"



game -> status := GameStatus.Main
Music.PlayFileLoop ("Music/Feeding Frenzy - Menu Ost.mp3")
loop
    if game -> status = GameStatus.Play then
	endGame := false
	RunGame
    elsif game -> status = GameStatus.Main or game -> status = GameStatus.Highscore then
	if game -> status = GameStatus.Main then
	    RunMainMenu
	elsif game -> status = GameStatus.Highscore then
	    RunHighscores
	end if
    else
	exit
    end if
end loop
Music.PlayFileStop
Window.Close (window)
