u=$(uuidgen);while :;do eval "${P:-:}";r=$(llm -s "$(<"$0")" ${d:+--cid $d}<<<"U:$u
$o");c=$(sed -n '/^````/,/^````/{//!p}'<<<"$r");eval "${R:-[ \"\$c\" ]&&o=\$(echo \"\$c\"|bash 2>&1)||DONE=1}";[ "$DONE" ]&&{ echo "$r";break; };done
