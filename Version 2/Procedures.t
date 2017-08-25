proc CheckMusic
    Music.PlayFileStop
    var stoppedTime : int := Time.Elapsed div 1000
    var reps : int := 0
    drawfillbox (0, 0, maxx, maxy, black)
    Draw.Text ("Loading", (maxx div 2) - 50, maxy div 2, HighTowerTextSize20, white)
    View.Update
    loop
	exit when Time.Elapsed - stoppedTime * 1000 > 1500
    end loop
    if game -> status = GameStatus.Play then
	var i : int
	randint (i, 1, 3)
	if i = 1 then
	    currentMusic := "Music/Feeding Frenzy - Ost 1.mp3"
	elsif i = 2 then
	    currentMusic := "Music/Feeding Frenzy - Ost 3.mp3"
	elsif i = 3 then
	    currentMusic := "Music/Feeding Frenzy - Ost 4.mp3"
	end if
    elsif game -> status = GameStatus.Main or game -> status = GameStatus.Highscore then
	currentMusic := "Music/Feeding Frenzy - Menu Ost.mp3"
    else
    end if
    Music.PlayFileLoop (currentMusic)
end CheckMusic

proc sortScores (var scores : array 1 .. * of HighscoreEntry)
    var space : int := upper (scores)
    loop
	space := floor (space / 2)
	exit when space <= 0
	for i : space + 1 .. upper (scores)
	    var j : int := i - space
	    loop
		exit when j <= 0
		if scores (j).score > scores (j + space).score then
		    const tempScore := scores (j).score
		    const tempName := scores (j).name
		    scores (j).score := scores (j + space).score
		    scores (j).name := scores (j + space).name
		    scores (j + space).score := tempScore
		    scores (j + space).name := tempName
		    j := j - space
		else
		    j := 0 % Signal exit
		end if
	    end loop
	end for
    end loop
end sortScores

proc GetString (var input : string, limit : int)
    var ch : string (1)
    var allowed := "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 "
    if hasch then
	getch (ch)
	if ch = "\b" then
	    if length (input) > 0 then
		var sub : string := input
		input := ""
		for i : 1 .. length (sub) - 1
		    input += sub (i)
		end for
	    end if
	elsif length (input) <= limit and index (allowed, ch) > 0 then
	    input += ch
	end if
    end if
end GetString

proc Pause
    var getKey : array char of boolean
    var exitPause : boolean := false
    var which : int
    gameTimer -> Pause
    Input.KeyDown (getKey)
    if getKey ('p') then
	loop
	    exit when exitPause = true
	    Pic.Draw (pauseMenu, maxx div 2 - Pic.Width (pauseMenu) div 2, maxy div 2 - Pic.Height (pauseMenu) div 2, picMerge)
	    var x, y, btnnum, btnupdown : int := 0
	    for i : 1 .. 3
		which := i
		Mouse.Where (x, y, btnupdown)
		if pauseMenuButtons (i) -> IsMouseOn (x, y) = true and btnupdown = 0 then
		    delay (100)
		    if buttonmoved ("down") then
			buttonwait ("down", x, y, btnnum, btnupdown)
			pauseMenuButtons (i) -> Execute (gameTimer, game, endGame, startGame)
			exitPause := true
			if which = 3 then
			    Music.PlayFileStop
			    var stoppedTime : int := Time.Elapsed div 1000
			    var reps : int := 0
			    drawfillbox (0, 0, maxx, maxy, black)
			    Draw.Text ("Loading", (maxx div 2) - 50, maxy div 2, HighTowerTextSize20, white)
			    View.Update
			    loop
				exit when Time.Elapsed - stoppedTime * 1000 > 1500
			    end loop
			    currentMusic := "Music/Feeding Frenzy - Menu Ost.mp3"
			    Music.PlayFileLoop (currentMusic)
			end if
		    end if
		end if
		if buttonmoved ("down") then
		    buttonwait ("down", x, y, btnnum, btnupdown)
		end if
		pauseMenuButtons (i) -> DrawButton

		exit when exitPause = true
	    end for
	    btnupdown := 0
	    View.Update
	    var lastFrame : int := Time.Elapsed
	    loop
		exit when Time.Elapsed - lastFrame > gameSpeed
	    end loop
	    % Time.Delay (gameSpeed)
	end loop
    end if
