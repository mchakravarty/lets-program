Time with a small group: 3h including setting up Haskell etc.

We went through some preparatory steps:

 1. Explain the basics of using a command shell: `pwd`, `ls`, `cd`, `mkdir`, `touch`
 2. Launch `ghci`, do some simple arithmetic, lists, and some basic list operations.
 3. Introduce the idea of variables with some simple `let` expression.
 4. Introduce the idea of functions by defining simple functions in a `let` expression and using them.

Then, create a file `Game.hs` and put the code for "Hello World!" into it:

> main = putStrLn "Hello World!"

Compile it:

> ghc -o Game Game.hs

Run it:

> ./Game

Then, the main part was to develop the version of `Game.hs` in this directory. This went as follows:

 1. Everybody created a sprite for their character with [BigPixel](http://github.com/mchakravarty/BigPixel).
 2. Then, they got shown the boilerplate to import `Graphics.Gloss.Game` and invoke the `play` function, doing nothing but calling `draw` (with the world value just being `()`). The function `draw` in turn just shows the sprite.
 3. Talk about modifying Gloss pictures with `scale` and `translate` (maybe mention `rotate` as well).
 4. Introduce the `World` datatype, initialise it in `play`, and use the character location in `draw`. Talk about how changing the initial value changes the drawn picture.
 5. Add the event handler code to move the character.
