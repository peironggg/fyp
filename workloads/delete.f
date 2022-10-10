set $dir=/tmp
set $filesize=15k
set $iosize=5k
set $nfiles=6000
set $count=10

define fileset name="testF",entries=$nfiles,filesize=$filesize,prealloc,path=$dir
define process name="files-deleterP",instances=3 {
    thread name="files-deleterT",instances=2 {
        flowop deletefile name="deleteOP",filesetname="testF"
        flowop finishoncount name="finishOP",value=$count
    }
}

run 10