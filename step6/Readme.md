Time with a small group: 2.5h

In this session, we added a power up coin:

 1. We started by extending the scene in `level` with a power up coin and drawing a coin sprite. Initially, the coin was at a fixed static position.
 2. We talked about how to check for whether the character touches the power up coin.
 3. Then, we added a new stepper function `checkForPowerUp` that checks for the intersection between the coin and the character.
 4. When the character touches the power up, it temporarily changes into a supercharged version (for which everybody drew a new sprite).

To be able to change the position of the coin, we need to extend the `World` and, to add that to the scene, also need a new function that projects the coin position out of a `World` state. We talked about how the growing `World` data type becomes unwieldy. This discussion led to introducing the Haskell record syntax (for now only for projections, not yet for updates).

 1. Change the definition of `World` to use record syntax.
 2. Add a new field `powerUpPosition` for the position of the power up coin.
 3. Adapt the rest of the program to that change of `World`.

Finally, we use the extended `World` to change the coin position whenever it is used to power up the character:

 1. Edit the scene to use `powerUpPosition` for the coin position.
 2. In `checkForPowerUp`, alter the coin position by changing the sign of the x and y component.
