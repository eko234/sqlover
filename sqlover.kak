declare-option str-to-str-map sqloverdsns
nop %{
  We should somehow like hash these bois up there,
  but I will use this for local dev only, so if you
  find an ergonomic way to do it, just send a pr
}

declare-option str sqloverfifo /tmp/sqlover_fifo
declare-option bool sqloverstarted false
declare-option str sqloverselecteddsn
declare-option str sqloverselecteddb
declare-option str sqloverscurrentquery

define-command opensqlover -override %{
  try %{
    buffer sqlover
  } catch %{
    eval -try-client tools %{
      edit -scratch  sqlover
    }
  }
}

define-command sqloverinit -override -params 1.. %{
  evaluate-commands %sh{
    if [ ! -p "$kak_opt_sqloverfifo" ]; then
        mkfifo "$kak_opt_sqloverfifo"
    fi
    perl -le 'print "set-option -add global sqloverdsns \"$_\"" foreach @ARGV;' "$@"
    echo set-option global sqloverstarted true
  }
}

define-command sqloverpickdb -shell-script-candidates %{
  echo "$kak_quoted_opt_sqloverdsns" | xargs perl -le 'print foreach @ARGV' | sed 's/=.*$//g'
} -override -params 1 %{
  evaluate-commands %sh{
    sel=$(echo "$kak_quoted_opt_sqloverdsns" | xargs perl -le 'print foreach @ARGV' | grep "^$1=" | sed 's/^.*=//g')
    echo "set-option global sqloverselecteddsn '$sel'"
    echo "set-option global sqloverselecteddb $1"
  }
}

define-command sqloverdoq -override -params 0.. %{
  evaluate-commands -draft %sh{
    [ "$kak_opt_sqloverstarted" = false ] && echo fail dang it bobby, you need to init this trash && exit 1
    [ -z "$kak_opt_sqloverselecteddsn" ] && echo fail dang it bobby, you need to select a db to work && exit 1
    printf "opensqlover\n"
    if [ $(($(printf %s "${kak_selection}" | wc -m))) -gt 1 ]; then
      echo "set-option global sqloverscurrentquery $kak_quoted_selection"
      printf "execute-keys 'gjo<esc>! usql -c \"%%opt{sqloverscurrentquery}\" %%opt{sqloverselecteddsn} --json <a-!><ret>jd'\n"
    else
      echo "set-option global sqloverscurrentquery \"$@\""
      printf "execute-keys 'gjo<esc>! usql -c \"%%opt{sqloverscurrentquery}\" %%opt{sqloverselecteddsn} --json <a-!><ret>jd'\n"
    fi
  }

  opensqlover
  execute-keys 'gj'
}
