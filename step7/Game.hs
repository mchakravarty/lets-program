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

-- A sprite for a platform to jump onto
platformSprite = scale 0.5 0.5 (bmp "Platform.bmp")

platformPosition = (-200, -150)     -- It doesn't change, so it doesn't need to go into the 'World'

platformWidth  = fst (snd (boundingBox platformSprite))
platformHeight = snd (snd (boundingBox platformSprite))


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
                translating powerUpPosition (picture powerUpSprite),
                picture (translate (fst platformPosition) (snd platformPosition) platformSprite) ]

-- Pressing the spacebar makes the character jump. All character keys are tracked in the world state.
handle now (EventKey (Char ch) Down _ _)             world = world { keys = ch : keys world }
handle now (EventKey (Char ch) Up   _ _)             world = world { keys = delete ch (keys world) }
handle now (EventKey (SpecialKey KeySpace) Down _ _) world = 
  world { spriteVelocity  = 8,
          spriteAnimation = animation [slimeSprite2, slimeSprite3, slimeSprite4] 0.1 now }
handle now event world = world        -- don't change the world in case of any other events

-- Move horizontally, but box the character in at the window boundaries.
moveX (x, y) offset = if x + offset < (-width / 2) + slimeWidth / 2
                      then ((-width / 2) + slimeWidth /  2, y)
                      else if x + offset > width / 2 - slimeWidth /  2
                      then (width / 2 - slimeWidth /  2, y)
                      else (x + offset, y)

-- Move vertically, but box the character in at the window boundaries. Also check for collision with the platform,
-- which will also have to stop the character.
moveY (x, y) offset = if y + offset < (-height / 2) + slimeHeight / 2
                      then (x, (-height / 2) + slimeHeight /  2)
                      else if y + offset > height / 2 - slimeHeight /  2
                      then (x, height / 2 - slimeHeight /  2)
                      else if y + offset < snd platformPosition + slimeHeight / 2 + platformHeight / 2 
                              && x + slimeWidth / 2 > fst platformPosition - platformWidth / 2
                              && x - slimeWidth / 2 < fst platformPosition + platformWidth / 2
                      then (x, snd platformPosition + slimeHeight / 2 + platformHeight / 2)
                      else (x, y + offset)

-- A pressed 'a' and 'd' key moves the character a fixed distance left or right.
applyMovement _now _time world
  = if elem 'a' (keys world)
    then world { spritePosition = moveX (spritePosition world) (-10) }
    else if elem 'd' (keys world)
    then world { spritePosition = moveX (spritePosition world) 10 }
    else world
     
-- Each frame, add the veclocity to the verticial position (y-axis). (A negative velocity corresponds to a downward movement.)
applyVelocity _now _time world = world { spritePosition = moveY (spritePosition world) (spriteVelocity world) }

-- We simulate gravity by decrease the velocity slightly on each frame, corresponding to a downward acceleration.
--
-- We bounce of the bottom edge by reverting the velocity (with a damping factor).
--
applyGravity _now _time world
  = let (x, y) = spritePosition world
        v      = spriteVelocity world
    in
    world { spriteVelocity = if onTheFloor world || onThePlatform world then v * (-0.5) else v - 0.5 }

-- Check whether the character is on the floor.
onTheFloor world = snd (spritePosition world) <= (-height / 2) + slimeHeight / 2

-- Check whether the character is on the playform.
onThePlatform world = snd (spritePosition world) <= snd platformPosition + slimeHeight / 2 + platformHeight / 2
                      && fst (spritePosition world) + slimeWidth / 2 > fst platformPosition - platformWidth / 2
                      && fst (spritePosition world) - slimeWidth / 2 < fst platformPosition + platformWidth / 2

-- Check whether the character and the power sprite intersect. Then, change the character sprite for 3s to a super version.
checkForPowerUp now _time world
  = let (x,   y)   = spritePosition  world
        (pux, puy) = powerUpPosition world
    in
    if abs (x - pux) < slimeWidth / 2 + powerUpWidth / 2 && abs (y - puy) < slimeHeight / 2 + powerUpHeight / 2
    then world { spriteAnimation = animation [superSlimeSprite] 3 now, powerUpPosition = (-pux, -puy) }
    else world
