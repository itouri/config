# alias
alias g='git'

# cd の後に ls
function cd
    builtin cd $argv; and ls
end
