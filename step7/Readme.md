Time with a small group: 2.5h

We spent quite some time getting some children who couldn't make the last two sessions up to speed. To make that interesting for the others, we started by revising and further exploring the record syntax for the `World` datatype:

 1. Make sure everybody uses record syntax for `World`.
 2. Talk about the advantages of naming the fields and explore both projections as well as updates using record syntax in GHCi (at the example of the `World` datatype). (I on purpose omitted pattern matching with record syntax. It would have been to much.)
 3. Then, everybody (with some help) rewrites their code to use record updates and record projections instead of pattern matching on the `World` constructor and reconstructing an entire `World` value in the various event handler and stepper functions.

Extend the scene by a low platform:

 1. Draw a platform sprite.
 2. Add it to the scene (it's static).
 3. Extend the movement and gravity code to check for collisions of the character with the platform and handle them approrpiately.
