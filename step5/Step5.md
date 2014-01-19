Time with a small group: 2.5h

We spent some time on a little revision bringing a group member who missed the last two sessions up to speed.

We talked about the concept of scenes as parameterised pictures and how we can use that to implement our moving character differently and also animate it. In a first step, we rewrote the program to use scenes without changing the behaviour.

 1. Replace the use of the `play` functions with `playInScene`.
 2. Replace the `draw` functions with a `level` definition (that for now omits the animation).
 3. Implement a projection function `spritePosition` that extracts just the position of the character from the `World`.
 3. The event handler and the stepper functions need to be extended to receive an additional first argument (being the current time since invoking `playInScene`.

In the next step, we add the capability of being able to animate the character.

 1. Extend `level` to use `animating` (so we can animate the character).
 2. To this end, we also need to add a forth component, of type `Animation` to the `World`, which stores the current animation state for that animation.
 3. We extend the initial `World` argument to `playInScene` to start with `noAnimation` for the extra component.
 4. Implement a projection function `spriteAnimation` to extract the new component from the `World`.

Finally, everybody drew three more sprites as variations on their character sprite to form an animation sequence.

 1. Define the new sprites in top-level bindings.
 2. In the event handling case for spacebar (implementing jumping), we also start an animation consisting of the three new sprites.
