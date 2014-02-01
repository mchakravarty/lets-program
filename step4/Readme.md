Time with a small group: 2.5h

We did a little revision:

 * We discussed if-then-else expressions again and put a description into the `Readme.txt` file.

Next we talked about how hardcoding values (such as the size of the game window) in multiple places makes it hard to change those values.

 1. We defined `width` and `height` as top-level constants and changed the rest of the code to use those.
 2. We talked again about the difference of `Int` and `Float` and why we need to use `round` in the window size argument to `play`. (I let them see the error first, before talking about this and also explored this a bit in GHCi.)
 3. We defined `spriteWidth` and `spriteHeight` as top-level constants computed from the result of calling gloss-game's `boundingBox` on the (scaled) sprite. (Again, GHCi is good to evaluate some expressions involving the new function, to get a feel for it.)

In a game, we want to be able to keep pressing the movement keys ('a' and 'd') to keep the character moving. However, in the previous implementation, we had to repeatedly press to continue advancing. The solution, in Gloss' event handling, is to explicitly keep track of pressed keys in the game world state:

 1. Introduce a third component in `World` that keeps track of a list of pressed keys (of type `[Char]`).
 2. Change `handle` such that it tracks `Down` and `Up` events for all `Char` keys, and use them to add and remove keys from the list of pressed keys. (NB: In my exprience, Gloss can lose events. It is bad if that happens with an `Up` event. Hence, it would be better to `filter` characters out when an `Up` event occurs — instead just using `delete`. However, I didn't want to introduce the complexity of `filter` just because of this.)
 3. Add a new function `applyMovement` (that's also being put into the list of stepper functions passed to `play`).
 4. The function `applyMovement` tests for the movement keys and calls `moveX` as needed.
