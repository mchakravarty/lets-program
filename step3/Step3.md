Time with a small group: 2.5h

We spend quite a bit of time on revision (some children missed the second session):

 1. We talked about how there are three components to programs: (1) functions, (2) data values, and (3) types. (We also put something about that into the `Readme.txt` file).
 2. We went through the implementation of gravity and bounding the chracter movement at window boundaries again. We mostly did that by looking at the code of the children who were at the second session and, as far as possible, those children explaining how it worked (with prompts and help if they weren't sure anymore).
 3. Step by step, the children who missed the second session added those features to their code as well.
 4. We again looked at conditional expressions in GHCi again. (They and pattern matching are the most important comtrol structures t understand at the moment.)

Then, we added jumping to the game:

 1. We talked about how we can realise jumping now that we track vertical velocity in the world.
 2. We removed the cases in `handle` for up and down movement and added a case for a pressed down spacebar to jump. (Air jumps permitted for simplicity for the moment.)

Finally, we added bouncing:

 1. Instead of just stopping at the lower edge of the window, we talked about how we could make the character bounce.
 2. It is tricky to avoid jittering when the character is on the "ground" in the original setup where `applyGravity` applies the current velocity to the vertical position and also increases the velocity to account for the gravitational force.
 3. We solve that by splitting the function `applyGravity` into `applyVelocity` (movement) and `applyGravity` (account for gravitational force). This split enables us to reset the velocity to 0 when the character should stand still on the ground.
