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

-- Sprite for the power up coin
powerUpSprite = scale 0.5 0.5 (bmp "PowerUp.bmp")

powerUpWidth  = fst (snd (boundingBox powerUpSprite))
powerUpHeight = snd (snd (boundingBox powerUpSprite))

-- A sprite of our character after powerup
superSlimeSprite = scale 0.5 0.5 (bmp "SuperSlime.bmp")

-- Our game world consists of all the variable aspects of the game state as well as a list of all currently pressed keys.
data World = World {
               spritePosition  :: Point,
               spriteVelocity  :: Float,
               spriteAnimation :: Animation,
               powerUpPosition :: Point,
               keys            :: [Char]
             }

-- This starts our gamein a window with a give size, running at 30 frames per second.
--
-- The argument 'World (0, 0) 0' is the initial state of our game world, where our character is at the centre of the
-- window and has no velocity. 
--
main
  = playInScene (InWindow "Slime is here!" (round width, round height) (50, 50)) white 30 
                (World (0, 0) 0 noAnimation (100, 100) []) level handle 
                [applyMovement, applyVelocity, applyGravity, checkForPowerUp]

-- Description of a level as a scene. Scenes depend on the state of the world, which means their rendering changes as the
-- world changes. Here, we have the character, where both its location and animation depend on the world state.
level = scenes [translating spritePosition  (animating spriteAnimation slimeSprite),
                translating powerUpPosition (picture powerUpSprite)]

-- Pressing the spacebar makes the character jump. All character keys are tracked in the world state.
handle now (EventKey (Char ch) Down _ _)             (World (x, y) v anim puPos keys) = World (x, y) v anim puPos (ch : keys)
handle now (EventKey (Char ch) Up   _ _)             (World (x, y) v anim puPos keys) = World (x, y) v anim puPos (delete ch keys)
handle now (EventKey (SpecialKey KeySpace) Down _ _) (World (x, y) v anim puPos keys) = 
  World (x, y) 8 (animation [slimeSprite2, slimeSprite3, slimeSprite4] 0.1 now) puPos keys
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
applyMovement _now _time (World (x, y) v anim puPos keys) 
  = if elem 'a' keys
    then World (moveX (x, y) (-10)) v anim puPos keys
    else if elem 'd' keys
    then World (moveX (x, y) 10) v anim puPos keys
    else World (x, y) v anim puPos keys
     
-- Each frame, add the veclocity to the verticial position (y-axis). (A negative velocity corresponds to a downward movement.)
applyVelocity _now _time (World (x, y) v anim puPos keys) = World (moveY (x, y) v) v anim puPos keys

-- We simulate gravity by decrease the velocity slightly on each frame, corresponding to a downward acceleration.
--
-- We bounce of the bottom edge by reverting the velocity (with a damping factor).
--
applyGravity _now _time (World (x, y) v anim puPos keys) = 
  World (x, y) (if y <= (-200) + slimeHeight / 2 then v * (-0.5) else v - 0.5) anim puPos keys

-- Check whether the character and the power sprite intersect. Then, change the character sprite for 3s to a super version.
checkForPowerUp now _time (World (x, y) v anim (pux, puy) keys)
  = if abs (x - pux) < slimeWidth / 2 + powerUpWidth / 2 && abs (y - puy) < slimeHeight / 2 + powerUpHeight / 2
    then World (x, y) v (animation [superSlimeSprite] 3 now) (-pux, -puy) keys
    else World (x, y) v anim (pux, puy) keys