end Pause

proc DrawBackground
    Pic.Draw (sea, 0, 0, picCopy)
    Pic.Draw (seafloor, 0, 0, picMerge)
    Pic.Draw (seafloor, 0, 0, picMerge)
    Pic.Draw (seaweed, 856, 0, picMerge)
    for i : 1 .. upper (aiFish1)
	aiFish1 (i) -> SpawnRate (players (1) -> experience, players (2) -> experience, players (3) -> experience)
	aiFish1 (i) -> Update
	aiFish1 (i) -> DrawFish
	aiFish1 (i) -> Eat (aiFish2)
	aiFish1 (i) -> Eat (aiFish3)
	aiFish1 (i) -> Eat (aiFish4)
    end for
    for i : 1 .. upper (aiFish2)
	aiFish2 (i) -> Update
	aiFish2 (i) -> DrawFish
	aiFish2 (i) -> Eat (aiFish3)
	aiFish2 (i) -> Eat (aiFish4)
    end for
    for i : 1 .. upper (aiFish3)
	aiFish3 (i) -> Update
	aiFish3 (i) -> DrawFish
	aiFish3 (i) -> Eat (aiFish4)
    end for
    for i : 1 .. upper (aiFish4)
	aiFish4 (i) -> Update
	aiFish4 (i) -> DrawFish
    end for
end DrawBackground

proc RunMainMenu
    var getOut : boolean := false
    loop
	exit when getOut
	cls
	endGame := false
	DrawBackground
	var x, y, btnnum, btnupdown : int := 0
	Pic.Draw (title, maxx div 2 - 525, maxy div 2 + 180, picMerge)
	for i : 1 .. upper (mainMenuButtons)
	    Mouse.Where (x, y, btnupdown)
	    if mainMenuButtons (i) -> IsMouseOn (x, y) = true and btnupdown = 1 then
		btnupdown := 0
		if Mouse.ButtonMoved ("down") then
		    Mouse.ButtonWait ("down", x, y, btnnum, btnupdown)
		    endGame := false
		    game -> status := mainMenuButtons (i) -> buttonStatus
		    getOut := true
		end if
	    end if
	    mainMenuButtons (i) -> DrawButton
	end for
	View.Update
	var lastFrame : int := Time.Elapsed
	loop
	    exit when Time.Elapsed - lastFrame > gameSpeed
	end loop
	% Time.Delay (gameSpeed)
    end loop
end RunMainMenu

proc MatchMaking
    matchMaking := true
    var getKey : array char of boolean
    loop
	Input.KeyDown (getKey)
	exit when matchMaking = false
	cls
	DrawBackground
	Pic.Draw (matchMakingMenu, maxx div 2 - (Pic.Width (matchMakingMenu) div 2), maxy div 2 - (Pic.Height (matchMakingMenu) div 2), picMerge)
	var x, y, btnnum, btnupdown : int := 0
	Mouse.Where (x, y, btnupdown)
	setscreen ("noecho")
	if getKey ('1') then
	    if players (1) -> exist then
		players (1) -> exist := false
	    else
		players (1) -> exist := true
	    end if
	    delay (50)
	end if
	if getKey ('2') then
	    if players (2) -> exist then
		players (2) -> exist := false
	    else
		players (2) -> exist := true
	    end if
	    delay (80)
	end if
	if getKey ('3') then
	    if players (3) -> exist then
		players (3) -> exist := false
	    else
		players (3) -> exist := true
	    end if
	    delay (50)
	end if
	var matchMenuPaddingX : int := maxx div 2 - (Pic.Width (matchMakingMenu) div 2)
	var matchMenuPaddingY : int := maxy div 2 - (Pic.Height (matchMakingMenu) div 2)
	for i : 1 .. upper (players)
	    if players (i) -> exist = true then
		Pic.Draw (players (i) -> playerBody.picRight (3), ((i * 350) - Pic.Width (players (i) -> playerBody.picRight (3))) + matchMenuPaddingX, maxy div 2 - 200, picMerge)
		players (i) -> Init (i, i * 500, 500)
	    end if
	end for
	for i : 1 .. 2
	    if matchMakingButton (i) -> IsMouseOn (x, y) = true and btnupdown = 1 then
		btnupdown := 0
		if Mouse.ButtonMoved ("down") then
		    Mouse.ButtonWait ("down", x, y, btnnum, btnupdown)
		    if matchMakingButton (i) -> buttonStatus = GameStatus.Main then
			game -> status := GameStatus.Main
			endGame := true
		    end if
		    matchMaking := false
		    exit
		end if
	    end if
	    matchMakingButton (i) -> DrawButton
	end for
	View.Update
	var lastFrame : int := Time.Elapsed
	loop
	    exit when Time.Elapsed - lastFrame > gameSpeed
	end loop
	% Time.Delay (gameSpeed)
    end loop
    if game -> status = GameStatus.Play then
	CheckMusic
    end if
