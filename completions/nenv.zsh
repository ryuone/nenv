if [[ ! -o interactive ]]; then
    return
fi

compctl -K _nenv nenv

_nenv() {
  local words completions
  read -cA words

  if [ "${#words}" -eq 2 ]; then
    completions="$(nenv commands)"
  else
    completions="$(nenv completions ${words[2,-2]})"
  fi

  reply=("${(ps:\n:)completions}")
}
