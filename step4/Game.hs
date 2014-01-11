-- Compile this with 'ghc -o Game Game.hs' and run it with './Game'.

import Data.List
import Graphics.Gloss.Game

-- Window size
width  = 600
height = 400

-- A sprite representing our character
slimeSprite = bmp "Slime.bmp"

slimeWidth  = fst (snd (boundingBox (scale 0.5 0.5 slimeSprite)))
slimeHeight = snd (snd (boundingBox (scale 0.5 0.5 slimeSprite)))

-- Our game world consists of both the location and the vertical velocity of our character as well as a list of all
-- currently pressed keys.
data World = World Point Float [Char]

-- This starts our gamein a window with a give size, running at 30 frames per second.
--
-- The argument 'World (0, 0) 0' is the initial state of our game world, where our character is at the centre of the
-- window and has no velocity. 
--
main
  = play (InWindow "Slime is here!" (round width, round height) (50, 50)) white 30 (World (0, 0) 0 []) draw handle 
         [applyMovement, applyVelocity, applyGravity]

-- To draw a frame, we position the character sprite at the location as determined by the current state of the world.
-- We shrink the sprite by 50%.
draw (World (x, y) _v _keys) = translate x y (scale 0.5 0.5 slimeSprite)

-- Pressing the spacebar makes the character jump. All character keys are tracked in the world state.
handle (EventKey (Char ch) Down _ _)             (World (x, y) v keys) = World (x, y) v (ch : keys)
handle (EventKey (Char ch) Up   _ _)             (World (x, y) v keys) = World (x, y) v (delete ch keys)
handle (EventKey (SpecialKey KeySpace) Down _ _) (World (x, y) v keys) = World (x, y) 8 keys
handle event world = world        -- don't change the world in case of any other events

-- Move horizontally, but box the character in at the window boundaries.
moveX (x, y) offset = if x + offset < (-width / 2) + slimeWidth / 2
                      then ((-width / 2) + slimeWidth /  2, y)
                      else if x + offset > width / 2 - slimeWidth /  2
                      then (width / 2 - slimeWidth /  2, y)
                      else (x + offset, y)

-- Move vertically, but box the character in at the window boundaries.
moveY (x, y) offset = if y + offset < (-height / 2) + slimeHeight / 2
                      then (x, (-height / 2) + slimeHeight /  2)
                      else if y + offset > height / 2 - slimeHeight /  2
                      then (x, height / 2 - slimeHeight /  2)
                      else (x, y + offset)

-- A pressed 'a' and 'd' key moves the character a fixed distance left or right.
applyMovement _time (World (x, y) v keys) = if elem 'a' keys
                                            then World (moveX (x, y) (-10)) v keys
                                            else if elem 'd' keys
                                            then World (moveX (x, y) 10) v keys
                                            else World (x, y) v keys

-- Each frame, add the veclocity to the verticial position (y-axis). (A negative velocity corresponds to a downward movement.)
applyVelocity _time (World (x, y) v keys) = World (moveY (x, y) v) v keys

-- We simulate gravity by decrease the velocity slightly on each frame, corresponding to a downward acceleration.
--
-- We bounce of the bottom edge by reverting the velocity (with a damping factor).
--
applyGravity _time (World (x, y) v keys) = World (x, y) (if y <= (-200) + slimeHeight / 2 then v * (-0.5) else v - 0.5) keys
