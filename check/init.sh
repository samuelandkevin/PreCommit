#!/bin/sh
export LANG=UTF-8
dir=$(cd $(dirname $0); pwd)
echo ${dir}

preCommitPath=../.git/hooks/pre-commit

/bin/rm -rf ${preCommitPath}
/bin/cp -r ${dir}/pre-commit ${preCommitPath}
