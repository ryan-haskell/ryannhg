module Posts exposing (Post, posts, view)

import Element exposing (..)
import Element.Font as Font
import Html
import Html.Attributes as Attr
import Markdown
import Time


type alias Post =
    { title : String
    , slug : String
    , tags : List String
    , time : Time.Posix
    , sections : List PostSection
    }


type PostSection
    = Markdown String
    | GiphyRow (List String)


view : Post -> Element msg
view post =
    textColumn [ Element.htmlAttribute (Attr.class "markdown") ]
        (List.map
            (\section ->
                case section of
                    Markdown content ->
                        List.map Element.html (Markdown.toHtml Nothing content)

                    GiphyRow urls ->
                        [ Element.html <|
                            Html.div
                                [ Attr.style "display" "flex"
                                , Attr.style "margin-top" "1rem"
                                , Attr.style "margin-left" "-1rem"
                                ]
                            <|
                                List.map
                                    (\url ->
                                        Html.div [ Attr.style "flex" "1 0 auto", Attr.style "margin-left" "1rem" ]
                                            [ Html.div
                                                [ Attr.style "width" "100%"
                                                , Attr.style "height" "0"
                                                , Attr.style "padding-bottom" "100%"
                                                , Attr.style "position" "relative"
                                                ]
                                                [ Html.iframe
                                                    [ Attr.src url
                                                    , Attr.attribute "width" "100%"
                                                    , Attr.attribute "height" "100%"
                                                    , Attr.style "position" "absolute"
                                                    , Attr.attribute "frameBorder" "0"
                                                    , Attr.class "giphy-embed"
                                                    , Attr.attribute "allowFullScreen" ""
                                                    ]
                                                    []
                                                ]
                                            ]
                                    )
                                    urls
                        ]
            )
            post.sections
            |> List.concat
        )


posts : List Post
posts =
    [ learningNewThings
    , bigThingsTinyFunctions
    , newSiteNewLife
    ]


sluggify : String -> String
sluggify =
    String.toLower
        >> String.words
        >> String.join "-"
        >> String.filter (\char -> char == '-' || Char.isAlphaNum char)


makePost : String -> List String -> Time.Posix -> List PostSection -> Post
makePost title tags timestamp sections =
    Post
        title
        (sluggify title)
        tags
        timestamp
        sections


