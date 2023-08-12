#!/bin/sh

#管理员邮箱账号数组
adminEmailArray=("xxx@qq.com")
#不能修改的文件数组
fileNameArray=("Podfile" "pod.sh" )
#检查的分支数组
checkBranches=("dev1 dev2 master main")
#修改的文件
modifyFileNames=$(git diff --cached --name-only --diff-filter=ACM --)
if [ -n "${1}" ]; then
    modifyFileNames="${1}"
fi
#当前分支名称
branch=$(git branch --show-current)
#当前用户邮箱
email=$(git config user.email)

log() {
    CURRENT=$(date "+%Y-%m-%d %H:%M:%S")
    LOG_INFO="[${YELLOW}pre-commit${PLAIN}] -> [${GREEN}${CURRENT}${PLAIN}] --> ${1}"
    echo ${LOG_INFO}
}

error() {
    log "[${RED}ERROR${PLAIN}] ---> $1"
}

info() {
    log "[${GREEN}INFO${PLAIN}] ---> $1"
}

#是否可以修改，0不可以，1可以
canModify() {
    #1、当前分支是否在检查的范围内
    containBranch=0
    for value in ${checkBranches[@]}
    do 
        if [[ ${branch} -eq value ]]; then
            containBranch=1
        fi
    done
    if [[ ${containBranch} == 0 ]]; then
        return 1
    fi

    #2、修改的文件是否在检查范围内
    if [[ ${modifyFileNames} == *$1* ]]; then
        error "你没有权限修改文件：$1, 请联系文件拥有人：${adminEmailArray[*]}"
        return 0
    fi
    return 1
}

checkFiles() {
    for value in ${fileNameArray[@]}
    do
        canModify $value
        result=$?
        if [ ${result} -eq 0 ]; then
         return 0
        fi
    done;
    return 1
}

main() {
    info "当前用户: $email"
    info "当前分支: $branch, 你修改了文件: $modifyFileNames" 

    checkFiles
    result=$?
    if [ ${result} -eq 0 ]; then
        info '没有权限修改，即将退出'
        exit 1
    fi
}

main

exit 0
