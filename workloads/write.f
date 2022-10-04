set $dir=/tmp
set $filesize=15k

define fileset name="testF",entries=10,filesize=$filesize,prealloc,path=$dir
define process name="writerP",instances=3 {
    thread name="writerT",instances=2 {
        flowop openfile name="openOP",filesetname="testF"
        flowop write name="writeOP",iosize=15k,random,filesetname="testF",directio
        flowop closefile name="closeOP"
    }
}

run 10