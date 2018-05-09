module Pages.Thoughts.ForLoopsAreUseless exposing (content)


content : String
content =
    """
## What a controversial title.

Yea, you rite.

Back in September 2016, I read an article on a train ride home about functional programming. It claimed that there were ways to work through lists without creating a for loop.

For those of you who would like a quick visual refresher:

```javascript
var list = [ /* ... */ ]

for (var i = 0; i < list.length; i++) {
  // ...
}
```

The `for` loop is an incredibly versatile way to iterate through lists of things. There was a time before it came along that looping was very painful. I'm sure that leads to a lot of emotional attachment to it, so I feel a little bad about my hurtful article title.

There's no doubt that if someone were to take it away from me, I would become a completely useless programmer.

Since first wrapping my head around it in high-school, in Java, I have since grown so used to it's syntax.

And I completely forgot about all the tedious details:

1. Initialize a temporary iterator.
1. Remember the semicolon!
1. Set a stop condition next.
1. Remember the semicolon!
1. Put some code to update the iterator at the end.
1. Don't use a semicolon!

The `for` loop looks like a one-liner, but it actually has three lines of code in there! It was the most subtle piece of boilerplate, because I never considered it to be boilerplate before.


### So let's never use it again.

At least for Javascript, I can easily convince you that this code:

```javascript
var numbers = [ 1, 2, 3 ]

for (var i = 0; i < numbers.length; i++) {
  var number = numbers[i]
  console.log(number)
}
```

can and should __always__ be replaced with this:

```javascript
var numbers = [ 1, 2, 3 ]

numbers.forEach(function (number) {
  console.log(number)
})
```

Both will result in the same outcome.

Except the `forEach` approach doesn't make you create temporary numbers, and fetch the element on your own with it.

Instead, it is a function on any list that takes in one input: the function you want to call for each element. A much simpler design, right?


### But it gets _simpler_!

With ES6 arrow functions, using `forEach` is even more appealing, because making simple functions has a very minimal syntax.

You can rewrite the `forEach` example like this:

```javascript
var numbers = [ 1, 2, 3 ]

numbers.forEach(number => console.log(number))
```

The beauty of having a less clutter, is it's much clearer to see what our code is doing.


### "Hey, what if I _need_ that index though?"

The `forEach` function also comes with the index, as it's second parameter. So if you want to use the index, you still can!

It looks like this:

```javascript
var numbers = [ 1, 2, 3 ]

numbers.forEach(function (number, index) {
  console.log(index + ': ' + number)
})
```

Hopefully, that information will empower you to never need a for loop again.


## Map, Filter, and Reduce

After I found out I don't need to write out a for loop, it made me think about the common ways I had been using for loops and lists before:

- Returning a new list
- Keeping elements matching a condition
- Aggregating info from a list

### Map: Returning a new list.

If I had a list of numbers and wanted to return their doubles and triples, my `for` loop code would look like this:

```javascript
var doubleAll = (numbers) => {
  var doubledNumbers = []
  for (var i = 0; i < numbers.length; i++) {
    doubledNumbers[i] = numbers[i] * 2
  }
  return doubledNumbers
}
```

```javascript
var tripleAll = (numbers) => {
  var tripledNumbers = []
  for (var i = 0; i < numbers.length; i++) {
    tripledNumbers[i] = numbers[i] * 3
  }
  return tripledNumbers
}
```

```javascript
doubleAll([ 1, 2, 3 ])
// [ 2, 4, 6 ]

tripleAll([ 1, 2, 3 ])
// [ 3, 6, 9 ]
```

Both functions do the same thing:

1. Create a new list
2. Add a transformed version of each element
3. Return that list

The only difference is how we are transforming the element.

If you have a list, and you want to return a new list with transformed elements, just use the `map` function:

```javascript
var doubleAll = (numbers) =>
  numbers.map(num => num * 2)
```

```javascript
var tripleAll = (numbers) =>
  numbers.map(num => num * 3)
```

```javascript
doubleAll([ 1, 2, 3 ])
// [ 2, 4, 6 ]

tripleAll([ 1, 2, 3 ])
// [ 3, 6, 9 ]
```

With `map`, it's really easy to see what makes your different pieces of code unique. That `for` loop boilerplate can really add up quick, and take away from the meaning of what you're trying to express (either to a coworker, or even future you)!

This makes it clearer to identify and reuse pieces of the code later on:

```javascript
var double = num => num * 2
var doubleAll = list => list.map(double)

var triple = num => num * 3
var tripleleAll = list => list.map(triple)
```

Neat right?


### Filter: Keep elements matching a condition.

Another common use case I had was filtering out things I don't want to keep. Just like `map`, there is a `filter` function.

That function turns this `for` loop code:

```javascript
var keepOdds = (nums) => {
  var odds = []
  for (var i = 0; i < nums.length; i++) {
    if (nums[i] % 2 === 1) {
      odds.push(nums[i])
    }
  }
  return odds
}
```

Into this:

```javascript
var keepOdds = (nums) =>
  nums.filter(num => num % 2 === 1)
```


### The most imporant part!

The most important reason... actually, wait. My _favorite_ reason* for using `map` and `filter` is that they __require__ me to use Simple functions.

Simple functions just take in their inputs and spit out an output. No side-effects like writing to a database or saving a file. Just data-in, data-out.

That makes it super easy to __compose__ things together:

```javascript
var people = [
  { name: 'Ryan', color: 'blue' },
  { name: 'Alexa', color: 'pink' },
  { name: 'Jimmy', color: 'blue' },
  { name: 'Rene', color: 'green' }
]
```

Imagine I needed to write code that needed to get me the names of all people with the favorite color 'blue'.

Since `map` and `filter` return their output, I can use it as input to another `map` or `filter`!

```javascript
var likesBlue = (person) =>
  person.color === 'blue'

var getName = (person) =>
  person.name

return people
  .filter(likesBlue)
  .map(getName)
```

```javascript
[ 'Ryan', 'Jimmy' ]
```

Amazing stuff, my dudes! I can build more complicated workflows by chaining together simple functions!


### One more thing to show you!

This last one is called `reduce`, and it's a little different than the rest.

I use `reduce` when I want to "reduce a list down to a simple value".

Here's an example:

```javascript
var numbers = [ 10, 20, 50 ]
var total = numbers.reduce(
  (totalSoFar, num) => totalSoFar + num,
  0
)

total // 80
```

`reduce` takes in two inputs:
1. The function that gets called for each element, and returns the latest value.
2. The initial value to start with.

Let's step through the example with `total`. The function is first called with the initial value (0) and the first element (10)

```javascript
(0, 10) => 0 + 10
// Returns 10, passed in as `totalSoFar` next time

(10, 20) => 10 + 20
// Returns 30, passed in as `totalSoFar` next time

(30, 50) => 30 + 50
// Returns 80, no elements left, thats the result!
```

Reduce can also be used to reduce a list of lists to a single list:

```javascript
var lists = [
  [ 1, 2, 3 ],
  [ 4, 5 ],
  [ 6, 7, 8, 9, 10 ]
]
var result = lists.reduce(
  (bigList, list) => bigList.concat(list),
  []
)

result // [ 1, 2, 3, ... 9, 10 ]
```

And here's how that works:

```javascript
([], [ 1, 2, 3 ]) => [].concat([ 1, 2, 3 ])
// Returns [1..3], passed in next time

([ 1..3 ], [ 4, 5 ]) => [ 1, 2, 3 ].concat([ 4, 5 ])
// Returns [ 1..5 ], passed in next time

([ 1..5 ], [ 6..10 ]) => [1..5].concat([ 6..10 ])
// Returns [1..10], no elements left, thats the result!
```

## That's it!

Hopefully these alternatives to the for loop will help make working with lists in Javascript a lot nicer for you!

Since I found out about these three functions a few years ago, I haven't used a for-loop since.

__And I don't miss it.__

"""
