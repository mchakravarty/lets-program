-- Compile this with 'ghc -o Game Game.hs' and run it with './Game'.

import Data.List
import Graphics.Gloss.Game

-- Window size
width  = 600
height = 400

-- A sprite representing our character
slimeSprite = scale 0.5 0.5 (bmp "Slime.bmp")

slimeWidth  = fst (snd (boundingBox slimeSprite))
slimeHeight = snd (snd (boundingBox slimeSprite))

-- Additional sprites for a simple animation
slimeSprite2 = scale 0.5 0.5 (bmp "Slime2.bmp")
slimeSprite3 = scale 0.5 0.5 (bmp "Slime3.bmp")
slimeSprite4 = scale 0.5 0.5 (bmp "Slime4.bmp")


-- Our game world consists of both the location and the vertical velocity of our character, the state of the character
-- animation as well as a list of all currently pressed keys.
data World = World Point Float Animation [Char]

-- This starts our gamein a window with a give size, running at 30 frames per second.
--
-- The argument 'World (0, 0) 0' is the initial state of our game world, where our character is at the centre of the
-- window and has no velocity. 
--
main
  = playInScene (InWindow "Slime is here!" (round width, round height) (50, 50)) white 30 
                (World (0, 0) 0 noAnimation []) level handle 
                [applyMovement, applyVelocity, applyGravity]

-- Description of a level as a scene. Scenes depend on the state of the world, which means their rendering changes as the
-- world changes. Here, we have the character, where both its location and animation depend on the world state.
level = translating spritePosition (animating spriteAnimation slimeSprite)

-- Extract the character position from the world.
spritePosition (World (x, y) v anim keys) = (x, y)

-- Extract the character animation from the world.
spriteAnimation (World (x, y) v anim keys) = anim

-- Pressing the spacebar makes the character jump. All character keys are tracked in the world state.
handle now (EventKey (Char ch) Down _ _)             (World (x, y) v anim keys) = World (x, y) v anim (ch : keys)
handle now (EventKey (Char ch) Up   _ _)             (World (x, y) v anim keys) = World (x, y) v anim (delete ch keys)
handle now (EventKey (SpecialKey KeySpace) Down _ _) (World (x, y) v anim keys) = 
  World (x, y) 8 (animation [slimeSprite2, slimeSprite3, slimeSprite4] 0.1 now) keys
handle now event world = world        -- don't change the world in case of any other events

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
applyMovement _now _time (World (x, y) v anim keys) = if elem 'a' keys
                                                      then World (moveX (x, y) (-10)) v anim keys
                                                      else if elem 'd' keys
                                                      then World (moveX (x, y) 10) v anim keys
                                                      else World (x, y) v anim keys
     
-- Each frame, add the veclocity to the verticial position (y-axis). (A negative velocity corresponds to a downward movement.)
applyVelocity _now _time (World (x, y) v anim keys) = World (moveY (x, y) v) v anim keys

-- We simulate gravity by decrease the velocity slightly on each frame, corresponding to a downward acceleration.
--
-- We bounce of the bottom edge by reverting the velocity (with a damping factor).
--
applyGravity _now _time (World (x, y) v anim keys) = 
  World (x, y) (if y <= (-200) + slimeHeight / 2 then v * (-0.5) else v - 0.5) anim keys
