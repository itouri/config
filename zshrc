### zplug
source ~/.zplug/init.zsh
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
# theme (https://github.com/sindresorhus/pure#zplug)　好みのスキーマをいれてくだされ。
zplug "mafredri/zsh-async"
zplug "sindresorhus/pure"
# 構文のハイライト(https://github.com/zsh-users/zsh-syntax-highlighting)
zplug "zsh-users/zsh-syntax-highlighting"
# history関係
zplug "zsh-users/zsh-history-substring-search"
# タイプ補完
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "chrissicool/zsh-256color"
zplug "agkozak/zsh-z"
# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi
# Then, source plugins and add commands to $PATH
zplug load

#------------------------------------------------------------------------
# copy from
# https://github.com/tsu-nera/dotfiles/blob/master/.zshrc#L46
#------------------------------------------------------------------------

### autload
autoload -Uz compinit && compinit
autoload -Uz colors && colors

### directory
# 日本語ファイル名を表示可能にする
setopt print_eight_bit
# cd -<tab>で以前移動したディレクトリを表示
setopt auto_pushd
# ディレクトリ名だけで cd
setopt auto_cd
# 同じディレクトリを pushd しない
setopt pushd_ignore_dups


### history
# saveing histrory
HISTFILE=~/.zsh_history
# メモリに保存する history 数
HISTSIZE=1000
# ファイルに保存する history 数
SAVEHIST=100000
# 同時に起動した zsh の間のヒストリを共有
setopt share_history
# シェルを横断して.zshhistoryに記録
setopt inc_append_history
# 同じコマンドは残さない
setopt hist_ignore_all_dups
# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space
# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks
# 補完時にヒストリを自動的に展開         
setopt hist_expand


### beep
# ビープ音の停止
setopt no_beep
# ビープ音の停止(補完時)
setopt nolistbeep


### in/out
# スペルチェック。間違うと訂正してくれる
setopt correct


### colors
# prompt の色を使う
setopt prompt_subst
# ディレクトリの色を設定
# http://mkit2009.hatenablog.com/entry/2013/01/28/001213
export LSCOLORS=exfxcxdxbxegedabagacad
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
alias ls="ls --color" #これがないと色つかない
zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'


# ------------------------------------------------------------------------
# Name     : z
# Function : fuzzy folder search
# url : https://github.com/sjl/z-zsh
# ------------------------------------------------------------------------
function precmd() {
    z --add "$(pwd -P)"
}

# ------------------------------------------------------------------------
# Name     : peco
# Function : consoleで helmライクなインタフェースを提供する
# ------------------------------------------------------------------------
if [ -x "`which peco`" ]; then
alias -g P='| peco'
alias llp='ls -la | peco'
alias lsp='lsv| peco'
alias tp='top | peco'
alias pp='ps aux | peco'


# ------------------------------------------------------------------------
# peco & z
# https://qiita.com/maxmellon/items/23325c22581e9187639e
# ------------------------------------------------------------------------
function peco-z-search
{
  which peco z > /dev/null
  if [ $? -ne 0 ]; then
    echo "Please install peco and z"
    return 1
  fi
  local res=$(z | sort -rn | cut -c 12- | peco)
  if [ -n "$res" ]; then
    BUFFER+="cd $res"
    zle accept-line
  else
    return 1
  fi
}
zle -N peco-z-search


# ------------------------------------------------------------------------
# history filter
# http://qiita.com/uchiko/items/f6b1528d7362c9310da0
# ------------------------------------------------------------------------
function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | \
        eval $tac | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history

# ------------------------------------------------------------------------
# peco-kill-process
# プロセスキル
# ------------------------------------------------------------------------
function peco-kill-process () {
    ps -ef | peco | awk '{ print $2 }' | xargs kill
    zle clear-screen
}
zle -N peco-kill-process


# ------------------------------------------------------------------------
# peco-ghq
# ghq を peco で素早く検索
# https://qiita.com/ysk_1031/items/8cde9ce8b4d0870a129d
# ------------------------------------------------------------------------
function peco-ghq () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-ghq


#------------------------------------------------------------------------
# peco-docker
# http://qiita.com/sonodar/items/d2de15b98581108b5de8
#------------------------------------------------------------------------
# pecoで選択したコンテナに対して操作を行う
if [ -x "`which docker`" ]; then
docker_peco_containers() {
  if [ $# -lt 1 ]; then
      echo "Usage: dpc [OPTIONS] COMMAND [args]" >&2
      return 1
  fi
  
  docker ps -a | peco | while read CONTAINER
  do
      docker $@ `echo $CONTAINER | awk '{print $1}'`
  done
}

# pecoで選択したイメージに対して操作を行う
docker_peco_images() {
    if [ $# -lt 1 ]; then
	echo "Usage: dpi [OPTIONS] COMMAND [args]" >&2
	return 1
    fi

    unset DOCKER_OPTS
    [[ -z $ENVS ]] || \
	for e in $ENVS; do DOCKER_OPTS="$DOCKER_OPTS -e $e"; done
    [[ -z $VOLUMES ]] || \
	for v in $VOLUMES; do DOCKER_OPTS="$DOCKER_OPTS -v $v"; done
    [[ -z $PORTS ]] || \
	for p in $PORTS; do DOCKER_OPTS="$DOCKER_OPTS -p $p"; done
    docker images | peco | while read IMAGE
    do
	docker $DOCKER_OPTS $@ `echo $IMAGE | awk '{print $3}'`
    done
}

# エイリアスはお好みで
alias dpc='docker_peco_containers'
alias dpi='docker_peco_images'
fi # if [ -x "`which docker`" ]; then


#------------------------------------------------------------------------
# kubectl zsh auto-completion
# https://kubernetes.io/docs/tasks/tools/included/optional-kubectl-configs-zsh/
#------------------------------------------------------------------------
# install
if [ -x "`which kubectl`" ]; then
  source <(kubectl completion zsh)
  alias k=kubectl
fi # if [ -x "`which kubectl`" ]; then


################
# key bindings
################
#bindkey '^xb'  peco-select-history # C-x b
bindkey '^r'   peco-select-history  # C-r
bindkey '^[x'  peco-M-x            # M-x
bindkey '^x^r' peco-recentd        # C-x C-r
bindkey '^xk'  peco-kill-process   # C-x k
bindkey '^x^f' peco-find-file      # C-x C-f
bindkey '^xo'  peco-open-app       # C-x o
bindkey '^g'   peco-ghq            # C-g
#bindkey '^f'   peco-z-search       # C-f
fi # if [ -x "`which peco`" ]; then


#------------------------------------------------------------------------
# 空 enter で ls
# https://kei-q.hatenadiary.org/entry/20110406/1302091565
#------------------------------------------------------------------------
alls() {
  zle accept-line
  if [[ -z "$BUFFER" ]]; then
    echo ''
    ls
  fi
}
zle -N alls
bindkey "\C-m" alls


### alias
alias g='git'
alias la='ls -la'