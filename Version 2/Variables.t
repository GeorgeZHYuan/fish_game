% Variable Collection -----------------------------------------------------
% game settings
var gameSpeed : int := 5
var startGame, endGame, matchMaking : boolean := false

% game status
var game : pointer to Game
new Game, game
game -> status := GameStatus.Main

% Fonts
var EngraversMTSize40 : int := Font.New ("Engravers MT:40")

% Main Menu Variables
var mainMenuButtons : array 1 .. 3 of ^PicButton
new PicButton, mainMenuButtons (1)
mainMenuButtons (1) -> Init ("Pictures/Buttons/PlayButton.bmp", "Pictures/Buttons/PressedPlayButton.bmp", maxx div 2 - 110, maxy div 2 - 80, GameStatus.Play)
new PicButton, mainMenuButtons (2)
mainMenuButtons (2) -> Init ("Pictures/Buttons/HighScoreButton.bmp", "Pictures/Buttons/PressedHighScoreButton.bmp", maxx div 2 - 110, maxy div 2 - 180, GameStatus.Highscore)
new PicButton, mainMenuButtons (3)
mainMenuButtons (3) -> Init ("Pictures/Buttons/QuitButton.bmp", "Pictures/Buttons/PressedQuitButton.bmp", maxx div 2 - 110, maxy div 2 - 280, GameStatus.Quit)

% Match Making Menu Buttons
var matchMakingButton : array 1 .. 2 of ^PicButton
new PicButton, matchMakingButton (1)
matchMakingButton (1) -> Init ("Pictures/Buttons/ReadyButton.bmp", "Pictures/Buttons/PressedReadyButton.bmp", maxx div 2 - 80, maxy div 6, GameStatus.Play)
new PicButton, matchMakingButton (2)
matchMakingButton (2) -> Init ("Pictures/Buttons/ExitButton.bmp", "Pictures/Buttons/PressedExitButton.bmp", maxx div 2 + 20, maxy div 6, GameStatus.Main)

% Highscore Buttons
var submitHighScoreButton : ^PicButton
new PicButton, submitHighScoreButton
submitHighScoreButton -> Init ("Pictures/Buttons/SubmitHighScoreButton.bmp", "Pictures/Buttons/PressedSubmitHighScoreButton.bmp", maxx div 2 - 460, maxy div 6, GameStatus.Main)
var exitHighscoreButton : array 1 .. 2 of ^PicButton
new PicButton, exitHighscoreButton (1)
exitHighscoreButton (1) -> Init ("Pictures/Buttons/ExitButton.bmp", "Pictures/Buttons/PressedExitButton.bmp", maxx div 2 - 20, maxy div 6, GameStatus.Main)
new PicButton, exitHighscoreButton (2)
exitHighscoreButton (2) -> Init ("Pictures/Buttons/ExitButton.bmp", "Pictures/Buttons/PressedExitButton.bmp", maxx div 2 - 20, maxy div 6, GameStatus.Main)

% Pause Menu Variables
var pauseMenuButtons : array 1 .. 3 of pointer to PauseMenu
new PauseMenu, pauseMenuButtons (1)
pauseMenuButtons (1) -> Init ("Resume", HighTowerTextSize20, white, grey, maxx div 2 - 55, maxy div 2 + 60, 105, 25, PauseButtonFunction.Resume)
new PauseMenu, pauseMenuButtons (2)
pauseMenuButtons (2) -> Init ("Main Menu", HighTowerTextSize20, white, grey, maxx div 2 - 80, maxy div 2 - 10, 165, 25, PauseButtonFunction.MainMenu)
new PauseMenu, pauseMenuButtons (3)
pauseMenuButtons (3) -> Init ("Restart", HighTowerTextSize20, white, grey, maxx div 2 - 50, maxy div 2 - 80, 90, 25, PauseButtonFunction.Restart)

% players variables
var players : array 1 .. 3 of ^Player
for i : 1 .. upper (players)
    new Player, players (i)
end for

players (1) -> controller := ControllerType.red
players (2) -> controller := ControllerType.blue
players (3) -> controller := ControllerType.yellow
players (1) -> playerBody := redPiranha
players (2) -> playerBody := bluePiranha
players (3) -> playerBody := yellowPiranha

% AiFish Variables
var aiFish1 : array 1 .. 2 of ^AiFish
var aiFish2 : array 1 .. 5 of ^AiFish
var aiFish3 : array 1 .. 10 of ^AiFish
var aiFish4 : array 1 .. 30 of ^AiFish
for i : 1 .. upper (aiFish1)
    new AiFish, aiFish1 (i)
    aiFish1 (i) -> Init (shark, 7, 25, 10, 30, 0, -15, 5, 500)
end for
for i : 1 .. upper (aiFish2)
    new AiFish, aiFish2 (i)
    aiFish2 (i) -> Init (anglerFish, 5, 3, 3, 10, -10, -20, -5, 200)
end for
for i : 1 .. upper (aiFish3)
    new AiFish, aiFish3 (i)
    aiFish3 (i) -> Init (pufferFish, 3, 2, 1, 6, 0, 0, 0, 50)
end for
for i : 1 .. upper (aiFish4)
    new AiFish, aiFish4 (i)
    aiFish4 (i) -> Init (anchovy, 1, 1, 1, 8, 0, 0, 0, 0)
end for

% End of Variable Collection -----------------------------------------------------
