if [[ ! -o interactive ]]; then
    return
fi

compctl -K _tillage tillage

_tillage() {
  local word words completions
  read -cA words
  word="${words[2]}"

  if [ "${#words}" -eq 2 ]; then
    completions="$(tillage commands)"
  else
    completions="$(tillage completions "${word}")"
  fi

  reply=("${(ps:\n:)completions}")
}
