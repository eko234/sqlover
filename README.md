# SQLOVER

This plugin uses `usql` to interact with databases using specific queries or your current main selection, so you should install it, I just do:
```sh
go install github.com/xo/usql@latest
```

## Usage

First initialize your dsns

```sh
sqloverinit  [<db_name>=<db_dsn>]...
```

Then pick a db, the command will provide you suggestion based on the dsns you loaded
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

I just have this configured like this
``` sh
plug "eko234/sqlover" config %{
  sqloverinit  mylocaldb=oracle://mydbname:mypassword@localhost:32770/ORCLCDB.localdomain
  alias global pdb sqloverpickdb
  map global user q ': sqloverdoq '
}
```

## Configuration

As I said, this thing uses usql under the hood, if you want to pass any additional flags you can modify the `sqlovercmdoptions` to do things like removing the json formatting, as this plugin sets it to `'--json'` by default, or even get also the stderr to the sqlover buffer so you know when and why things go wrong

``` sh
  set global sqlovercmdoptions '--csv 2>&1'
```

## Shameless self promotion

I also developped `geppeto` for kakoune, which is a chat gpt interactive client that uses fifos, the ideas of querying and prompting with selections could be quite interesting to combine, so give it a shot.
