class AiFish
    import Collider, NormalBody, Position, Speed, Distance, EatingSound
    export DrawFish, fishBody, Init, level, points, Update, var alive, mouthRange, location, mouth, Eat, SpawnRate

    var alive : boolean := false
    var collider : Collider
    var fishBody : NormalBody
    var level : int
    var location : Position
    var facingRight : boolean := true
    var mouth : Position
    var mouthRange : int
    var points : int
    var reactionZone : int
    mouth.x := 1
    mouth.y := 1
    var speed : Speed
    var mouthPading : Position
    var spawnChance : int

    proc Init (pic : NormalBody, _level, experiencePoints, slowSpeed, topSpeed, xPading, yPading, mouthPadding, _spawnChance : int)
	level := _level
	points := round (experiencePoints * 1.20)
	fishBody := pic
	speed.maxSpeed := topSpeed
	speed.minSpeed := slowSpeed
	speed.speed := slowSpeed
	location.x := 1
	location.y := 1
	mouthRange := Pic.Height (fishBody.pic) div 5 - mouthPadding
	mouthPading.x := xPading
	mouthPading.y := yPading
	spawnChance := _spawnChance
    end Init

    proc Spawn

	var y : int
	randint (y, 0, spawnChance)
	if y = 0 then
	    var x : int
	    randint (x, 0, 1)
	    if x = 0 then
		facingRight := true
		fishBody.pic := fishBody.picRight
		location.x := 0 - Pic.Width (fishBody.pic)
	    else
		facingRight := false
		fishBody.pic := fishBody.picLeft
		location.x := maxx
	    end if
	    randint (location.y, 0, maxy - Pic.Height (fishBody.pic))
	    randint (speed.speed, speed.minSpeed, speed.maxSpeed)
	    alive := true
	end if
	% randint (location.x, 0, maxx - Pic.Width (fishBody.pic))
    end Spawn

    proc Direction
	if facingRight = true then
	    mouth.x := location.x + Pic.Width (fishBody.pic) - Pic.Width (fishBody.pic) div 8 + mouthPading.x
	    fishBody.pic := fishBody.picRight
	    speed.speed := abs (speed.speed)
	else
	    mouth.x := location.x + Pic.Width (fishBody.pic) div 8 - mouthPading.x
	    fishBody.pic := fishBody.picLeft
	    speed.speed := -1 * abs (speed.speed)
	end if
    end Direction

    proc Roam
	location.x += speed.speed
	if facingRight = true then
	    if location.x > maxx then
		alive := false
	    end if
	else
	    if location.x < 0 - Pic.Width (fishBody.pic) then
		alive := false
	    end if
	end if
    end Roam

    proc Eat (aiFish : array 1 .. * of ^AiFish)
	if alive then
	    for i : 1 .. upper (aiFish)
		var center : Position
		var distance : int
		var contactRange : int
		if level >= aiFish (i) -> level and aiFish (i) -> alive then
		    center.x := aiFish (i) -> location.x + (Pic.Width (aiFish (i) -> fishBody.pic) div 2)
		    center.y := aiFish (i) -> location.y + (Pic.Height (aiFish (i) -> fishBody.pic) div 2)
		    contactRange := Pic.Height (aiFish (i) -> fishBody.pic) div 2 + mouthRange
		    if Distance (mouth.x, mouth.y, center.x, center.y) < contactRange and aiFish (i) -> alive then
			aiFish (i) -> alive := false
		    end if
		end if
	    end for
	end if
    end Eat

    proc Update
	mouth.y := location.y + Pic.Height (fishBody.pic) div 2 + mouthPading.y
	if alive = false then
	    location.x := -1000
	    location.y := -1000
	    Spawn
	else
	    Direction
	    Roam
	end if
    end Update

    proc SpawnRate (one, two, three : int)
	var experience : array 1 .. 3 of int
	experience (1) := one
	experience (2) := two
	experience (3) := three
	var pScore : int := -1
	for i : 1 .. 3
	    if experience (i) > pScore then
		pScore := experience (i)
	    end if
	end for
	if pScore >= 240 then
	    spawnChance := 100
	elsif pScore >= 140 then
	    spawnChance := 500
	elsif pScore >= 60 then
	    spawnChance := 1000
	else
	    spawnChance := 2000
	end if
    end SpawnRate

    proc DrawFish
	if alive = true then
	    Pic.Draw (fishBody.pic, location.x, location.y, picMerge)
	end if
	% drawfilloval (mouth.x, mouth.y, mouthRange, mouthRange, black) % draws mouth contact point
    end DrawFish
end AiFish