end MatchMaking

proc RunHighscores
    var getKey : array char of boolean
    var blank : boolean := true
    var padding : int := 0
    var file : int
    var highscores : HighscoreEntry
    open : file, "Scores/Highscores.txt", read
    var number : int := 0
    loop
	exit when eof (file)
	read : file, highscores
	number += 1
    end loop
    if number = 0 then
	number := 2
    else
	blank := false
    end if
    close : file
    var entry : array 1 .. number of HighscoreEntry
    if blank = false then
	open : file, "Scores/Highscores.txt", read
	number := 0
	loop
	    exit when eof (file)
	    read : file, highscores
	    number += 1
	    entry (number) := highscores
	end loop
	close : file
	sortScores (entry)
    end if
    loop
	cls
	Input.KeyDown (getKey)
	if getKey (KEY_DOWN_ARROW) then
	    padding += 1
	end if
	if getKey (KEY_UP_ARROW) then
	    padding -= 1
	end if
	if upper (entry) > 10 then
	    if padding > upper (entry) - 10 then
		padding := upper (entry) - 10
	    end if
	else
	    padding := 0
	end if

	if padding < 0 then
	    padding := 0
	end if
	DrawBackground
	Draw.Text ("HIGHSCORES", maxx div 2 - 100, round (maxy * 0.9), HighTowerTextSize20, white)
	Draw.Text ("Place", maxx div 2 - maxx div 4 - 100, round (maxy * 0.8) + 20, HighTowerTextSize20, white)
	Draw.Text ("Score", maxx div 2 + maxx div 4, round (maxy * 0.8) + 20, HighTowerTextSize20, white)
	Draw.Text ("Name", maxx div 2 - maxx div 4, round (maxy * 0.8) + 20, HighTowerTextSize20, white)
	if blank then
	    Draw.Text ("Currently No Highscores", maxx div 2 - 160, maxy div 2, HighTowerTextSize20, white)
	else
	    for i : 1 .. 10
		exit when i > upper (entry)
		for j : 1 .. ((maxx div 2 - maxx div 4) div 6)
		    Draw.Text (".", maxx div 2 - maxx div 4 + 200 + j * 8, round (maxy * 0.8) - (i * 50), HighTowerTextSize20, white)
		end for
		Draw.Text (intstr (i + padding) + ".", maxx div 2 - maxx div 4 - 100, round (maxy * 0.8) - (i * 50), HighTowerTextSize20, white)
		Draw.Text (entry (upper (entry) + 1 - i - padding).name, maxx div 2 - maxx div 4, round (maxy * 0.8) - (i * 50), HighTowerTextSize20, white)
		Draw.Text (intstr (entry (upper (entry) + 1 - i - padding).score), maxx div 2 + maxx div 4, round (maxy * 0.8) - (i * 50), HighTowerTextSize20, white)
	    end for
	end if
	var x, y, btnnum, btnupdown : int := 0
	Mouse.Where (x, y, btnupdown)
	if exitHighscoreButton (1) -> IsMouseOn (x, y) = true and btnupdown = 1 then
	    btnupdown := 0
	    if Mouse.ButtonMoved ("down") then
		Mouse.ButtonWait ("down", x, y, btnnum, btnupdown)
		game -> status := exitHighscoreButton (1) -> buttonStatus
		exit
	    end if
	end if
	exitHighscoreButton (1) -> DrawButton
	endGame := false
	View.Update
	var lastFrame : int := Time.Elapsed
	loop
	    exit when Time.Elapsed - lastFrame > gameSpeed
	end loop
	% Time.Delay (gameSpeed)
    end loop
