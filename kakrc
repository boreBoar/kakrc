evaluate-commands %sh{
    plugins="$kak_config/plugins"
    mkdir -p "$plugins"
    [ ! -e "$plugins/kak-bundle" ] && \
        git clone -q https://github.com/jdugan6240/kak-bundle.git  "$plugins/kak-bundle"
    printf "%s\n" "source '$plugins/kak-bundle/rc/kak-bundle.kak'"
    printf "%s\n" "set-option global bundle_path '$plugins/'"
    printf "%s\n" "hook global User bundle-after-install %{ quit! }"
}
bundle-noload kak-bundle https://github.com/jdugan6240/kak-bundle

bundle kakoune-state-save "https://gitlab.com/Screwtapello/kakoune-state-save" %{
        hook global KakBegin .* %{
            state-save-reg-load colon
            state-save-reg-load pipe
            state-save-reg-load slash
        }
        hook global KakEnd .* %{
            state-save-reg-save colon
            state-save-reg-save pipe
            state-save-reg-save slash
        }
        hook global FocusOut .* %{ state-save-reg-save dquote }
        hook global FocusIn  .* %{ state-save-reg-load dquote }
}
bundle number-toggle.kak 'https://github.com/evanrelf/number-toggle.kak' %{
        # source "%opt{bundle_path}/number-toggle.kak/rc/number-toggle.kak"
        require-module "number-toggle"
        set-option -add global number_toggle_params -hlcursor
}


# bundle-noload one.kak https://github.com/raiguard/one.kak %{
bundle one.kak https://github.com/raiguard/one.kak %{
        colorscheme one-dark
} %{
       ## Post-install code here...
       mkdir -p ${kak_config}/colors
       ln -sf "${kak_opt_bundle_path}/one.kak" "${kak_config}/colors/"
}


bundle kakoune-buffers 'https://github.com/Delapouite/kakoune-buffers' %{
  ## source "%opt{bundle_path}/kakoune-buffers/buffers.kak"
  ## Suggested hook


  ## require-module kakoune-buffers.kak
  hook global WinDisplay .* info-buffers

     ## Suggested mappings

     map global user b ':enter-buffers-mode<ret>'              -docstring 'buffers…'
     map global user B ':enter-user-mode -lock buffers<ret>'   -docstring 'buffers (lock)…'

     ## Suggested aliases

     alias global bd delete-buffer
     alias global bf buffer-first
     alias global bl buffer-last
     alias global bo buffer-only
     alias global bo! buffer-only-force
}
bundle auto-pairs.kak https://github.com/alexherbo2/auto-pairs.kak %{enable-auto-pairs}

bundle kakoune-snippets "https://github.com/occivink/kakoune-snippets"

bundle kakoune-emmet "https://github.com/JJK96/kakoune-emmet"  %{
	hook global WinSetOption filetype=html %{
		emmet-enable-autocomplete
	}
}

bundle kakoune-focus "https://github.com/caksoylar/kakoune-focus" %{
    define-command focus-live-enable %{
        focus-selections
        hook -group focus window NormalIdle .* %{ focus-extend }
    }
    define-command focus-live-disable %{
        remove-hooks window focus
        focus-clear
    }
    map global user <space> ': focus-toggle<ret>' -docstring "toggle selections focus"
}

# use tab and shift-tab to navigate the completion menu
hook global InsertCompletionShow .* %{ map window insert <tab> <c-n>; map window insert <s-tab> <c-p> }
hook global InsertCompletionHide .* %{ unmap window insert <tab> <c-n>; unmap window insert <s-tab> <c-p> }


# YOU WILL NOT FUCK MY EYES
face global MenuBackground Default
face global MenuInfo Default
face global Information Default

add-highlighter global/wrap wrap -word -indent -marker ⤷


