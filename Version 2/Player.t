class Player
    import ControllerType, Position, GrowingBody, Input, Mouse, AiFish, gameTimer, gameTime, halo, Distance, EatingSound
    export var playerBody, var controller, var score, var level,
	var alive, var exist, var experience, var invulnerable, var eatItems, playerNumber, Init, DrawFish, Update, Eat, ReInit

    var controller : ControllerType
    var mouth : Position
    var location : Position
    var playerBody : GrowingBody
    var collider : int
    var experience : int := 0
    var speed : int := 10
    var score : int := 0
    var level : int
    var mouthRange : int := 1
    var deathTime : int := 1
    var alive : boolean := true
    var exist : boolean := false
    var playerNumber : int
    var respawnTime : int
    var invulnerable : boolean := true
    var invulnerableTime : int
    var maxExp : int := 320
    var deadZone := 3
    var moveLocation : Position
    var eatItems : array 1 .. 3 of int := init (0, 0, 0)
    var timesDead : int := 0

    proc Init (_playerNumber : int, locationX, locationY : int)
	playerNumber := _playerNumber
	level := 1
	score := 0
	respawnTime := 4
	location.x := locationX
	location.y := locationY
	moveLocation := location
	mouth.x := location.x + (Pic.Width (playerBody.pic))
	mouth.y := location.y + (Pic.Width (playerBody.pic) div 2)
	invulnerableTime := gameTime
	alive := true
    end Init

    proc ReInit
	for i : 1 .. upper (eatItems)
	    eatItems (i) := 0
	end for
	timesDead := 0
	experience := 0
	playerBody.pic := playerBody.picRight (1)
    end ReInit

    proc Move
	var getKey : array char of boolean
	if alive and exist then
	    Input.KeyDown (getKey)
	    if playerNumber = 1 then
		exist := true
		if getKey ('w') then
		    moveLocation.y += speed * 2
		end if
		if getKey ('s') then
		    moveLocation.y -= speed * 2
		end if
		if getKey ('d') then
		    moveLocation.x += speed * 2
		end if
		if getKey ('a') then
		    moveLocation.x -= speed * 2
		end if
	    elsif playerNumber = 2 then
		if getKey (KEY_UP_ARROW) then
		    moveLocation.y += speed * 2
		end if
		if getKey (KEY_DOWN_ARROW) then
		    moveLocation.y -= speed * 2
		end if
		if getKey (KEY_RIGHT_ARROW) then
		    moveLocation.x += speed * 2
		end if
		if getKey (KEY_LEFT_ARROW) then
		    moveLocation.x -= speed * 2
		end if
	    elsif playerNumber = 3 then
		var button : int
		Mouse.Where (moveLocation.x, moveLocation.y, button)
	    end if

	    var centerPoint : Position
	    centerPoint.x := location.x + Pic.Width (playerBody.pic) div 2
	    centerPoint.y := location.y + Pic.Height (playerBody.pic) div 2
	    var distance : int := Distance (moveLocation.x, moveLocation.y, location.x, location.y)
	    if distance > deadZone then
		if moveLocation.x > location.x then
		    playerBody.pic := playerBody.picRight (level)
		    location.x += round (abs (moveLocation.x - location.x) * speed / distance)
		end if
		if moveLocation.x < location.x then
		    playerBody.pic := playerBody.picLeft (level)
		    location.x -= round (abs (moveLocation.x - location.x) * speed / distance)
		end if
		if moveLocation.y > location.y then

		    location.y += round (abs (moveLocation.y - location.y) * speed / distance)
		end if
		if moveLocation.y < location.y then
		    location.y -= round (abs (moveLocation.y - location.y) * speed / distance)
		end if
	    end if
	    if moveLocation.x >= centerPoint.x + Pic.Width (playerBody.pic) then
		moveLocation.x := centerPoint.x + Pic.Width (playerBody.pic)
	    end if
	    if moveLocation.x < centerPoint.x - Pic.Width (playerBody.pic) then
		moveLocation.x := centerPoint.x - Pic.Width (playerBody.pic)
	    end if
	    if moveLocation.y >= centerPoint.y + Pic.Height (playerBody.pic) then
		moveLocation.y := centerPoint.y + Pic.Height (playerBody.pic)
	    end if
	    if moveLocation.y < centerPoint.y - Pic.Height (playerBody.pic) then
		moveLocation.y := centerPoint.y - Pic.Height (playerBody.pic)
	    end if
	    if moveLocation.x >= maxx - Pic.Width (playerBody.pic) then
		moveLocation.x := maxx - Pic.Width (playerBody.pic)
	    end if
	    if moveLocation.x < 0 then
		moveLocation.x := 0
	    end if
	    if moveLocation.y >= maxy - Pic.Height (playerBody.pic) then
		moveLocation.y := maxy - Pic.Height (playerBody.pic)
	    end if
	    if moveLocation.y < 0 then
		moveLocation.y := 0
	    end if
	    mouth.y := location.y + (Pic.Height (playerBody.pic) div 2)
	    if playerBody.pic = playerBody.picRight (level) then
		mouth.x := location.x + (Pic.Width (playerBody.pic)) - (Pic.Width (playerBody.pic) div 8)
	    else
		mouth.x := location.x + Pic.Width (playerBody.pic) div 8
	    end if
	end if
    end Move

    proc Respawn
	if deathTime - gameTimer -> timeLeft >= respawnTime then
	    invulnerable := true
	    invulnerableTime := gameTimer -> timeLeft
	    playerBody.pic := playerBody.picRight (level)
	    alive := true
	end if
    end Respawn

    proc Invulnerable
	if invulnerableTime - gameTimer -> timeLeft >= 4 then
	    invulnerable := false
	end if
    end Invulnerable

    proc LevelUp
	if experience >= 240 then
	    level := 5
	elsif experience >= 140 then
	    level := 4
	elsif experience >= 60 then
	    level := 3
	elsif experience >= 20 then
	    level := 2
	else
	    level := 1
	end if
    end LevelUp

    proc Eat (aiFish : array 1 .. * of ^AiFish)
	if exist and alive then
	    for i : 1 .. upper (aiFish)
		var center : Position
		var distance : int
		var contactRange : int
		if level >= aiFish (i) -> level then
		    center.x := aiFish (i) -> location.x + (Pic.Width (aiFish (i) -> fishBody.pic) div 2)
		    center.y := aiFish (i) -> location.y + (Pic.Height (aiFish (i) -> fishBody.pic) div 2)
		    distance := round (sqrt ((mouth.x - center.x) ** 2 + (mouth.y - center.y) ** 2))
		    contactRange := Pic.Width (aiFish (i) -> fishBody.pic) div 2 + mouthRange
		    if Distance (mouth.x, mouth.y, center.x, center.y) < contactRange and aiFish (i) -> alive then
			aiFish (i) -> alive := false
			experience += aiFish (i) -> points
			eatItems (round ((aiFish (i) -> level + 1) / 2)) += 1
			fork EatingSound
		    end if
		else
		    center.x := location.x + (Pic.Width (playerBody.pic) div 2)
		    center.y := location.y + (Pic.Height (playerBody.pic) div 2)
		    distance := round (sqrt ((aiFish (i) -> mouth.x - center.x) ** 2 + (aiFish (i) -> mouth.y - center.y) ** 2))
		    contactRange := round (Pic.Height (playerBody.pic) * 0.7 + aiFish (i) -> mouthRange)
		    if Distance (aiFish (i) -> mouth.x, aiFish (i) -> mouth.y, center.x, center.y) < contactRange and aiFish (i) -> alive then
			if aiFish (i) -> level > level and invulnerable = false and aiFish (i) -> alive then
			    experience := round (experience * 0.75)
			    alive := false
			    deathTime := gameTimer -> timeLeft
			    timesDead += 1
			    exit
			end if
		    end if
		end if
	    end for
	end if
    end Eat

    proc Update
	mouthRange := Pic.Height (playerBody.pic) div 4
	if exist then
	    if experience > maxExp then
		experience := maxExp
	    end if
	    LevelUp
	    Move
	    if alive = false then
		Respawn
	    end if
	    if invulnerable then
		Pic.Draw (halo, location.x + Pic.Width (playerBody.pic) div 2 - Pic.Width (halo) div 2, location.y + Pic.Height (playerBody.pic), picMerge)
		Invulnerable
	    end if
	end if
    end Update

    proc DrawFish
	% drawfilloval (mouth.x, mouth.y, mouthRange, mouthRange, black) % draws mouth contact point
	% drawfilloval (moveLocation.x, moveLocation.y, 5, 5, black) % draws mouth contact point
	if alive then
	    Pic.Draw (playerBody.pic, location.x, location.y, picMerge)
	end if

    end DrawFish
end Player
