% Picture Collection -----------------------------------------------------
% background scenery
var seafloor : int := Pic.FileNew ("Pictures/Maps/seafloor.bmp")
seafloor := Pic.Scale (seafloor, maxx, Pic.Height (seafloor))
var seaweed : int := Pic.FileNew ("Pictures/Maps/seaweed.bmp")
var sea : int := Pic.FileNew ("Pictures/Maps/sea.jpg")
var title : int := Pic.FileNew ("Pictures/Title.bmp")
var pauseMenu : int := Pic.FileNew ("Pictures/Screens/PauseMenuBoard.bmp")
var matchMakingMenu : int := Pic.FileNew ("Pictures/Screens/MatchMakingMenu.bmp")
var resultScreen : int := Pic.FileNew ("Pictures/Screens/ResultScreen.bmp")
var halo : int := Pic.FileNew ("Pictures/Halo.bmp")
var expBar : int := Pic.FileNew ("Pictures/ExpBar.bmp")
% blue piranha
var bluePiranha : GrowingBody
bluePiranha.picRight (1) := Pic.FileNew ("Pictures/Fish/Piranha/BluePiranha/BluePiranhaS1.bmp")
bluePiranha.picRight (2) := Pic.FileNew ("Pictures/Fish/Piranha/BluePiranha/BluePiranhaS2.bmp")
bluePiranha.picRight (3) := Pic.FileNew ("Pictures/Fish/Piranha/BluePiranha/BluePiranhaS3.bmp")
bluePiranha.picRight (4) := Pic.FileNew ("Pictures/Fish/Piranha/BluePiranha/BluePiranhaS4.bmp")
bluePiranha.picRight (5) := Pic.FileNew ("Pictures/Fish/Piranha/BluePiranha/BluePiranhaS5.bmp")
for i : 1 .. upper (bluePiranha.picRight)
    bluePiranha.picLeft (i) := Pic.Mirror (bluePiranha.picRight (i))
end for
bluePiranha.pic := bluePiranha.picRight (1)

% red piranha
var redPiranha : GrowingBody
redPiranha.picRight (1) := Pic.FileNew ("Pictures/Fish/Piranha/RedPiranha/RedPiranhaS1.bmp")
redPiranha.picRight (2) := Pic.FileNew ("Pictures/Fish/Piranha/RedPiranha/RedPiranhaS2.bmp")
redPiranha.picRight (3) := Pic.FileNew ("Pictures/Fish/Piranha/RedPiranha/RedPiranhaS3.bmp")
redPiranha.picRight (4) := Pic.FileNew ("Pictures/Fish/Piranha/RedPiranha/RedPiranhaS4.bmp")
redPiranha.picRight (5) := Pic.FileNew ("Pictures/Fish/Piranha/RedPiranha/RedPiranhaS5.bmp")
for i : 1 .. upper (redPiranha.picRight)
    redPiranha.picLeft (i) := Pic.Mirror (redPiranha.picRight (i))
end for
redPiranha.pic := redPiranha.picRight (1)

% yellow piranha
var yellowPiranha : GrowingBody
yellowPiranha.picRight (1) := Pic.FileNew ("Pictures/Fish/Piranha/YellowPiranha/YellowPiranhaS1.bmp")
yellowPiranha.picRight (2) := Pic.FileNew ("Pictures/Fish/Piranha/YellowPiranha/YellowPiranhaS2.bmp")
yellowPiranha.picRight (3) := Pic.FileNew ("Pictures/Fish/Piranha/YellowPiranha/YellowPiranhaS3.bmp")
yellowPiranha.picRight (4) := Pic.FileNew ("Pictures/Fish/Piranha/YellowPiranha/YellowPiranhaS4.bmp")
yellowPiranha.picRight (5) := Pic.FileNew ("Pictures/Fish/Piranha/YellowPiranha/YellowPiranhaS5.bmp")
for i : 1 .. upper (yellowPiranha.picRight)
    yellowPiranha.picLeft (i) := Pic.Mirror (yellowPiranha.picRight (i))
end for
yellowPiranha.pic := yellowPiranha.picRight (1)

% Anchovy
var anchovy : NormalBody
anchovy.picRight := Pic.FileNew ("Pictures/Fish/Anchovy.bmp")
anchovy.picLeft := Pic.Mirror (anchovy.picRight)
anchovy.pic := anchovy.picRight

% PufferFish
var pufferFish : NormalBody
pufferFish.picRight := Pic.FileNew ("Pictures/Fish/PufferFish.bmp")
pufferFish.picLeft := Pic.Mirror (pufferFish.picRight)
pufferFish.pic := pufferFish.picRight

% AnglerFish
var anglerFish : NormalBody
anglerFish.picRight := Pic.FileNew ("Pictures/Fish/anglerFish.bmp")
anglerFish.picLeft := Pic.Mirror (anglerFish.picRight)
anglerFish.pic := anglerFish.picRight

% Shark
var shark : NormalBody
shark.picRight := Pic.FileNew ("Pictures/Fish/Shark.bmp")
shark.picLeft := Pic.Mirror (shark.picRight)
shark.pic := shark.picRight
% var sharkIcon : int := Pic.Scale (shark.pic, round (Pic.Width (shark.pic) / (Pic.Height (shark.pic) / Pic.Height (bluePiranha.pic))), Pic.Height (bluePiranha.pic))

var fishIcons : array 1 .. 3 of int
fishIcons (1) := Pic.Scale (anchovy.pic, round (Pic.Width (anchovy.pic) / (Pic.Height (anchovy.pic) / Pic.Height (bluePiranha.pic))) div 2, Pic.Height (bluePiranha.pic) div 2)
fishIcons (2) := Pic.Scale (pufferFish.pic, round (Pic.Width (pufferFish.pic) / (Pic.Height (pufferFish.pic) / Pic.Height (bluePiranha.pic))), Pic.Height (bluePiranha.pic))
fishIcons (3) := Pic.Scale (anglerFish.pic, round (Pic.Width (anglerFish.pic) / (Pic.Height (anglerFish.pic) / Pic.Height (bluePiranha.pic))), Pic.Height (bluePiranha.pic))

% End of Picture Collection -----------------------------------------------------