bundle kak-lsp https://github.com/kak-lsp/kak-lsp %{
  # Configure here...

 hook global WinSetOption filetype=(rust|python|go|javascript|typescript|c|cpp) %{
#      eval %sh{kak-lsp --kakoune -s $kak_session}
    set-option global lsp_hover_anchor true
    set-option global lsp_auto_show_code_actions true
    set-face global InlayHint black+i
    set-face global PrimarySelection default,black,default

    set-option window lsp_diagnostic_line_error_sign "!"
    set-option window lsp_diagnostic_line_warning_sign "?"
    set-face window DiagnosticError default+u
    set-face window DiagnosticWarning default+u
    set-option global lsp_cmd "kak-lsp -s %val{session} -vvv --log /tmp/kak-lsp.log"

    lsp-enable-window

    # lsp-diagnostic-lines-disable window
    lsp-inline-diagnostics-disable window

    lsp-auto-hover-enable
    lsp-auto-signature-help-enable
    #lsp-inlay-diagnostics-enable window
    lsp-inlay-hints-enable window
    lsp-inlay-code-lenses-enable window
    #lsp-inline-diagnostics-enable window

    ## common options




     map global user l %{:enter-user-mode lsp<ret>} -docstring "LSP mode"
     map global insert <tab> '<a-;>:try lsp-snippets-select-next-placeholders catch %{ execute-keys -with-hooks <lt>tab> }<ret>' -docstring 'Select next snippet placeholder'
     map global object a '<a-semicolon>lsp-object<ret>' -docstring 'LSP any symbol'
     map global object <a-a> '<a-semicolon>lsp-object<ret>' -docstring 'LSP any symbol'
     map global object e '<a-semicolon>lsp-object Function Method<ret>' -docstring 'LSP function or method'
     map global object k '<a-semicolon>lsp-object Class Interface Struct<ret>' -docstring 'LSP class interface or struct'
     map global object d '<a-semicolon>lsp-diagnostic-object --include-warnings<ret>' -docstring 'LSP errors and warnings'
     map global object D '<a-semicolon>lsp-diagnostic-object<ret>' -docstring 'LSP errors'



     ## LSP
     #declare-user-mode user-lsp
     #map global user l ':enter-user-mode user-lsp<ret>'      -docstring 'lsp mode'
     #map global user-lsp a ':lsp-code-actions<ret>'          -docstring 'code action'
     #map global user-lsp c ':lsp-code-lens<ret>'             -docstring 'execute code lens'
     #map global user-lsp d ':lsp-diagnostics<ret>'           -docstring 'list diagnostics'
     #map global user-lsp i ':lsp-incoming-calls<ret>'        -docstring 'incoming calls'
     #map global user-lsp I ':lsp-implementation<ret>'        -docstring 'list implementations'
     #map global user-lsp h ':lsp-highlight-references<ret>'  -docstring 'highlight references'
     #map global user-lsp k ':lsp-hover<ret>'                 -docstring 'hover'
     #map global user-lsp K ':lsp-hover-buffer<ret>'          -docstring 'hover in a dedicated buffer'
     #map global user-lsp p ':lsp-workspace-symbol-incr<ret>' -docstring 'pick workspace symbol'
     #map global user-lsp P ':lsp-workspace-symbol<ret>'      -docstring 'list workspace symbols'
     #map global user-lsp r ':lsp-references<ret>'            -docstring 'list references'
     #map global user-lsp R ':lsp-rename-prompt<ret>'         -docstring 'rename'
     #map global user-lsp o ':lsp-outgoing-calls<ret>'        -docstring 'outgoing calls'
     #map global user-lsp s ':lsp-goto-document-symbol<ret>'  -docstring 'pick document symbol'
     #map global user-lsp S ':lsp-document-symbol<ret>'       -docstring 'list workspace symbols'
     #map global user-lsp x ':lsp-find-error<ret>'            -docstring 'jump to the prev/next error'
     #map global user-lsp ( ':lsp-previous-function<ret>'     -docstring 'jump to the previous function'
     #map global user-lsp ) ':lsp-next-function<ret>'         -docstring 'jump to the next function'
  hook global KakEnd .* lsp-exit
 }
} %{
  # Post-install code here...
    cargo install --locked --force --path .
    mkdir -p ~/.config/kak-lsp
    cp -n kak-lsp.toml ~/.config/kak-lsp/
}




