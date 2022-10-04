# Create a fileset of 50,000 entries ($nfiles), where each file's size is set
# to be 15KB ($filesize).
# Fire off 16 threads ($nthreads), where each thread stops after
# deleting 1000 ($count) files.

set $dir=/tmp
set $count=1000
set $filesize=15k
set $nfiles=5000

define fileset name="testF",path=$dir,size=$filesize,entries=$nfiles,prealloc

define process name=filedelete,instances=3
{
  thread name=filedeletethread,memsize=10m,instances=2
  {
    flowop deletefile name=deletefile1,filesetname="testF"
    flowop opslimit name=limit
    flowop finishoncount name=finish,value=$count
  }
}

run 10