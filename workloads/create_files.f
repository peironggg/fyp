set $dir=/tmp
set $filesize=15k
set $iosize=5k
set $nfiles=100000

define fileset name="testF",entries=$nfiles,filesize=$filesize,path=$dir
define process name="files-createrP",instances=3 {
    thread name="files-createrT",instances=2 {
        flowop createfile name="createOP",filesetname="testF",directio
        flowop closefile name="closeOP"
    }
}

run 10