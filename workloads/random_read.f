set $dir=/tmp
set $filesize=15k
set $iosize=5k
set $nfiles=1000

define fileset name="testF",entries=$nfiles,filesize=$filesize,prealloc,path=$dir
define process name="random-readerP",instances=3 {
    thread name="random-readerT",instances=2 {
        flowop openfile name="openOP",filesetname="testF"
        flowop read name="random-readOP",iosize=$iosize,random,filesetname="testF",directio
        flowop closefile name="closeOP"
    }
}

run 10