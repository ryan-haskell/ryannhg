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
## And that doesn't mean it's "easy".

Sometimes learning things can be hard. When we learn something new, the process goes much smoother if it is similar to something we already understand.

For example, if you are familiar with this piece of Java:

```java
public int[] doubleList (int[] numbers)
{
    int[] doubledNumbers = new int[numbers.count];

    for (int i = 0; i < numbers.count; i++)
    {
        doubledNumbers[i] = numbers[i] * 2;
    }

    return doubledNumbers;
}
```

Then you'll likely be able to understand this Javascript:

```javascript
function doubleList (numbers) {
    var doubledNumbers = [];

    for (var i = 0; i < numbers.length; i++) {
        doubledNumbers[i] = numbers[i] * 2;
    }

    return doubledNumbers;
}
```

Learning Javascript when you are already familiar with Java should feel __easier__!

On the other hand, when I first saw this:

```elm
doubleList =
    List.map (\\num -> num * 2)
```

It didn't translate over easily. My first language was Java, so naturally, this syntax terrified me. It looked like a programming language from another planet!

But after pushing into that feeling of insecurity and discomfort for a few months, things started to get easier. I first encountered Elm on a train ride home in September 2016.

Since that day, Elm has become my _favorite_ language.

Elm took away all the things I was familiar with, and made my programs simpler.
"""
