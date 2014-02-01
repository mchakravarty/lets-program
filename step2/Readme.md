Time with a small group: 2.5h

We started with a bit of revision:

 1. Everybody created a new file `Readme.txt`.
 2. Then, we went through all the shell commands we used so far (including launching `ghci` and compiling with `ghc`), while listing those commands with a brief description in `Readme.txt`, for later reference.
 3. We talked about there being two types of declarations in our program: (1) function definitions and (2) a datatype definition.
 4. We talked about what a function is and how functions receive data as arguments and then turn those arguments into different data or values.
 5. We talked about `Int` versus `Float`.
 6. We talked about the concept of a *pair*, specifically the `Point` type of Gloss, and how we can use pairs two combine two values into one and, then, use the functions `fst` and `snd` to take the pair apart again. (We evaluated a few expressions in `ghci` to illustrate that.)

Next, we added gravity to our little game.

 1. What is gravity? (Discussing locations, velocity, and acceleration.)
 2. How does an animation work? (Frames, frames per second, Gloss can execute functions for us once per frame to advance the game world state.)
 2. To add gravity to the game, we need to keep track of the vertical velocity of our character. We do that by extending the definition of `World` by adding a second component (of type `Float`).
 3. Adapt the data definition and all functions that operate on the `World` type until everything works again.
 4. We added a function `applyGravity` that adds the velocity to the vertical location.
 5. To see what happens, we set the initial velocity to a value other than zero. (We discussed how that gives us a constant movement without acceleration.)
 6. Then, we extended `applyGravity` to also decrease the velocity slightly (once per frame).

As a consequence of gravity, the character leaves the screen quite quickly (and we can't recover it, as we can't press the up key quickly enough). This leads to the need to constrain the character to the window boundaries (or let it wrap around — we played around with both).

 1. We started by talking about conditional expression and playing a bit with them in `ghci`.
 2. Then, we used a single conditional to constrain the vertical position in `applyGravity`.
 3. The initial idea is to test the verbatim character location against the window boundaries, but that leads to the character being cut off (as the location is in its middle). So, everybody needs to determine the size of their character (don't forget the scaling factor!) and adjust the boundary test correspondingly.
 3. This still allows us to move the character of screen with the movement keys; hence, we need more conditionals.
 4. To avoid repeating the location limiting code, we abstracted movement into two new functions `moveX` and `moveY`, which also ensure that we don't move beyond the window boundaries.
 
