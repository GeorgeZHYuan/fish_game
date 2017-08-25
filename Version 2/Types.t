const playerEvolutions : int := 5

type Position :
    record
	x : int
	y : int
    end record

type GrowingBody :
    record
	pic : int
	picRight : array 1 .. playerEvolutions of int
	picLeft : array 1 .. playerEvolutions of int
    end record

type NormalBody :
    record
	pic : int
	picRight : int
	picLeft : int
    end record

type Collider :
    record
	botX : int
	botY : int
	topX : int
	topY : int
    end record


type ControllerType : enum (red, blue, yellow)

type Speed :
    record
	speed : int
	minSpeed : int
	maxSpeed : int
    end record
    
type HighscoreEntry :
    record
	score : int
	name : string        
    end record
    
% type PlayerType :
%     record
%         controller : ControllerType
%         mouth : Mouth
%         location : Position
%         playerBody : GrowingBody
%         collider : int
%         speed : int
%         score : int
%         level : int
%         deathTime : int
%         alive : boolean
%         exist : boolean
%     end record

% type AiType :
%     record
%         level : int
%         location : Position
%         mouth : Mouth
%         aiFishBody : NormalBody
%         collider : int
%         speed : int
%         alive : boolean
%     end record

type GameStatus : enum (Main, Play, Highscore, Quit)
type PauseButtonFunction : enum (Resume, MainMenu, Restart)
