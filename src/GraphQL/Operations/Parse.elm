module GraphQL.Operations.Parse exposing (..)

{-| This code was originally borrowed from <https://github.com/lukewestby/elm-graphql-parser>
-}

import Char
import GraphQL.Operations.AST as AST
import Parser exposing (..)
import Set exposing (Set)


multiOr : List (a -> Bool) -> a -> Bool
multiOr conds val =
    List.foldl
        (\next memo ->
            if memo then
                memo

            else
                next val
        )
        False
        conds


escapables : Set Char
escapables =
    Set.fromList
        [ '\\'
        , '/'
        , 'b'
        , 'f'
        , 'n'
        , 'r'
        , 't'
        ]


keywords : Set String
keywords =
    Set.fromList
        [ "query"
        , "subscription"
        , "mutation"
        , "on"
        , "fragment"
        , "true"
        , "false"
        , "null"
        ]


ignoreChars : Set Char
ignoreChars =
    Set.fromList
        [ '\t'
        , '\n'
        , chars.cr

        -- , '\xFEFF'
        , ' '
        , ','
        ]


chars : { cr : Char }
chars =
    { cr =
        Char.fromCode 0x0D
    }


ws : Parser ()
ws =
    Parser.chompWhile
        (\c ->
            Set.member c ignoreChars
        )


name : Parser AST.Name
name =
    Parser.variable
        { start = multiOr [ Char.isLower, Char.isUpper, (==) '_' ]
        , inner = multiOr [ Char.isLower, Char.isUpper, Char.isDigit, (==) '_' ]
        , reserved = keywords
        }
        |> Parser.map AST.Name


variable : Parser AST.Variable
variable =
    succeed AST.Variable
        |. symbol "$"
        |= name


boolValue : Parser AST.Value
boolValue =
    Parser.oneOf
        [ Parser.map (\_ -> AST.Boolean True) (keyword "true")
        , Parser.map (\_ -> AST.Boolean False) (keyword "false")
        ]


floatValue : Parser AST.Value
floatValue =
    Parser.map AST.Decimal Parser.float


intValue : Parser AST.Value
intValue =
    Parser.map AST.Integer Parser.int


stringValue : Parser AST.Value
stringValue =
    succeed AST.Str
        |. symbol "\""
        |= Parser.getChompedString (Parser.chompIf (\c -> c /= chars.cr && c /= '\n' && c /= '"'))
        |. symbol "\""


enumValue : Parser AST.Value
enumValue =
    Parser.map AST.Enum name


listValue : (() -> Parser AST.Value) -> Parser AST.Value
listValue valueParser =
    Parser.map AST.ListValue <|
        Parser.sequence
            { start = "["
            , separator = ""
            , end = "]"
            , spaces = ws
            , item = lazy valueParser
            , trailing = Parser.Optional
            }


kvp_ : (() -> Parser AST.Value) -> Parser ( AST.Name, AST.Value )
kvp_ valueParser =
    succeed Tuple.pair
        |= name
        |. ws
        |. symbol ":"
        |. ws
        |= lazy valueParser


objectValue : (() -> Parser AST.Value) -> Parser AST.Value
objectValue valueParser =
    Parser.map AST.Object <|
        Parser.sequence
            { start = "{"
            , separator = ""
            , end = "}"
            , spaces = ws
            , item = kvp_ valueParser
            , trailing = Parser.Optional
            }


nullValue : Parser AST.Value
nullValue =
    Parser.map (\_ -> AST.Null) <| keyword "null"


value : Parser AST.Value
value =
    oneOf
        [ boolValue
        , intValue
        , floatValue
        , stringValue
        , enumValue
        , Parser.map AST.Var variable
        , listValue (\() -> value)
        , objectValue (\() -> value)
        ]


kvp : Parser ( AST.Name, AST.Value )
kvp =
    kvp_ (\() -> value)


loopItems contentParser items =
    ifProgress List.reverse <|
        Parser.oneOf
            [ Parser.map (\d -> d :: items) contentParser
            , Parser.succeed items
                |. comment
            , Parser.map (\_ -> items) ws
            ]


