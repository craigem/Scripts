#!/run/current-system/sw/bin/bash
echo  -e " df $TMPFS\t    smaps $PROCS \tSwapCache $SCACH\t| $TOTAL\tswap | diff $[TOTAL-TMPFS-PROCS-SCACH]\tMB"
TMPFS=`df -kP           |awk '          /^tmpfs/{          s+=$3       }END{print int( s/1024)}'`
PROCS=`cat /proc/*/smaps|awk '/-/{r=$0} /^Swap/{if(R[r]!=1)s+=$2;R[r]=1}END{print int( s/1024)}'`
SCACH=`cat /proc/meminfo|awk '          /^SwapCached/                      {print int($2/1024)}'`
TOTAL=`free -k          |awk '          /^Swap/                            {print int($3/1024)}'`
echo  -e " df $TMPFS\t    smaps $PROCS \tSwapCache $SCACH\t| $TOTAL\tswap | diff $[TOTAL-TMPFS-PROCS-SCACH]\tMB"