# bundle-noload kamp https://github.com/vbauerster/kamp %{
# bundle kamp "git clone -b v0.2.1 https://github.com/vbauerster/kamp" %{
#bundle kamp https://github.com/vbauerster/kamp %{
#   # Configure here...
#    evaluate-commands %sh{
#        kamp init -a -e EDITOR='kamp edit'
#    }
#        require-module kitty
#        alias global popup kitty-terminal
#        # map global user   -docstring 'broot'          b ':connect popup kamp-broot<ret>'
#        #map global user   -docstring 'broot'          b ':connect popup /opt/homebrew/bin/broot -c\: open_preview<ret>'
#        map global user   -docstring 'nnn'          q ':connect popup kamp-nnn<ret>'
#        map global normal -docstring 'files'          <c-f> ':connect popup kamp-files<ret>'
#        map global normal -docstring 'git ls-files'   <c-l> ':connect popup kamp-files backend=git<ret>'
#        map global normal -docstring 'buffers'        <c-b> ':connect popup kamp-buffers<ret>'
#        map global normal -docstring 'grep selection' <c-g> ':connect popup kamp-grep "query=%val{selection}"<ret>'
#        map global normal -docstring 'grep limit by filetype' <c-y> ':connect popup kamp-grep -t %opt{filetype}<ret>'
#        # map global normal -docstring 'files'          <c-f> ':connect popup broot<ret>'
#        # alias k='kamp edit'
#        # alias kval='kamp get val'
#        # alias kopt='kamp get opt'
#        # alias kreg='kamp get reg'
#        # alias kcd-pwd='cd "$(kamp get sh pwd)"'
#        # alias kcd-buf='cd "$(dirname $(kamp get val buffile))"'
#        # alias kft='kamp get opt -b \* -s filetype | sort | uniq' # list file types you're working on
#
#} %{
#   # Post-install code here...
#     cargo install --locked --force --path .
#}



#bundle prelude.kak "https://github.com/kakounedotcom/prelude.kak"
#bundle connect.kak "https://github.com/kakounedotcom/connect.kak" %{
## source "%opt{bundle_path}/connect.kak/rc/connect/modules/broot/broot.kak"
#        # depends on prelude.kak
#        require-module connect
#        require-module connect-broot
#        set-option global connect_environment %{
#            export EDITOR=:e
#        }
#}




set-option global ui_options terminal_status_on_top=true
set-face global CurSearch +u


add-highlighter global/git-diff flag-lines Default git_diff_flags
add-highlighter global/number-lines number-lines -hlcursor
add-highlighter global/hl-col-120 column 120 black+r


## Enable editor config
 ## ────────────────────
#
# #hook global BufOpenFile .* %{ editorconfig-load }
# #hook global BufNewFile .* %{ editorconfig-load }
# #
# ## Filetype specific hooks
# ## ───────────────────────
# #
hook global WinSetOption filetype=(c|cpp) %{
     clang-enable-autocomplete
     clang-enable-diagnostics
     alias window lint clang-parse
     alias window lint-next-error clang-diagnostics-next
}

# hook global WinSetOption filetype=python %{
#     jedi-enable-autocomplete
#     lint-enable
#     set-option global lintcmd 'flake8'
#}

map -docstring "xml tag objet" global object t %{c<lt>([\w.]+)\b[^>]*?(?<lt>!/)>,<lt>/([\w.]+)\b[^>]*?(?<lt>!/)><ret>}

# ## Highlight the word under the cursor
# ## ───────────────────────────────────
#
set-face global CurWord +b

hook global NormalIdle .* %{
     eval -draft %{ try %{
         exec ,<a-i>w <a-k>\A\w+\z<ret>
         add-highlighter -override global/curword regex "\b\Q%val{selection}\E\b" 0:CurWord
     } catch %{
         add-highlighter -override global/curword group
     } }
}
 #
 ## Switch cursor color in insert mode
 ## ──────────────────────────────────
 #
set-face global InsertCursor default,green+B

hook global ModeChange .*:.*:insert %{
     set-face window PrimaryCursor InsertCursor
     set-face window PrimaryCursorEol InsertCursor
 }

