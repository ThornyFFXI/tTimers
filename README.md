# tTimers
Displays time remaining on buffs and debuffs you've cast, as well as the recast timers for your spells and abilities.

## Commands

**/tt**
Opens configuration menu.  This allows you to change themes, alter behavior, etc.

**/tt reposition**
Forces all timer panels visible with max allowed timers, and allows them to be dragged around using the blue handles.

**/tt lock**
Ends reposition mode.

**/tt custom [required: Label] [required: Duration]**
This creates a custom timer with the label and duration specified.  Duration can be specified in full or partial minutes, seconds, or hours by using suffixes s, m, or h.  Example usage:
**/tt custom "PH Repop" 5.5m**
**/tt custom "NM Window" 1h**
**/tt custom "Reminder" 30s**
If no suffix is used, the timer will use the number as seconds.

## Other
You can shift-click any timer to make it immediately disappear.  You can ctrl-click any timer to make it immediately disappear and block that ability/buff/debuff from generating new timers in the future.  A future update will allow unblocking through GUI, but currently unblocking must be done by unloading the addon, editing the config file, and reloading the addon.  So, try not to block anything you don't want to keep blocked.