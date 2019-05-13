# alias
alias g='git'

# cd の後に ls
function cd
    buildin cd $argv; and ls
end