hook global ModeChange .*:insert:.* %{ try %{
     unset-face window PrimaryCursor
     unset-face window PrimaryCursorEol
} }

 ## Custom mappings
 ## ───────────────
 #
 #map global normal = ':prompt math: %{exec "a%val{text}<lt>esc>|bc<lt>ret>"}<ret>'
# #
# ## System clipboard handling
# ## ─────────────────────────
# #
# #evaluate-commands %sh{
#     #if [ -n "$SSH_TTY" ]; then
#         #copy='printf "\033]52;;%s\033\\" $(base64 | tr -d "\n") > $( [ -n "$kak_client_pid" ] && echo /proc/$kak_client_pid/fd/0 || echo /dev/tty )'
#         #paste='printf "paste unsupported through ssh"'
#         #backend="OSC 52"
#     #else
#         #case $(uname) in
#             #Linux)
#                 #if [ -n "$WAYLAND_DISPLAY" ]; then
#                     #copy="wl-copy -p"; paste="wl-paste -p"; backend=Wayland
#                 #else
#                     #copy="xclip -i"; paste="xclip -o"; backend=X11
#                 #fi
#                 #;;
#             #Darwin)  copy="pbcopy"; paste="pbpaste"; backend=OSX ;;
#         #esac
#     #fi
# #
#     #printf "map global user -docstring 'paste (after) from clipboard' p '<a-!>%s<ret>'\n" "$paste"
#     #printf "map global user -docstring 'paste (before) from clipboard' P '!%s<ret>'\n" "$paste"
#     #printf "map global user -docstring 'yank to primary' y '<a-|>%s<ret>:echo -markup %%{{Information}copied selection to %s primary}<ret>'\n" "$copy" "$backend"
#     #printf "map global user -docstring 'yank to clipboard' Y '<a-|>%s<ret>:echo -markup %%{{Information}copied selection to %s clipboard}<ret>'\n" "$copy -selection clipboard" "$backend"
#     #printf "map global user -docstring 'replace from clipboard' R '|%s<ret>'\n" "$paste"
#     #printf "define-command -override echo-to-clipboard -params .. %%{ echo -to-shell-script '%s' -- %%arg{@} }" "$copy"
# #}
# #
#     #
#     #
#     #
#     #
#     #
#     #
#     #
#     #
#     #
# add-highlighter global/ number-lines
# ## add-highlighter global/ number-lines -hlcursor -relative -separator "  " -cursor-separator " |"
#add-highlighter global/ show-matching

set-option global tabstop 28
set-option global indentwidth 2

## use spaces instead of tabs
map global insert <tab> '<a-;><gt>'
map global insert <s-tab> '<a-;><lt>'

set-option global scrolloff 8,3
map global normal <esc> ";,"
map global normal <c-/>  ":comment-line<ret>"

## allways remove trailing whitespace
hook global BufWritePre .* %{ try %{ execute-keys -draft \%s\h+$<ret>d } }

## use ripgrep as regex search tool
set global grepcmd '/opt/homebrew/bin/rg --column'


# declare-option str brootcmd "%val{config}/kak_open"
# set global brootcmd '/opt/homebrew/bin/broot -c :open_preview'






## fancy insert newline
#map -docstring "insert newline above" global user [ "O<esc>j"
#map -docstring "insert newline below" global user ] "o<esc>k"

## spellcheck (requires aspell)
#map -docstring "check document for spelling" global user w ": spell<ret>"
#map -docstring "clear document spelling" global user q ": spell-clear<ret>"
#
#
## copy to system pboard [MAC ONLY]
#map -docstring "copy to system pboard" global user y "<a-|> pbcopy<ret>"