learningNewThings : Post
learningNewThings =
    makePost
        "Learning new things."
        [ "javascript", "functional", "currying", "es6" ]
        (Time.millisToPosix 1539598225956)
        [ Markdown """
## An easy learning curve.

When I learned programming in high school, they taught me Java. If I wanted to add numbers in Java, I would make a function like this:

```java
public static int add(int a, int b) {
    return a + b;
}
```

I was fortunate enough to get an internship in highschool where I got to learn C#. A __completely different__ programming language that looked like this:

```c#
public static int Add(int a, int b) {
    return a + b;
}
```

As time went on, it turned out I really liked programming! I went to college to continue to learn more about it, and in no time I was writing C code like this:

```c
int add(int a, int b) {
    return a + b;
}
```

Junior year of college, I had a Database Systems class where I had to write Javascript to make a web UI. It turns out I enjoyed that so much I made a career out of it! Here's how I wrote `add` in JavaScript:

```js
function add(a, b) {
  return a + b;
}
```

Over the course of 6 years, I was gradually picking up the syntax of new languages, but not varying too far from what I was familiar with. This led to a really easy learning curve. I was able to build confidence that I could learn any new language!

So you could imagine the horror I faced in September 2016 when I saw this:

```elm
add a b = a + b
```

## A special bond with `for` loops

When I took my first steps in programming, for loops were this magical thing that turned this code:

```java
System.out.println("1");
System.out.println("2");
System.out.println("3");
System.out.println("4");
System.out.println("5");
```

into this code:

```java
for (int i = 1; i < 6; i++)
{
    System.out.println(i);
}
```

For loops and I had an agreement:
1. You save me from repetitive code
1. I'll memorize the order of your arguments (and remember where the semicolons go)

The for loop became my life. I was a fan:

"""
        , GiphyRow [ "https://giphy.com/embed/PF7IPn8MFrEli", "https://giphy.com/embed/4UZFlULoqdhAc" ]
        , Markdown """
I loved my experience with the for loop so much, I brought it along with me everywhere I went!

```c#
for (int i = 1; i < 6; i++)
{
    Console.WriteLine(i);
}
```

```c
for (int i = 1; i < 6; i++)
{
    printf(i);
}
```

```js
for (var i = 1; i < 6; i++) {
  console.log(i);
}
```

You can imagine how terrified I was when I found out Elm doesn't have for loops. __Ah!__

```elm
List.map print (List.range 1 5)
```

## A chance to learn something weird.

It was pretty clear that the Elm syntax was unlike anything I had seen or written before. Despite the bizarre differences in syntax, I felt drawn to the simplicity of the language. I never learned functional programming before, and I felt like this would be a great opportunity to try it out!

Here were the three things that I had to wrap my head around:

### 1. Every value is a constant.

In Elm, __`x = x + 1`__ is invalid syntax. Once you say "x is 3", you can't give it a different value later. How you change things over time is by creating new values. (Which sounds space inefficient, but since no values change, Elm can reliably __share__ memory between data structures)

After I saw this in practice, I remembered my experience learning Java in high school. Specifically, coming from experience in math and science I remember seeing this:

```java
x = x + 1;
```

and audibly saying "no." to myself. `x` can _never_ equal `x + 1`. What a bizarre thing that I got used to... Now that I have seen that expression all over the place, it doesn't weird me out anymore. But there was a time, when first learning programming, that I definitely struggled with that tiny concept.

Another benefit from this restriction is that it doesn't matter when you check the value of `x`. It will _always have the same value_. If you have ever "watched a variable" in a debugger before, you'll understand that values changing over time is a spooky and annoying thing to debug. Especially when anything in your program can change the value on you.

### 2. I don't actually need `for` loops.

If you told me three years ago that I never would use a `for` loop again, I'd laugh at you because that sounds absolutely backwards. But Elm took them away from me, and I built this entire site in the language. It turns out the `for` loop was a big source of boilerplate for me, and I didn't even notice.

Elm introduced me to `map` and `filter`, functions that I actually use in Javascript all the time now! Let's look at a code example. First in Javascript, then the same code in Elm:

```js
function double (num) {
  return num * 2;
}
function triple (num) {
  return num * 3;
}

double(10) // 20
triple(10) // 30
```

```elm
double num = num * 2
triple num = num * 3

double 10 -- 20
triple 10 -- 30
```

If I wanted to call the `double` and `triple` function on a list of numbers, I could do it with a `for` loop like this:

```js
function double (num) {
  return num * 2;
}
function triple (num) {
  return num * 3;
}

function doubleMany (nums) {
  var doubledNums = [];
  for (var i = 0; i < nums.length; i++) {
    doubledNums = double(nums[i]);
  }
  return doubledNums;
}
function tripleMany (nums) {
  var tripledNums = [];
  for (var i = 0; i < nums.length; i++) {
    tripledNums = triple(nums[i]);
  }
  return tripledNums;
}

doubleMany([ 1, 2, 3 ]) // [ 2, 4, 6 ]
tripleMany([ 1, 2, 3 ]) // [ 3, 6, 9 ]
```

In Elm, I'm not allowed to use a `for` loop, because it changes the value of `i` over time! Instead I had to learn about `List.map`.

Map is __just another function__ takes in two inputs:

1. The function to call on each item.
2. Your list of items.

```elm
double num = num * 2
triple num = num * 3

doubleMany nums = List.map double nums
tripleMany nums = List.map triple nums

doubleMany [ 1, 2, 3 ] -- [ 2, 4, 6 ]
tripleMany [ 1, 2, 3 ] -- [ 3, 6, 9 ]
```

That's a lot less code, which is neat. But more importantly than saving lines of code, I'm not rewriting several lines of boilerplate, increasing the places I could have a type and hurting the overall scannability of my code to another developer. After getting comfortable with the syntax, I realized Javascript supports this, and it's even compatible with IE 9!

```js
function double (num) {
  return num * 2;
}
function triple (num) {
  return num * 3;
}

function doubleMany (nums) {
  return nums.map(double)
}
function tripleMany (nums) {
  return nums.map(triple)
}

doubleMany([ 1, 2, 3 ]) // [ 2, 4, 6 ]
tripleMany([ 1, 2, 3 ]) // [ 3, 6, 9 ]
```

With the introduction of arrow function in ES6, all of this Javascript code becomes even more concise (and kind of looks a lot like Elm):

```js
var double = (num) => num * 2
var triple = (num) => num * 3

var doubleMany = (nums) => nums.map(double)
var tripleMany = (nums) => nums.map(triple)

doubleMany([ 1, 2, 3 ]) // [ 2, 4, 6 ]
tripleMany([ 1, 2, 3 ]) // [ 3, 6, 9 ]
```

This might be a useful language for getting lists of things and transforming it into another list of things.

__But real applications don't work like this, right?__

That brings me to the final thing I learned.


### 3. All I do is transform data.

I currently work at a digital agency where we make websites. Since learning Elm, I have come to the realization that the field I'm in is 95% turning data into other data and 5% having some effect on the world (saving to the database, rendering to the screen).

In a traditional web application, when a user requests a page like "/blog/learning-new-things", my job is to take that string and transform it into a webpage (another string). Everything I do in between (whether using .NET MVC or NodeJS Express) is on me. There was a time when I would reach for a "controller" and return a "view model" that came from an "item factory" or "settings service".

__Now I just write tiny functions that take in data, transform it, and return data.__ It's really boring.

```js
// String -> Promise BlogPost
const getBlogPost = (slug) =>
  mongoose.model('posts')
    .findOne({ slug })
    .populate('author.name')
    .lean()
    .exec()

// Nothing -> Promise SiteSettings
const getSiteSettings = () =>
  mongoose.model('site-settings')
    .findOne()
    .lean()
    .exec()

// { BlogPost, SiteSettings } -> PageData
const transform = ({ post, settings }) => ({
  navbar: settings.navbar,
  page: post
  footer: settings.footer
})

// ExpressRequest -> Promise PageData
const handler = (req) =>
  Promise.all([
    getBlogPost(req.params.slug),
    getSiteSettings()
  ])
    .then([ post, settings ] =>
      transform({ post, settings })
    )

// The Express Route
app.get('/blog/:slug', (req, res, next) =>
  handler(req)
    .then(pageData =>
      res.render('/templates/blog-detail.pug', pageData)
    )
    .catch(next)
)
```

### That's it!

If you're curious about functional programming, I definitely recommend [trying out Elm](https://elm-lang.org). I had a really positive experience with the community and the language, and both gave me a different perspective on how to code things. Thanks for reading, go learn some weird stuff!

"""
        ]