selectionSet : Parser (List AST.Selection)
selectionSet =
    Parser.succeed identity
        |. Parser.symbol "{"
        |. ws
        |= Parser.loop []
            (loopItems
                (Parser.lazy
                    (\() ->
                        Parser.oneOf
                            [ Parser.map AST.Field field_
                            , inlineOrSpread_
                            ]
                    )
                )
            )
        |. ws
        |. Parser.symbol "}"


comment : Parser ()
comment =
    Parser.succeed ()
        |. Parser.symbol "#"
        |. Parser.chompWhile
            (\c ->
                c /= '\n'
            )
        |. Parser.symbol "\n"


inlineOrSpread_ : Parser AST.Selection
inlineOrSpread_ =
    Parser.succeed identity
        |. Parser.symbol "..."
        |. ws
        |= Parser.oneOf
            [ Parser.map AST.InlineFragmentSelection <|
                Parser.succeed AST.InlineFragment
                    |. Parser.keyword "on"
                    |. ws
                    |= name
                    |. ws
                    |= directives
                    |. ws
                    |= selectionSet
            , Parser.map AST.FragmentSpreadSelection <|
                Parser.succeed AST.FragmentSpread
                    |= name
                    |. ws
                    |= directives
            ]


field_ : Parser AST.FieldDetails
field_ =
    Parser.succeed
        (\( alias_, foundName ) args dirs sels ->
            { alias_ = alias_
            , name = foundName
            , arguments = args
            , directives = dirs
            , selection = sels
            }
        )
        |= aliasedName
        |. ws
        |= argumentsOpt
        |. ws
        |= directives
        |. ws
        |= Parser.oneOf
            [ selectionSet
            , Parser.succeed []
            ]


aliasedName : Parser ( Maybe AST.Name, AST.Name )
aliasedName =
    Parser.succeed
        (\nameOrAlias maybeActualName ->
            case maybeActualName of
                Nothing ->
                    ( Nothing, nameOrAlias )

                Just actualName ->
                    ( Just nameOrAlias, actualName )
        )
        |= name
        |= Parser.oneOf
            [ Parser.succeed Just
                |. Parser.chompIf (\c -> c == ':')
                |. ws
                |= name
            , Parser.succeed Nothing
            ]


argument : Parser AST.Argument
argument =
    Parser.map (\( key, v ) -> AST.Argument key v) kvp


arguments : Parser (List AST.Argument)
arguments =
    Parser.sequence
        { start = "("
        , separator = ""
        , end = ")"
        , spaces = ws
        , item = argument
        , trailing = Parser.Optional
        }


argumentsOpt : Parser (List AST.Argument)
argumentsOpt =
    oneOf
        [ arguments
        , Parser.succeed []
        ]


directive : Parser AST.Directive
directive =
    succeed AST.Directive
        |. symbol "@"
        |. ws
        |= name
        |. ws
        |= argumentsOpt


directives : Parser (List AST.Directive)
directives =
    Parser.loop []
        directivesHelper


directivesHelper :
    List AST.Directive
    -> Parser (Parser.Step (List AST.Directive) (List AST.Directive))
directivesHelper dirs =
    ifProgress List.reverse <|
        Parser.oneOf
            [ Parser.map (\d -> d :: dirs) directive
            , Parser.map (\_ -> dirs) ws
            ]



-- selectionSetOpt_ : Parser (List AST.Selection)
-- selectionSetOpt_ =
--     Parser.oneOf
--         [ selectionSet
--         , Parser.succeed []
--         ]


fragment : Parser AST.FragmentDetails
fragment =
    succeed AST.FragmentDetails
        |. keyword "fragment"
        |. ws
        |= name
        |. ws
        |. keyword "on"
        |. ws
        |= name
        |. ws
        |= directives
        |. ws
        |= selectionSet


nameOpt : Parser (Maybe AST.Name)
nameOpt =
    oneOf
        [ Parser.map Just name
        , succeed Nothing
        ]


