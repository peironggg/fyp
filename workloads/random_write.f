set $dir=/tmp
set $filesize=15k
set $iosize=5k
set $nfiles=1000

define fileset name="testF",entries=$nfiles,filesize=$filesize,prealloc,path=$dir
define process name="random-writerP",instances=3 {
    thread name="random-writerT",instances=2 {
        flowop openfile name="openOP",filesetname="testF"
        flowop write name="random-writeOP",iosize=$iosize,random,filesetname="testF",directio
        flowop closefile name="closeOP"
    }
}

enable lathist
run 10