end RunHighscores

proc CalculateResults (player : ^Player, item : int, amount : int)
    if player -> eatItems (item) > 0 then
	player -> score += amount
	player -> eatItems (item) -= 1
    end if
end CalculateResults

proc Results
    var exitResults : boolean := false
    var high, win : int := -1
    var winner, tie, submitted : boolean := false
    var stopCalculate : array 1 .. 3, 1 .. 3 of boolean
    for i : 1 .. 3
	for j : 1 .. 3
	    stopCalculate (i, j) := true
	end for
    end for
    loop
	cls
	DrawBackground
	Pic.Draw (resultScreen, maxx div 2 - (Pic.Width (resultScreen) div 2), maxy div 2 - (Pic.Height (resultScreen) div 2), picMerge)
	Draw.Text ("Players", maxx div 2 - 480 - 20, maxy div 2 + 260 - (40 + (80)), HighTowerTextSize20, white)
	% Draw.Text ("Deaths", maxx div 2 + 150 - 20, maxy div 2 + 260 - (40 + (80)), HighTowerTextSize20, white)
	% Draw.Text ("Bonus", maxx div 2 + 300 - 20, maxy div 2 + 260 - (40 + (80)), HighTowerTextSize20, white)
	Draw.Text ("Score", maxx div 2 + 300 - 20, maxy div 2 + 260 - (40 + (80)), HighTowerTextSize20, white)
	var a : int := 1
	for i : 1 .. upper (players)
	    if players (i) -> exist = true then
		if players (i) -> eatItems (1) > 0 then
		    CalculateResults (players (i), 1, aiFish4 (1) -> level)
		    stopCalculate (i, 1) := false
		elsif players (i) -> eatItems (2) > 0 then
		    CalculateResults (players (i), 2, aiFish3 (1) -> level)
		    stopCalculate (i, 1) := false
		elsif players (i) -> eatItems (3) > 0 then
		    CalculateResults (players (i), 3, aiFish2 (1) -> level)
		    stopCalculate (i, 1) := false
		else
		    stopCalculate (i, 1) := true
		    stopCalculate (i, 2) := true
		    stopCalculate (i, 3) := true
		end if
		Pic.Draw (players (i) -> playerBody.picRight (1), maxx div 2 - 460 - 20, maxy div 2 + 180 - (40 + (80 * a)), picMerge)
		Draw.Text (intstr (players (i) -> score, 0), maxx div 2 + 300, maxy div 2 + 180 - (40 + (80 * a)), HighTowerTextSize20, white)
		for j : 1 .. upper (fishIcons)
		    Draw.Text (intstr (players (i) -> eatItems (j)), maxx div 2 - 460 - 60 + (j * 165), maxy div 2 + 180 - (40 + (80 * a)), HighTowerTextSize20, white)
		    Pic.Draw (fishIcons (j), maxx div 2 - 460 - 20 + (j * 165), maxy div 2 + 180 - (40 + (80 * a)), picMerge)
		end for
		a += 1
	    end if
	end for
	a := 1
	if stopCalculate (1, 1) and stopCalculate (1, 2) and stopCalculate (1, 3) and stopCalculate (2, 1) and stopCalculate (2, 2) and stopCalculate (2, 3) and stopCalculate (3, 1) and
		stopCalculate (3, 2) and stopCalculate (3, 3) then
	    exit
	end if
	View.Update
	var lastFrame : int := Time.Elapsed
	loop
	    exit when Time.Elapsed - lastFrame > gameSpeed
	end loop
	% Time.Delay (gameSpeed)
    end loop
    for i : 1 .. upper (players)
	if players (i) -> exist then
	    if players (i) -> score > high then
		high := players (i) -> score
		win := i
		winner := true
		tie := false
	    elsif players (i) -> score = high then
		winner := false
		tie := true
	    end if
	end if
    end for
    var newHighscoreEntry : HighscoreEntry
    newHighscoreEntry.name := "George"
    newHighscoreEntry.score := high
    var x, y, btnnum, btnupdown : int := 0
    Mouse.Where (x, y, btnupdown)
    loop
	exit when exitResults
	DrawBackground
	Pic.Draw (resultScreen, maxx div 2 - (Pic.Width (resultScreen) div 2), maxy div 2 - (Pic.Height (resultScreen) div 2), picMerge)
	var a : int := 1
	for i : 1 .. upper (players)
	    if players (i) -> exist = true then
		Pic.Draw (players (i) -> playerBody.picRight (1), maxx div 2 - 460 - 20, maxy div 2 + 180 - (40 + (80 * a)), picMerge)
		Draw.Text (intstr (players (i) -> score, 0), maxx div 2 + 300, maxy div 2 + 180 - (40 + (80 * a)), HighTowerTextSize20, white)
		for j : 1 .. upper (fishIcons)
		    Draw.Text (intstr (players (i) -> eatItems (j)), maxx div 2 - 460 - 60 + (j * 165), maxy div 2 + 180 - (40 + (80 * a)), HighTowerTextSize20, white)
		    Pic.Draw (fishIcons (j), maxx div 2 - 460 - 20 + (j * 165), maxy div 2 + 180 - (40 + (80 * a)), picMerge)
		end for
		a += 1
	    end if
	end for
	a := 1
	if winner or tie then
	    Draw.Text ("Players", maxx div 2 - 480 - 20, maxy div 2 + 260 - (40 + (80)), HighTowerTextSize20, white)
	    % Draw.Text ("Deaths", maxx div 2 + 150 - 20, maxy div 2 + 260 - (40 + (80)), HighTowerTextSize20, white)
	    % Draw.Text ("Bonus", maxx div 2 + 300 - 20, maxy div 2 + 260 - (40 + (80)), HighTowerTextSize20, white)
	    Draw.Text ("Score", maxx div 2 + 300 - 20, maxy div 2 + 260 - (40 + (80)), HighTowerTextSize20, white)
	    Draw.Text ("Score: " + intstr (high), (maxx div 2) - 460, maxy div 2 - 260, HighTowerTextSize20, white)
	    if winner then
		if win = 1 then
		    Draw.Text ("RedFish Wins", (maxx div 2) - 80, maxy div 2 - 180, HighTowerTextSize20, white)
		elsif win = 2 then
		    Draw.Text ("BlueFish Wins", (maxx div 2) - 80, maxy div 2 - 180, HighTowerTextSize20, white)
		else
		    Draw.Text ("GoldFish Wins", (maxx div 2) - 80, maxy div 2 - 180, HighTowerTextSize20, white)
		end if
		Draw.Text ("Name: " + newHighscoreEntry.name, (maxx div 2) - 460, maxy div 2 - 220, HighTowerTextSize20, white)
		GetString (newHighscoreEntry.name, 12)
	    elsif tie then
		Draw.Text ("Its a Tie", (maxx div 2) - 45, maxy div 2 - 180, HighTowerTextSize20, white)
		Draw.Text ("Initials: " + newHighscoreEntry.name, (maxx div 2) - 460, maxy div 2 - 220, HighTowerTextSize20, white)
		GetString (newHighscoreEntry.name, 8)
	    end if
	    if submitted then
		Draw.Text ("Highscore Submitted", (maxx div 2) - 460, maxy div 2 - 300, HighTowerTextSize20, white)
	    else
		if submitHighScoreButton -> IsMouseOn (x, y) = true and btnupdown = 1 then
		    btnupdown := 0
		    if Mouse.ButtonMoved ("down") then
			submitted := true
			if tie then
			    newHighscoreEntry.name := newHighscoreEntry.name + "Tied"
			end if
			Mouse.ButtonWait ("down", x, y, btnnum, btnupdown)
			var fileNo1, fileNo2 : int
			open : fileNo1, "Scores/Highscores.txt", write, seek, mod
			open : fileNo2, "Scores/Highscores - Copy.txt", write, seek, mod
			seek : fileNo1, *
			seek : fileNo2, *
			write : fileNo1, newHighscoreEntry
			write : fileNo2, newHighscoreEntry
			close : fileNo1
			close : fileNo2
		    end if
		end if
		submitHighScoreButton -> DrawButton
	    end if
	else
	    Draw.Text ("Specated Game", (maxx div 2) - 70, maxy div 2 - 150, HighTowerTextSize20, white)
	end if
	Mouse.Where (x, y, btnupdown)
	if exitHighscoreButton (2) -> IsMouseOn (x, y) = true and btnupdown = 1 then
	    btnupdown := 0
	    if Mouse.ButtonMoved ("down") then
		Mouse.ButtonWait ("down", x, y, btnnum, btnupdown)
		game -> status := exitHighscoreButton (2) -> buttonStatus
		exit
	    end if
	end if
	exitHighscoreButton (2) -> DrawButton
	View.Update
	var lastFrame : int := Time.Elapsed
	loop
	    exit when Time.Elapsed - lastFrame > gameSpeed
	end loop
	% Time.Delay (gameSpeed)
	cls
    end loop
