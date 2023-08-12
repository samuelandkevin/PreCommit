#!/bin/sh

#使用方法：bash -l ./pod.sh

export LANG=UTF-8

PodfileName="Podfile"

/bin/rm -rf Podfile.lock
/bin/rm -rf $PodfileName

echo "\
target 'PreCommit' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  #
 
 
end
">> $PodfileName

SctiptPath=$(cd `dirname $0`; pwd)
cd ${SctiptPath} && pwd

##文件权限检查
checkPath=../check
sh ${checkPath}/init.sh