operationType : Parser AST.OperationType
operationType =
    oneOf
        [ Parser.map (\_ -> AST.Query) <| keyword "query"
        , Parser.map (\_ -> AST.Mutation) <| keyword "mutation"
        ]


defaultValue : Parser (Maybe AST.Value)
defaultValue =
    oneOf
        [ Parser.map Just <|
            succeed identity
                |. symbol "="
                |. ws
                |= value
        , succeed Nothing
        ]


listType : (() -> Parser AST.Type) -> Parser AST.Type
listType typeParser =
    succeed identity
        |. symbol "["
        |. ws
        |= lazy typeParser
        |. ws
        |. symbol "]"


type_ : Parser AST.Type
type_ =
    Parser.succeed
        (\base isRequired ->
            if isRequired then
                base

            else
                AST.Nullable base
        )
        |= Parser.oneOf
            [ Parser.map AST.Type_ name
            , Parser.map AST.List_ (listType (\_ -> type_))
            ]
        |= Parser.oneOf
            [ Parser.succeed True
                |. Parser.symbol "!"
            , Parser.succeed False
            ]


variableDefinition : Parser AST.VariableDefinition
variableDefinition =
    succeed AST.VariableDefinition
        |= variable
        |. ws
        |. symbol ":"
        |. ws
        |= type_
        |. ws
        |= defaultValue


variableDefinitions : Parser (List AST.VariableDefinition)
variableDefinitions =
    oneOf
        [ Parser.sequence
            { start = "("
            , separator = ""
            , end = ")"
            , spaces = ws
            , item = variableDefinition
            , trailing = Parser.Optional
            }
        , Parser.succeed []
        ]


operation : Parser AST.OperationDetails
operation =
    Parser.succeed AST.OperationDetails
        |= operationType
        |. ws
        |= nameOpt
        |. ws
        |= variableDefinitions
        |. ws
        |= directives
        |. ws
        |= selectionSet


definition : Parser AST.Definition
definition =
    Parser.oneOf
        [ Parser.map AST.Fragment fragment
        , Parser.map AST.Operation operation
        ]


loopDefinitions defs =
    ifProgress List.reverse <|
        Parser.oneOf
            [ Parser.map (\d -> d :: defs) definition
            , Parser.map (\_ -> defs) ws
            ]


document : Parser AST.Document
document =
    Parser.succeed AST.Document
        |. ws
        |= Parser.loop []
            loopDefinitions
        |. ws
        |. Parser.end


parse : String -> Result (List Parser.DeadEnd) AST.Document
parse doc =
    Parser.run document doc


ifProgress : (step -> done) -> Parser step -> Parser (Step step done)
ifProgress onSucceed parser =
    Parser.succeed
        (\oldOffset parsed newOffset ->
            if oldOffset == newOffset then
                Done (onSucceed parsed)

            else
                Loop parsed
        )
        |= Parser.getOffset
        |= parser
        |= Parser.getOffset


errorToString : List Parser.DeadEnd -> String
errorToString deadEnds =
    String.concat (List.intersperse "; " (List.map deadEndToString deadEnds))


deadEndToString : Parser.DeadEnd -> String
deadEndToString deadend =
    problemToString deadend.problem ++ " at row " ++ String.fromInt deadend.row ++ ", col " ++ String.fromInt deadend.col


problemToString : Parser.Problem -> String
problemToString p =
    case p of
        Expecting s ->
            "expecting '" ++ s ++ "'"

        ExpectingInt ->
            "expecting int"

        ExpectingHex ->
            "expecting hex"

        ExpectingOctal ->
            "expecting octal"

        ExpectingBinary ->
            "expecting binary"

        ExpectingFloat ->
            "expecting float"

        ExpectingNumber ->
            "expecting number"

        ExpectingVariable ->
            "expecting variable"

        ExpectingSymbol s ->
            "expecting symbol '" ++ s ++ "'"

        ExpectingKeyword s ->
            "expecting keyword '" ++ s ++ "'"

        ExpectingEnd ->
            "expecting end"

        UnexpectedChar ->
            "unexpected char"

        Problem s ->
            "problem " ++ s

        BadRepeat ->
            "bad repeat"