#
#     #
# #def ide1 %{
#     #rename-client main
#     #set global jumpclient main
# #
#     #new rename-client tools
#     #set global toolsclient tools
# #
#     #new rename-client docs
#     #set global docsclient docs
# #}
# #
# #
def suspend-and-resume \
    -params 1..2 \
    -docstring 'suspend-and-resume <cli command> [<kak command after resume>]: backgrounds current kakoune client and runs specified cli command.  Upon exit of command the optional kak command is executed.' \
    %{ evaluate-commands %sh{

    ## Note we are adding '&& fg' which resumes the kakoune client process after the cli command exits
    cli_cmd="$1 && fg"
    post_resume_cmd="$2"

    ## automation is different platform to platform
    platform=$(uname -s)
    case $platform in
        Darwin)
            automate_cmd="sleep 0.01; osascript -e 'tell application \"System Events\" to keystroke \"$cli_cmd\" & return '"
            kill_cmd="/bin/kill"
            break
            ;;
        Linux)
            automate_cmd="sleep 0.2; xdotool type '$cli_cmd'; xdotool key Return"
            kill_cmd="/usr/bin/kill"
            break
            ;;
    esac

    ## Uses platforms automation to schedule the typing of our cli command
    nohup sh -c "$automate_cmd"  > /dev/null 2>&1 &
    ## Send kakoune client to the background
    $kill_cmd -SIGTSTP $kak_client_pid

     ## ...At this point the kakoune client is paused until the " && fg " gets run in the $automate_cmd

     ## Upon resume, run the kak command is specified
    if [ ! -z "$post_resume_cmd" ]; then
        echo "$post_resume_cmd"
    fi
}}



def for-each-line \
    -docstring "for-each-line <command> <path to file>: run command with the value of each line in the file" \
    -params 2 \
    %{ evaluate-commands %sh{

    while read f; do
        printf "$1 '$f'\n"
    done < "$2"
}}


def toggle-broot %{
        # "broot -c :open_preview > /tmp/broot-files-%val{client_pid}" \
       suspend-and-resume \
        "broot --conf ~/.config/broot/kak-conf.hjson -c :open_preview > /tmp/broot-files-%val{client_pid}" \
        "for-each-line edit /tmp/broot-files-%val{client_pid}"

}

map global user / ': toggle-broot<ret>' -docstring 'select files in broot'


## map global user -docstring 'open file with broot' r ':broot-edit<ret>'
#
## define-command -hidden broot-edit %{
  ## eval %sh{
    ## tmp=$(mktemp ${TMPDIR:-/tmp}kak-broot.XXXXX)
    ## cat << EOF > $tmp
    ## set +e
    ## broot --outcmd $tmp.out
    ## code=\$?
    ## printf "echo -debug '%s'\n" "return \$code" | kak -p $kak_session
    ## if [ "\$code" == "0" ] ; then
      ## printf "echo -debug '%s'\n" "reading $tmp.out" | kak -p $kak_session
      ## printf "echo -debug '%s'\n" "$(cat $tmp.out)" | kak -p $kak_session
      ## while read line ; do
        ## printf "edit '%s'\n" "\$line" | kak -p $kak_session
        ## printf "echo -debug '%s'\n" "\$line" | kak -p $kak_session
      ## done < $tmp.out
    ## fi
    ## #rm $tmp
    ## #rm $tmp.out
## EOF
    ## chmod u+x "$tmp"
    ## printf "terminal '%q'\n" "$tmp"
  ## }
## }
# ##
# ## declare-option str kak_open "%val{config}/kak_open"
# ##
# ## # broot
# ## # ─────
# ## define-command broot -docstring "open broot" -params .. %{
#     ## terminal sh -c "EDITOR=%opt{kak_open} KAK_SESSION=%val{session} KAK_CLIENT=%val{client} broot %arg{@}"
# ## }
# ## complete-command broot file
# ##
# ## # browse with broot + kak editor combination
# ## define-command -override -params 0 -docstring %{
#   ## browse: split window and browse current directory with broot
#   ## No checking if used commands and tools exist is currently performed
# ## } browse %{ evaluate-commands %{
#   ## terminal %sh{ echo "kak_session=$kak_session broot /" }
# ## }}
# ## alias global br browse
# #
#   #
# #require-module prelude
# #require-module connect
# #require-module connect-broot
#hook global ModuleLoaded kitty %{
#   #alias global popup kitty-terminal-tab # or kitty-terminal
# #}
# #
# map global user F ': connect-terminal --location=vsplit /opt/homebrew/bin/broot <ret>' -docstring 'files'
# map global user F ': connect-terminal /opt/homebrew/bin/broot <ret>' -docstring 'files'
# ##
# #
# #
# #
# ## map global user F ': connect-broot<ret>' -docstring 'files'
# #
# #
# #define-command ide2 -params 0..1 -docstring 'ide [session-name]: Turn Kakoune into an IDE' %{
#   ## Session name
#   #try %{
#     #rename-session %arg{1}
#   #}
# #
#   ## Main client
#   #rename-client main
#   #set-option global jumpclient main
#     #
#   ## # Tools client
#   ## new %{
#     ## rename-client tools
#     ## set-option global toolsclient tools
#   ## }
# #
#   ## # Docs client
#   ## new %{
#     ## rename-client docs
#     ## set-option global docsclient docs
#   ## }
# #
#   ## # Project drawer
#   ## dolphin
#   #
#   ## # Git
#   ## > lazygit
#   #
#   ## # Terminal
#   ## >
# #}
hook global BufCreate .*\.(conf) %{ set buffer filetype conf }
map global insert <c-w>   '<esc>bdi'

