set $dir=/tmp
set $num_files=1000
set $filesize=15k
set $num_processes=3
set $num_threads=2

define fileset name="benchmarkF",entries=$num_files,filesize=$filesize,path=$dir,prealloc

define process name="benchmarkP",instances=$num_processes {
    thread name="benchmarkT",instances=$num_threads {
        flowop openfile name="openOP",filesetname="benchmarkF"
        flowop readwholefile name="writeOP",iosize=$filesize,random,filesetname="benchmarkF",directio
        flowop appendfile name="appendOP",filename="benchmarkF",iosize=1
        flowop closefile name="closeOP"        
    }
}

run 10