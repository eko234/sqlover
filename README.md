# SQLOVER

This plugin uses `usql` to interact with databases using specific queries or your current main selection, so you should install it, I just do:
```sh
go install github.com/xo/usql@latest
```

## Usage

First initialize your dsns:

```sh
sqloverinit  [<db_name>=<db_dsn>]...
```

Then pick a db, the command will provide you suggestion based on the dsns you loaded:
```sh
sqloverpickdb <db_name>
```

Query as you wish
```sh
sqloverdoq SELECT 69 FROM DUAL
```

Or leve it empty to use your selection as the command input
```sh
sqloverdoq
```

## Suggested mappings

I usually just do:
``` sh
plug "eko234/sqlover" config %{
  sqloverinit  mylocaldb=oracle://mydbname:mypassword@localhost:32770/ORCLCDB.localdomain
  alias global pdb sqloverpickdb
  map global user q ': sqloverdoq '
}
```

and just hit enter or specify the query depending on what im doing, I also developped `geppeto` for kakoune,
which is a gpt interactive client that uses fifos, the ideas of querying and prompting with selections could
be quite interesting to combine, so give it a shot.
