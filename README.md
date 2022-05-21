# PomoSimple

A simple pomodoro timer for released on Google Play Store. Made by Armin Jaganjac.

Known limitations: This app will work perfectly fine as long as the display is awake. As soon as the devices goes into sleep mode the timer will stop working.

Possible workaround for a future version: Use system time and notifications.


What have I learned while writing this app?
I learned what state is the hard way. I lost 5 whole days (and my mind) figuring out why the three sliders all moved at the same time when you just try to move one of them. Turns out I didn't understand what state is and that each slider needs to have its own state. I kinda hacked around that issue instead of just implementing proper state management. My next project will definetly include either Provider or Riverpod package.
