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

# #bundle kakoune-smooth-scroll "https://github.com/caksoylar/kakoune-smooth-scroll" %{
# #    set-option -add global scroll_options max_duration=80
# #    # hook global WinDisplay .* %{
# #        # smooth-scroll-enable
# #    # }
# #
# #    hook global WinCreate [^*].* %{
# #        hook -once window WinDisplay .* %{
# #            smooth-scroll-enable
# #        }
# #    }
# #}
#
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
   # Post-install code here...
   mkdir -p ${kak_config}/colors
   ln -sf "${kak_opt_bundle_path}/one.kak" "${kak_config}/colors/"
 }


 bundle kakoune-buffers 'https://github.com/Delapouite/kakoune-buffers' %{
  # source "%opt{bundle_path}/kakoune-buffers/buffers.kak"
      # Suggested hook


  # require-module kakoune-buffers.kak
  hook global WinDisplay .* info-buffers

     # # Suggested mappings

     map global user b ':enter-buffers-mode<ret>'              -docstring 'buffers…'
     map global user B ':enter-user-mode -lock buffers<ret>'   -docstring 'buffers (lock)…'

     # Suggested aliases

     alias global bd delete-buffer
     alias global bf buffer-first
     alias global bl buffer-last
     alias global bo buffer-only
     alias global bo! buffer-only-force
 }


#bundle kak-lsp https://github.com/kak-lsp/kak-lsp %{
#  # Configure here...
#
# hook global WinSetOption filetype=(rust|python|go|javascript|typescript|c|cpp) %{
#     lsp-enable-window
#
#     lsp-inlay-hints-enable global
#
#     map global user l %{:enter-user-mode lsp<ret>} -docstring "LSP mode"
#     map global insert <tab> '<a-;>:try lsp-snippets-select-next-placeholders catch %{ execute-keys -with-hooks <lt>tab> }<ret>' -docstring 'Select next snippet placeholder'
#     map global object a '<a-semicolon>lsp-object<ret>' -docstring 'LSP any symbol'
#     map global object <a-a> '<a-semicolon>lsp-object<ret>' -docstring 'LSP any symbol'
#     map global object e '<a-semicolon>lsp-object Function Method<ret>' -docstring 'LSP function or method'
#     map global object k '<a-semicolon>lsp-object Class Interface Struct<ret>' -docstring 'LSP class interface or struct'
#     map global object d '<a-semicolon>lsp-diagnostic-object --include-warnings<ret>' -docstring 'LSP errors and warnings'
#     map global object D '<a-semicolon>lsp-diagnostic-object<ret>' -docstring 'LSP errors'
# }
#  hook global KakEnd .* lsp-exit
#} %{
#  # Post-install code here...
#    cargo install --locked --force --path .
#    mkdir -p ~/.config/kak-lsp
#    cp -n kak-lsp.toml ~/.config/kak-lsp/
#}

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

set-option global tabstop 8
set-option global indentwidth 4

## use spaces instead of tabs
map global insert <tab> '<a-;><gt>'
map global insert <s-tab> '<a-;><lt>'

set-option global scrolloff 8,3
map global normal <esc> ";,"
map global normal <c-/>  ":comment-line<ret>"

## allways remove trailing whitespace
hook global BufWritePre .* %{ try %{ execute-keys -draft \%s\h+$<ret>d } }

## use ripgrep as regex search tool
set global grepcmd 'rg --column'


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
     Send kakoune client to the background
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
        printf "$1 $f\n"
    done < "$2"
}}

def toggle-broot %{
        # "broot -c :open_preview > /tmp/broot-files-%val{client_pid}" \
       suspend-and-resume \
        "broot --conf ~/.config/broot/kak-conf.hjson -c :open_preview > /tmp/broot-files-%val{client_pid}" \
        "for-each-line edit /tmp/broot-files-%val{client_pid}"

}

map global user b ': toggle-broot<ret>' -docstring 'select files in broot'


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
