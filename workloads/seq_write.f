set $dir=/tmp
set $filesize=15k
set $iosize=5k
set $nfiles=1000

define fileset name="testF",entries=$nfiles,filesize=$filesize,prealloc,path=$dir
define process name="seq-writerP",instances=3 {
    thread name="seq-writerP",instances=2 {
        flowop openfile name="openOP",filesetname="testF"
        flowop write name="seq-writeOP",iosize=$iosize,filesetname="testF",directio
        flowop closefile name="closeOP"
    }
}

run 10