bigThingsTinyFunctions : Post
bigThingsTinyFunctions =
    makePost
        "Big things, tiny functions"
        [ "javascript", "es6", "functional" ]
        (Time.millisToPosix 1539493591688)
        [ Markdown """
## Functions can return things.

Since I gave Elm a try, I've realized that's the only thing I want my functions to do! Every now and then in JavaScript, I'll make a side effect like printing to the console, saving an item in MongoDB, or rendering something on a webpage.

But as much as possible, I try to make my JavaScript functions __take in some input__ and __return some output__.

Building big stuff is easier when you can work with one step at a time. And if those steps are tiny functions, then it's easier to confirm that things are going smoothly in an incremental way.

Let's go through a quick code challenge together: Make a function called `sluggify` that takes in an article title and returns a "slug", something we can use in the URL for that blog post.

For example:

```js
sluggify('Hello') // hello
sluggify('Hello World') // hello-world
sluggify("Elm is cool!") // elm-is-cool
```

Before I learned about `map`, `filter`, and `reduce` in JavaScript, the code I would write for this would be in one multiline function.

Now, I can write it one step at a time! Check it out:

#### Step 1: Lowercase the letters

```js
const sluggify = words =>
  words
    .toLowerCase()
```

```js
sluggify('Hello') // hello
sluggify('Hello World') // hello world
sluggify("Elm is cool!") // elm is cool!
```

#### Step 2: Remove special characters

```js
const sluggify = words =>
  words
    .toLowerCase()
    .split('')
    .filter(isLetterOrNumber)
    .join('')

const isLetterOrNumber = char => {
  const getCode = char => char.getCharCodeAt(0)
  const code = getCode(char)
  const isLetter = code >= getCode('a') && code <= getCode('z')
  const isNumber = code >= getCode('0') && code <= getCode('9')
  return isLetter || isNumber
}
```
```js
sluggify('Hello') // hello
sluggify('Hello World') // hello world
sluggify("Elm is cool!") // elm is cool
```

#### Step 3. Convert spaces to dashes

```js
const sluggify = words =>
  words
    .toLowerCase()
    .split('')
    .filter(isLetterOrNumber)
    .join('')
    .split(' ').filter(notEmpty).join('-')

const isLetterOrNumber = char => {
  const getCode = char => char.getCharCodeAt(0)
  const code = getCode(char)
  const isLetter = code >= getCode('a') && code <= getCode('z')
  const isNumber = code >= getCode('0') && code <= getCode('9')
  return isLetter || isNumber
}

const notEmpty = char => char.length > 0
```

```js
sluggify('Hello') // hello
sluggify('Hello World') // hello-world
sluggify("Elm is cool!") // elm-is-cool
```

And that's it! By breaking things down into small steps that just take input and return output, it's really easy to build bigger things!

Give map, filter, and reduce a try! They're unfamiliar at first, but they really simplify the way you write functions in your JavaScript application.
"""
        ]