end Results

proc RunGame
    startGame := true
    loop
	if game -> status = GameStatus.Main then
	    CheckMusic
	end if
	exit when endGame = true
	MatchMaking
	exit when endGame = true
	gameTimer -> Init (gameTime, HighTowerTextSize20)
	gameTimer -> Resume
	for i : 1 .. upper (players)
	    players (i) -> ReInit
	end for
	loop
	    exit when endGame = true
	    Pause
	    DrawBackground
	    gameTimer -> Tick
	    gameTimer -> DrawTime
	    %Draw.Text ("Score", round (maxx * 0.05), maxy - 40, HighTowerTextSize20, white)
	    Draw.Text ("Players", round (maxx * 0.05) - Pic.Width (players (1) -> playerBody.picRight (1)) - 20, maxy - (40), HighTowerTextSize20, white)
	    Draw.Text ("Experience", round (maxx * 0.15), maxy - 40, HighTowerTextSize20, white)
	    for i : 1 .. upper (players)
		players (i) -> Eat (aiFish1)
		players (i) -> Eat (aiFish2)
		players (i) -> Eat (aiFish4)
		players (i) -> Eat (aiFish3)
		players (i) -> Update
	    end for
	    var a : int := 1
	    for i : 1 .. upper (players)
		if players (i) -> exist = true then
		    Pic.Draw (players (i) -> playerBody.picRight (1), round (maxx * 0.05) - Pic.Width (players (i) -> playerBody.picRight (1)) - 20, maxy - (50 + (40 * a)), picMerge)
		    % Draw.Text (intstr (players (i) -> score, 0), round (maxx * 0.05), maxy - (40 + (40 * a)), HighTowerTextSize20, white)
		    for j : 1 .. upper (fishIcons)
			Draw.Text (intstr (players (i) -> eatItems (j)), round (maxx * 0.6) - 60 + (j * 165), maxy - (40 + (40 * a)), HighTowerTextSize20, white)
			Pic.Draw (fishIcons (j), round (maxx * 0.6) - 20 + (j * 165), maxy - (40 + (40 * a)), picMerge)
		    end for
		    players (i) -> DrawFish
		    drawfillbox (round (maxx * 0.15), maxy - (a * 40) - 25, round (maxx * 0.15) + players (i) -> experience div 2, maxy - (a * 40 + 20) - 20, yellow)
		    Pic.Draw (expBar, round (maxx * 0.15), maxy - (a * 40) - 42, picMerge)
		    a += 1
		end if
	    end for
	    a := 1
	    if gameTimer -> IsTimeUp then
		game -> status := GameStatus.Main
		endGame := true
		Results
	    end if
	    View.Update
	    var lastFrame : int := Time.Elapsed
	    loop
		exit when Time.Elapsed - lastFrame > gameSpeed
	    end loop
	    % Time.Delay (gameSpeed)
	end loop

    end loop
    for i : 1 .. upper (players)
	players (i) -> score := 0
	players (i) -> invulnerable := true
    end for
    startGame := false
end RunGame
