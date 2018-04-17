module Pages.Thoughts.ElmIsSimple exposing (view)

import Element exposing (..)
import Markdown
import Types


view : Device -> Types.ThoughtMeta -> Element msg
view device thought =
    paragraph []
        [ Element.html <| Markdown.toHtml [] content
        ]


content : String
content =
    """
## What is Elm?

According to its [website](http://elm-lang.org), Elm is a "delightful language for building reliable webapps". Just like Microsoft's _Typescript_, Elm compiles down to javascript, so you can run it in the browser. And just like Typescript, it does that so you can __prevent bugs from making it into production__.

In fact, it's so good at it, NoRedInk has been using it for over two years, and still has [no runtime exceptions](https://www.youtube.com/watch?v=XsNk5aOpqUc#t=4m30s)! So that's kind of neat.


## Why learn Elm?

Even though I'm not currently using it at work, Elm introduced me to a lot of great ideas. Every day, I apply those ideas to make my Javascript simpler and more bug-free!

This post will outline a few concepts that make my life as a JavaScript developer a bit nicer! Here's are some of a my favorite ideas that I can use in Javascript:

1. __Simpler Variables__ - (no more changing stuff)
1. __Simpler Functions__ - (no more global side-effects)
1. __Simpler Iteration__ - (no more for loops)


## Making Simpler Variables

In Javascript, there are 3 ways to declare a value:

```javascript
var number = 1
let number = 1
const number = 1
```

Elm has one way to declare a value:

```elm
number = 1
```

If you're a Javascript beginner you might ask:

__"Which way should I do it?"__

I think that's a fair question, and your answer will be different depending on who you ask:

- "Use `var`, because browser support!"
- "Use `let`, because block scope!"
- "Use `const`, because mutation is evil!"

On the other hand, if you're using Elm, you already know the answer:

- The __only__ way.

In Elm, every value is a constant. That makes tracking a value really easy!

```elm
number = 3
-- ...
-- (number is 3)
-- ...
-- (number is 3)
-- ...
-- (number is 3)
```

as opposed to this:

```javascript
var number = 3
// ...
// (number is 150)
// ...
// (number is "ryan")
// ...
// (number is undefined)
```

To understand why number is `undefined` by the end of your program, you need to know every operation that happened to it on it's journey through your application.

That makes debugging a real pain, because you have to set breakpoints, and step-by-step walk through your program.

In Elm, the only way I can create change is through functions that take in your initial value, and return a new one!


## Making Simpler Functions

In Elm, the only kind of function you need are called "pure functions". That word sounds a bit elitist, but basically it just means that you can trust the function to do a few things:

- Never modify an input
- Only return a value
- Always return the same output for the same input.
- Never create a side effect

Let's go through a few examples of functions that break these rules:

#### Modifies it's input:

```javascript
var ryan = { name: 'Ryan' }

var rename = function (person) {
    person.name = 'Poophead'
    return person
}

rename(ryan) // { name: 'Poopyhead' }
```

#### Doesn't return a value

```javascript
var person = { name: 'Ryan' }

var rename = function (person) {
    person.name = 'Poophead'
}

rename(ryan) // undefined
```

#### Returns a different value for the same input:

```javascript
var number = 1

var add = function (otherNumber) {
    return number + otherNumber
}

add(1) // 2
number = 12
add(1) // 13
```

#### Creates a side effect:

```javascript
var add = function (a, b) {
    database.dropEverything()
    return a + b
}

add(1, 2) // Error: Could not connect to MongoDB
```

If we wanted to update `number` from the last example, we would do that my running it through a few pure functions. Here are some pure functions in Elm:

```elm
number = 3

multiply first second =
    first * second

addToNumber otherNumber =
    number + otherNumber
```

If we call:

```elm
multiply 10 2
```

We would get the result of `10 * 2`, which is always `20`.

If we call:

```elm
addToNumber 100
```

We would get `100 + 3`, which is always `103`.

Notice we can still access `number`, even though it's not an input to the function. That's because all values in Elm are constants, so we can't call `number = 12` later, like we could with Javascript's `var number`.


"""
