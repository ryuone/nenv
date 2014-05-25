function __fish_nenv_needs_command
  set cmd (commandline -opc)
  if [ (count $cmd) -eq 1 -a $cmd[1] = 'nenv' ]
    return 0
  end
  return 1
end

function __fish_nenv_using_command
  set cmd (commandline -opc)
  if [ (count $cmd) -gt 1 ]
    if [ $argv[1] = $cmd[2] ]
      return 0
    end
  end
  return 1
end

complete -f -c nenv -n '__fish_nenv_needs_command' -a '(nenv commands)'
for cmd in (nenv commands)
  complete -f -c nenv -n "__fish_nenv_using_command $cmd" -a "(nenv completions $cmd)"
end
