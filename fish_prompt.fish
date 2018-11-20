# name: eclm
function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end

function _prompt_pwd_length
  set -U fish_prompt_pwd_dir_length 0
  echo (string length (prompt_pwd))
end

function fish_prompt
  set -l last_status $status
  set -l cyan (set_color -o cyan)
  set -l yellow (set_color -o yellow)
  set -l red (set_color -o red)
  set -l blue (set_color -o blue)
  set -l green (set_color -o green)
  set -l normal (set_color normal)

  if test $last_status = 0
      set status_indicator "$green✔︎ "
  else
      set status_indicator "$red✗ "
  end

  set -l pwd-length (_prompt_pwd_length)

  if math "$pwd-length > 50" > /dev/null
      set -U fish_prompt_pwd_dir_length 1
  else 
      set -U fish_prompt_pwd_dir_length 1
  end

  set -l cwd $cyan(prompt_pwd)

  if [ (_git_branch_name) ]

    if test (_git_branch_name) = 'master'
      set -l git_branch (_git_branch_name)
      set git_info "$normal ($red$git_branch$normal)"
    else
      set -l git_branch (_git_branch_name)
      set git_info "$normal ($blue$git_branch$normal)"
    end

    if [ (_is_git_dirty) ]
      set -l dirty "$yellow ✗"
      set git_info "$git_info$dirty"
    end
  end

  # Notify if a command took more than 5 minutes
  if [ "$CMD_DURATION" -gt 300000 ]
    echo The last command took (math "$CMD_DURATION/1000") seconds.
  end

  echo -n -s $status_indicator $cwd $git_info $normal ' '
end
