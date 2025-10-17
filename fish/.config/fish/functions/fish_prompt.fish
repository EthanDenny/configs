# This prompt uses the Dracula color scheme, and is also based on
# https://github.com/oh-my-fish/theme-agnoster which is itself based on
# agnoster's theme - https://gist.github.com/3712874
#
# The MIT License (MIT)
#
# Copyright (c) 2014 Bruno Ferreira Pinto
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

## Set this options in your config.fish (if you want to :])
# set -g default_user your_normal_user

set -g current_bg NONE
set -g segment_separator \uE0B0
set -g right_segment_separator \uE0B0
set -q scm_prompt_blacklist; or set -g scm_prompt_blacklist
set -q max_package_count_visible_in_prompt; or set -g max_package_count_visible_in_prompt 10
# We support trimming the version only in simple cases, such as "1.2.3".
set -q try_to_trim_nix_package_version; or set -g try_to_trim_nix_package_version yes

# ===========================
# Color setting
# ===========================

set -g dracula_white f8f8f2
set -g dracula_grey 44475a
set -g dracula_black 282A36
set -g dracula_red ff5555
set -g dracula_orange ffb86c
set -g dracula_green 50fa7b
set -g dracula_cyan 8be9fd
set -g dracula_pink ff79c6
set -g dracula_purple bd93f9

set -q color_virtual_env_bg; or set -g color_virtual_env_bg $dracula_white
set -q color_virtual_env_str; or set -g color_virtual_env_str $dracula_black
set -q color_user_bg; or set -g color_user_bg $dracula_purple
set -q color_user_str; or set -g color_user_str $dracula_black
set -q color_dir_bg; or set -g color_dir_bg $dracula_cyan
set -q color_dir_str; or set -g color_dir_str $dracula_black
set -q color_git_dirty_bg; or set -g color_git_dirty_bg $dracula_orange
set -q color_git_dirty_str; or set -g color_git_dirty_str $dracula_black
set -q color_git_bg; or set -g color_git_bg $dracula_green
set -q color_git_str; or set -g color_git_str $dracula_black
set -q color_status_nonzero_bg; or set -g color_status_nonzero_bg $dracula_grey
set -q color_status_nonzero_str; or set -g color_status_nonzero_str $dracula_red
set -q glyph_status_nonzero; or set -g glyph_status_nonzero "✘"
set -q color_status_superuser_bg; or set -g color_status_superuser_bg $dracula_pink
set -q color_status_superuser_str; or set -g color_status_superuser_str $dracula_black
set -q glyph_status_superuser; or set -g glyph_status_superuser "🔒"
set -q color_status_jobs_bg; or set -g color_status_jobs_bg $dracula_grey
set -q color_status_jobs_str; or set -g color_status_jobs_str $dracula_black
set -q glyph_status_jobs; or set -g glyph_status_jobs "⚡"
set -q color_status_private_bg; or set -g color_status_private_bg $dracula_grey
set -q color_status_private_str; or set -g color_status_private_str $dracula_pink
set -q glyph_status_private; or set -g glyph_status_private "⚙"

# ===========================
# General VCS settings

set -q fish_vcs_branch_name_length; or set -g fish_vcs_branch_name_length 15

# ===========================
# Git settings
# set -g color_dir_bg red

set -q fish_git_prompt_untracked_files; or set -g fish_git_prompt_untracked_files normal

# ===========================
# Helper methods
# ===========================

set -g __fish_git_prompt_showdirtystate 'yes'
set -g __fish_git_prompt_char_dirtystate '±'
set -g __fish_git_prompt_char_cleanstate ''

function parse_git_dirty
  if [ $__fish_git_prompt_showdirtystate = "yes" ]
    set -l submodule_syntax
    set submodule_syntax "--ignore-submodules=dirty"
    set untracked_syntax "--untracked-files=$fish_git_prompt_untracked_files"
    set git_dirty (command git status --porcelain $submodule_syntax $untracked_syntax 2> /dev/null)
    if [ -n "$git_dirty" ]
        echo -n "$__fish_git_prompt_char_dirtystate"
    else
        echo -n "$__fish_git_prompt_char_cleanstate"
    end
  end
end