newSiteNewLife : Post
newSiteNewLife =
    makePost
        "New site, new life!"
        [ "elm", "web", "project" ]
        (Time.millisToPosix 1539137597759)
        [ Markdown """
## Elm is neat.

I just built this entire site with it! Alright, I guess there's a bit of HTML, CSS, and JS too. But that's just the glue to attach the Elm to everything.

_The coolest part?_ I built all of this with almost zero CSS! Using the `elm-ui` package, I was able to layout this page in terms of normal things, like "rows" and "columns". Not "divs" and "spans".

Let's take a look at what the homepage hero looks like in Elm UI:

```elm
hero =
    column
        [ padding 32
        , Font.color white
        , Background.color blue
        ]
        [ text "ryan."
        , text "i like coding things!"
        ]
```

In Elm UI, when I want things to stack I can use a `column`. When I want things side-by-side, I use a `row`. Behind the scenes, everything compiles to the cross-browser supported CSS.

No more debugging any IE 11 CSS issues!

On top of that, it's really easy to keep track of colors used across the site because you can share variables between Elm (unlike variables across HTML, JS and CSS).

```elm
white : Color
white =
    rgb 1 1 1

blue : Color
blue =
    rgb255 0 100 175

hero : Element a
hero =
    column
        [ padding 32
        , Font.color white
        , Background.color blue
        ]
        [ text "ryan."
        , text "i like coding things!"
        ]
```

With elm, making something like `hero` a partial that can take in different kinds of inputs is super-easy too. This is because everything in Elm is already a function. We can pass in the title and caption as string inputs!


```elm
white : Color
white =
    rgb 1 1 1

blue : Color
blue =
    rgb255 0 100 175

type alias HeroContent =
    { title : String
    , caption : String
    }

hero : HeroContent -> Element a
hero content =
    column
        [ padding 32
        , Font.color white
        , Background.color blue
        ]
        [ text content.title
        , text content.caption
        ]

homepageHero : Element a
homepageHero =
    hero
        { title = "ryan."
        , caption = "i like coding things!"
        }

blogDetailHero : BlogPost -> Element a
blogDetailHero post =
    hero
        { title = post.title
        , caption = post.date
        }
```

If you want to learn more, check out [the repo here](https://github.com/mdgriffith/elm-ui)! Building websites without CSS is a great way to learn Elm's non-C-style syntax!

"""
        ]
