module Elements
    exposing
        ( hero
        , heroWithLink
        , navbar
        , footer
        , container
        , blogListing
        )

import Element exposing (..)
import Element.Attributes exposing (..)
import Styles exposing (El)
import Types


navbar : El msg
navbar =
    header Styles.Header [] <|
        container
            [ row Styles.None
                [ width fill
                , verticalCenter
                , paddingXY 0 12
                ]
                [ link "#/" <|
                    el Styles.Brand [ paddingRight 0 ] (text "ryan haskell-glatz.")
                , row Styles.None
                    [ width fill
                    , spacing 12
                    , alignRight
                    ]
                    [ link "#/about" <|
                        el Styles.Link [] (text "about.")
                    , link "#/projects" <|
                        el Styles.Link [] (text "projects.")
                    , link "#/thoughts" <|
                        el Styles.Link [] (text "thoughts.")
                    ]
                ]
            ]


footer : El msg
footer =
    Element.footer Styles.Footer [] <|
        container
            [ row Styles.None
                [ width fill
                , verticalCenter
                , paddingTop 24
                , paddingBottom 32
                ]
                [ el Styles.Copyright [ paddingRight 0 ] (text "Ryan Haskell-Glatz, 2018")
                , row Styles.None
                    [ width fill
                    , spacing 12
                    , alignRight
                    ]
                    [ newTab "https://www.github.com/ryannhg" <|
                        el Styles.Link [] (text "github")
                    , newTab "https://www.twitter.com/Ryan_NHG" <|
                        el Styles.Link [] (text "twitter")
                    ]
                ]
            ]


hero_ : List (El msg) -> SomeHero a -> El msg
hero_ otherStuff { header, subheader } =
    column Styles.Hero
        [ alignLeft, width fill, paddingXY 0 128 ]
        [ container
            ([ h1 Styles.HeroHeader
                []
                (text header)
             , h2 Styles.HeroSubheader
                [ padding 2 ]
                (text subheader)
             ]
                ++ otherStuff
            )
        ]


type alias SomeHero a =
    { a
        | header : String
        , subheader : String
    }


type alias HeroStuff =
    { header : String
    , subheader : String
    }


type alias HeroWithLinkStuff =
    { header : String
    , subheader : String
    , cta :
        { link : String
        , label : String
        }
    }


hero : HeroStuff -> El msg
hero =
    hero_ []


heroWithLink : HeroWithLinkStuff -> El msg
heroWithLink model =
    hero_
        [ row Styles.None
            [ paddingTop 24 ]
            [ link model.cta.link <|
                el Styles.Button [ paddingXY 16 8 ] (text model.cta.label)
            ]
        ]
        model


container : List (El msg) -> El msg
container innerContent =
    row Styles.None
        [ width fill, center, paddingXY 24 0 ]
        [ column Styles.None
            [ width fill, maxWidth (px 780) ]
            innerContent
        ]


blogListing : { title : String, posts : List Types.Post } -> El msg
blogListing { title, posts } =
    el Styles.Section [ paddingXY 0 48 ] <|
        container
            [ el Styles.SectionHeader [] (text title)
            , column Styles.None
                [ paddingTop 12 ]
                (List.map
                    (\{ title, url, date } ->
                        column Styles.Listing
                            [ paddingXY 0 20 ]
                            [ link url <|
                                el Styles.ListingHeader [] (text title)
                            , el Styles.ListingSubheader [ paddingTop 6 ] (text date)
                            ]
                    )
                    posts
                )
            ]