### git
#declare-user-mode git
#map global user g ':enter-user-mode git<ret>' -docstring 'git mode'
#map global git p ':git prev-hunk<ret>'        -docstring 'goto previous hunk'
#map global git n ':git next-hunk<ret>'        -docstring 'goto next hunk'




## kitty integration
define-command -hidden kitty-split -params 1 -docstring 'split the current window according to the param (vsplit / hsplit)' %{
  nop %sh{
    kitty @ launch --no-response --location $1 kak -c $kak_session
  }
}

## zellij integration
define-command -hidden zellij-split -params 1 -docstring 'split (down / right)' %{
  nop %sh{
    zellij action new-pane -cd $1 -- kak -c $kak_session
  }
}

define-command -hidden zellij-move-pane -params 1 -docstring 'move to pane' %{
  nop %sh{
    zellij action move-focus $1
  }
}


## Some pickers
define-command -hidden open_buffer_picker %{
  prompt buffer: -menu -buffer-completion %{
    buffer %val{text}
  }
}

define-command -hidden open_file_picker %{
  prompt file: -menu -shell-script-candidates 'fd --type=file' %{
    edit -existing %val{text}
  }
}

define-command -hidden open_rg_picker %{
  prompt search: %{
    prompt refine: -menu -shell-script-candidates "rg -in '%val{text}'" %{
      eval "edit -existing  %sh{(cut -d ' ' -f 1 | tr ':' ' ' ) <<< $kak_text}"
    }
  }
}


## pickers
map global user b ':open_buffer_picker<ret>' -docstring 'pick buffer'
map global user f ':open_file_picker<ret>'   -docstring 'pick file'
map global user / ':open_rg_picker<ret>'     -docstring 'search project'



#### Inspirations:
# https://git.sr.ht/~raiguard/dotfiles/tree/master/item/.config/kak/kakrc#L514
#https://github.com/phaazon/config/blob/054ea8110f59c53876e66e6ee30da180bea34ff6/kak/kakrc#L4
#


hook global WinCreate .* %{ try %{
    add-highlighter buffer/numbers  number-lines -hlcursor
    add-highlighter buffer/matching show-matching
    add-highlighter buffer/wrap     wrap -word -indent
    add-highlighter buffer/todo     regex \b(TODO|FIXME|XXX|NOTE)\b 0:default+rb
}}

hook global BufOpenFile  .* modeline-parse
hook global BufWritePre  .* %{ nop %sh{ mkdir -p $(dirname "$kak_hook_param") }}
hook global BufWritePost .* %{ git show-diff }
hook global BufReload    .* %{ git show-diff }
hook global WinDisplay   .* %{ evaluate-commands %sh{
    cd "$(dirname "$kak_buffile")"
    project_dir="$(git rev-parse --show-toplevel 2>/dev/null)"
    [ -n "$project_dir" ] && dir="$project_dir" || dir="${PWD%/.git}"
    printf "cd %%{%s}\n" "$dir"
    [ -n "$project_dir" ] && [ "$kak_buffile" = "${kak_buffile#\*}" ] && printf "git show-diff"
} }
