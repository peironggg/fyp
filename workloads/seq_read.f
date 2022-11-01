set $dir=/tmp
set $filesize=15k
set $iosize=5k
set $nfiles=1000

define fileset name="testF",entries=$nfiles,filesize=$filesize,prealloc,path=$dir
define process name="seq-readerP",instances=3 {
    thread name="seq-readerT",instances=2 {
        flowop openfile name="openOP",filesetname="testF"
        flowop read name="seq-readOP",iosize=$iosize,filesetname="testF",directio
        flowop closefile name="closeOP"
    }
}

enable lathist
run 10