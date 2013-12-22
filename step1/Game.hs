-- Compile this with 'ghc -o Game Game.hs' and run it with './Game'.

import Graphics.Gloss.Game

-- A sprite representing our character
slimeSprite = bmp "Slime.bmp"

-- Our game world consists purely of the location of our character.
data World = World Point

-- This starts our gamein a window with a give size, running at 30 frames per second.
--
-- The argument 'World (0, 0)' is the initial state of our game world, where our character is at the centre of the
-- window. 
--
main = play (InWindow "Slime is here!" (600, 400) (50, 50)) white 30 (World (0, 0)) draw handle []

-- To draw a frame, we position the character sprite at the location as determined by the current state of the world.
-- We shrink the sprite by 50%.
draw (World (x, y)) = translate x y (scale 0.5 0.5 slimeSprite)

-- Whenever any of the keys 'a', 'd', 'w', or 's' have been pushed down, move our character in the corresponding
-- direction.
handle (EventKey (Char 'a') Down _ _) (World (x, y)) = World (x - 10, y)
handle (EventKey (Char 'd') Down _ _) (World (x, y)) = World (x + 10, y)
handle (EventKey (Char 'w') Down _ _) (World (x, y)) = World (x, y + 10)
handle (EventKey (Char 's') Down _ _) (World (x, y)) = World (x, y - 10)
handle event world = world        -- don't change the world in case of any other events
