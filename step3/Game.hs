-- Compile this with 'ghc -o Game Game.hs' and run it with './Game'.

import Graphics.Gloss.Game

-- A sprite representing our character
slimeSprite = bmp "Slime.bmp"

slimeWidth  = 104 * 0.5     -- we draw it with scale 0.5
slimeHeight = 104 * 0.5

-- Our game world consists of both the location and the vertical velocity of our character.
data World = World Point Float

-- This starts our gamein a window with a give size, running at 30 frames per second.
--
-- The argument 'World (0, 0) 0' is the initial state of our game world, where our character is at the centre of the
-- window and has no velocity. 
--
main
  = play (InWindow "Slime is here!" (600, 400) (50, 50)) white 30 (World (0, 0) 0) draw handle 
         [applyVelocity, applyGravity]

-- To draw a frame, we position the character sprite at the location as determined by the current state of the world.
-- We shrink the sprite by 50%.
draw (World (x, y) _v) = translate x y (scale 0.5 0.5 slimeSprite)

-- Pressing 'a' and 'd' moves the character a fixed distance left or right. Pressing the spacebar makes it jump.
handle (EventKey (Char 'a') Down _ _)            (World (x, y) v) = World (moveX (x, y) (-10)) v
handle (EventKey (Char 'd') Down _ _)            (World (x, y) v) = World (moveX (x, y) 10) v
handle (EventKey (SpecialKey KeySpace) Down _ _) (World (x, y) v) = World (x, y) 8
handle event world = world        -- don't change the world in case of any other events

-- Move horizontally, but box the character in at the window boundaries.
moveX (x, y) offset = if x + offset < (-300) + slimeWidth / 2
                      then ((-300) + slimeWidth /  2, y)
                      else if x + offset > 300 - slimeWidth /  2
                      then (300 - slimeWidth /  2, y)
                      else (x + offset, y)

-- Move vertically, but box the character in at the window boundaries.
moveY (x, y) offset = if y + offset < (-200) + slimeHeight / 2
                      then (x, (-200) + slimeHeight /  2)
                      else if y + offset > 200 - slimeHeight /  2
                      then (x, 200 - slimeHeight /  2)
                      else (x, y + offset)

-- Each frame, add the veclocity to the verticial position (y-axis). (A negative velocity corresponds to a downward movement.)
applyVelocity _time (World (x, y) v) = World (moveY (x, y) v) v

-- We simulate gravity by decrease the velocity slightly on each frame, corresponding to a downward acceleration.
--
-- We bounce of the bottom edge by reverting the velocity (with a damping factor).
--
applyGravity _time (World (x, y) v) = World (x, y) (if y <= (-200) + slimeHeight / 2 then v * (-0.5) else v - 0.5)
