#!/bin/bash
stats=("Area"
      "Runtime_Dynamic"
      "Sunthreshold_Leakage"
      "Gate_Leakage")
usage="Usage: bash $(basename "$0") {-h  |  in [out]}
Read specific parameters from the McPAT results.txt power
and generate the output result based on the parameters
specified in the input file:
    -h    display this help and exit
    in    positional argument: input directory with McPAT results
    [out] optional positional argument: output results file"

error="ERROR: wrong arguments
Try 'bash read_results.sh -h' for more information."

if [[ $# < 1 ]]; then
    echo "$error"
    exit 1
fi

if [ $1 = "-h" ]; then
    echo "$usage"
    exit 0
fi

inDir="$1"
outFile="$2"

if [[ $outFile == "" ]]; then
  outFile="McPAT_results"
elif [[ condition ]]; then
  outFile="McPAT_results$outFile"
fi

if [[ ! -d "$inDir" ]]; then
  echo "$error"
  echo "$inDir not exist"
  exit 1
fi
echo "Search on $inDir"
McPAT_files=($(find $inDir -iname "*.txt"))

echo "$(basename $(dirname $McPAT_files[0])) | Area | Subthreshold Leakage | Gate Leakage | Runtime" > $outFile



for file in ${McPAT_files[*]}
do
  Area=$(sed -n '/Core:/{n;p}' $file  |  awk '$1 == "Area" {print $3}')
  Subthreshold_Leakage=$(sed -n '/Core:/{n;n;n;p}' $file  |  awk '$1 == "Subthreshold" {print $4}')
  Gate=$(sed -n '/Core:/{n;n;n;n;n;p}' $file  |  awk '$1 == "Gate" {print $4}')
  Runtime=$(sed -n '/Core:/{n;n;n;n;n;n;p}' $file  |  awk '$1 == "Runtime" {print $4}')

  echo "$(basename $(dirname $file))/$(basename $file) | $Area | $Subthreshold_Leakage | $Gate | $Runtime" >> $outFile
  echo "$(basename $(dirname $file))/$file $Area $Subthreshold_Leakage $Gate $Runtime"

done
