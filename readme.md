## How to use:
- Require selector
- Make a table of items, themselves being tables
 - They support selectable, restricted, prefix, selectedPrefix, applyFunction and removeFunction, and name. All are commented in I'm lazy for now
- Do `[nameOfVariable] = selector:new([Title on top], [table of items], [function on confirm], [*opt Custom display Function], [*opt current item in use], [*opt currently selected item], [*opt name for the config saving, DOESN'T LOAD], [*opt action for actionwheel])`
- Make an action where you want the selector to be (put the colors and the item in)
- Do [nameOfVariable]:completeAction([action in actionwheel]) or [nameOfVariable]:newAction([page])- Automatically sets up the title, the left, right and scroll wheel actions
- Pretty much done
