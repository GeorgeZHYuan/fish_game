class Timer
    export Init, Tick, Pause, Resume, DrawTime, IsTimeUp, timeLeft

    var gameTime : int
    var missedTime : int
    var startTime : int
    var stoppedTime : int
    var paused : boolean
    var font : int
    var IsTimeUp : boolean
    var timeLeft : int
    proc Pause
	paused := true
	stoppedTime := Time.Elapsed
    end Pause

    proc Resume
	paused := false
	missedTime += Time.Elapsed - stoppedTime
    end Resume

    proc Init (_gameTime, _font : int)
	IsTimeUp := false
	missedTime := Time.Elapsed
	startTime := Time.Elapsed
	gameTime := _gameTime * 1000 + 1000
	font := _font
	Pause
    end Init

    proc Tick
	if paused = true then
	    stoppedTime := Time.Elapsed
	end if
    end Tick

    proc DrawTime
	var watchTime : string
	timeLeft := (gameTime - Time.Elapsed + missedTime) div 1000
	if timeLeft < 0 then
	    timeLeft := 0
	end if
	if timeLeft > 3600 then
	    watchTime := intstr (timeLeft div 3600) + "h " + intstr (timeLeft rem 3600)
	elsif timeLeft > 60 then
	    watchTime := intstr (timeLeft div 60) + "m "
	    if timeLeft rem 60 > 0 then
		watchTime += intstr (timeLeft rem 60)
	    end if
	else
	    watchTime := intstr (timeLeft)
	end if
	if timeLeft <= 0 then
	    IsTimeUp := true
	end if
	Draw.Text ("Time: " + watchTime, maxx div 2 - 80, maxy - 40, font, white)
    end DrawTime
end Timer