function cwd_in_scm_blacklist
  for entry in $scm_prompt_blacklist
    pwd | grep "^$entry" -
  end
end

# ===========================
# Segments functions
# ===========================

function prompt_segment -d "Function to draw a segment"
  set -l bg
  set -l fg
  if [ -n "$argv[1]" ]
    set bg $argv[1]
  else
    set bg normal
  end
  if [ -n "$argv[2]" ]
    set fg $argv[2]
  else
    set fg normal
  end
  if [ "$current_bg" != 'NONE' -a "$argv[1]" != "$current_bg" ]
    set_color -b $bg
    set_color $current_bg
    echo -n "$segment_separator "
    set_color -b $bg
    set_color $fg
  else
    set_color -b $bg
    set_color $fg
    echo -n " "
  end
  set current_bg $argv[1]
  if [ -n "$argv[3]" ]
    echo -n -s $argv[3] " "
  end
end

function prompt_finish -d "Close open segments"
  if [ -n $current_bg ]
    set_color normal
    set_color $current_bg
    echo -n "$segment_separator "
    set_color normal
  end
  set -g current_bg NONE
end


# ===========================
# Theme components
# ===========================

function prompt_virtual_env -d "Display Python or Nix virtual environment"
  set envs

  if test "$CONDA_DEFAULT_ENV"
    set envs $envs "conda[$CONDA_DEFAULT_ENV]"
  end

  if test "$VIRTUAL_ENV"
    set py_env (basename $VIRTUAL_ENV)
    set envs $envs "py[$py_env]"
  end

  if test "$envs"
    prompt_segment $color_virtual_env_bg $color_virtual_env_str (string join " " $envs)
  end
end

function prompt_user -d "Display current user if different from $default_user"
  if [ "$USER" != "$default_user" -o -n "$SSH_CLIENT" ]
    set USER (whoami)
    get_hostname
    set USER_PROMPT $USER@$HOSTNAME_PROMPT
    prompt_segment $color_user_bg $color_user_str $USER_PROMPT
  end
end

function get_hostname -d "Set current hostname to prompt variable $HOSTNAME_PROMPT"
  set -g HOSTNAME_PROMPT (uname -n | sed 's/\..*//')
end

function prompt_dir -d "Display the current directory"
  prompt_segment $color_dir_bg $color_dir_str (prompt_pwd)
end

function prompt_git -d "Display the current git state"
  set -l ref
  set -l dirty
  if command git rev-parse --is-inside-work-tree >/dev/null 2>&1
    set dirty (parse_git_dirty)
    set ref (command git symbolic-ref HEAD 2> /dev/null)
    if [ $status -gt 0 ]
      set -l branch (command git show-ref --head -s --abbrev |head -n1 2> /dev/null)
      set ref "➦ $branch "
    end
    set branch_symbol \uE0A0
    set -l branch (echo $ref | sed "s#refs/heads/##")
    if [ "$dirty" != "" ]
      prompt_segment $color_git_dirty_bg $color_git_dirty_str "$branch_symbol $branch $dirty"
    else
      prompt_segment $color_git_bg $color_git_str "$branch_symbol $branch"
    end
  end
end

function prompt_status -d "the symbols for a non zero exit status, root and background jobs"
    if [ $RETVAL -ne 0 ]
      prompt_segment $color_status_nonzero_bg $color_status_nonzero_str $glyph_status_nonzero
    end

    if [ "$fish_private_mode" ]
      prompt_segment $color_status_private_bg $color_status_private_str $glyph_status_private
    end

    # if superuser (uid == 0)
    set -l uid (id -u $USER)
    if [ $uid -eq 0 ]
      prompt_segment $color_status_superuser_bg $color_status_superuser_str $glyph_status_superuser
    end

    # Jobs display
    if [ (jobs -l | wc -l) -gt 0 ]
      prompt_segment $color_status_jobs_bg $color_status_jobs_str $glyph_status_jobs
    end
end

# ===========================
# Apply theme
# ===========================

function fish_prompt
  set -g RETVAL $status
  prompt_status
  prompt_user
  prompt_dir
  prompt_virtual_env
  if [ (cwd_in_scm_blacklist | wc -c) -eq 0 ]
    type -q git; and prompt_git
  end
  prompt_finish
end
