source ~/ai/ai_hooks.sh
[ -t 0 ]||o=$(cat);u=$(uuidgen)
while :;do
eval "${P:-:}"
r=$(llm -s "$(<"$0")" "$@" ${d:+--cid $d} ${ATTACH_FLAGS:+$ATTACH_FLAGS} <<<"U:$u
$o")
c=$(sed -n '/^````/,/^````/{//!p}' <<<"$r")
eval "${R:-[ \"\$c\" ]&&o=\$(echo \"\$c\"|bash 2>&1)||DONE=1}"
# FIXED: Also detect DONE=1 in response text (restores old behavior)
[ "$DONE" ]||[[ "$r" =~ DONE=1 ]]&&{ echo "$r";break; }
set --;continue;done
