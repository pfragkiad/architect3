#!/bin/bash
GEM5ToMcPAT_PY="./Scripts/GEM5ToMcPAT.py"
GEM5ToMcPAT_XML_TEMPLATE="./mcpat/ProcessorDescriptionFiles/inorder_arm.xml"
GEM5ToMcPAT_DIR="./mcpat/mcpat"

usage="Usage: bash $(basename "$0") {-h | in [out]}
Read directories from in argument (directory of stats.txt and config.json)
and generate the outputs xml with names of directoris of stats.txt files
using pythnos script $GEM5ToMcPAT_PY and xml template $GEM5ToMcPAT_XML_TEMPLATE:
Erros in GEM5ToMcPAT_errors.txt

    -h    display this help and exit
    in    positional argument: input directory of Gem5 results,
          Gem5 stats can be in subdirectories
    [out] optional positional arguments:
                output result directory or
                output result directory + output McPAT directory. In this case must exist $GEM5ToMcPAT_DIR"

error="ERROR: wrong arguments
Try 'bash $(basename "$0") -h' for more information."

if [[ ! -f "$GEM5ToMcPAT_PY" ]]; then
    echo "$error"
  echo "$GEM5ToMcPAT_PY not exist"

  exit 1
fi


if [[ $# < 1 ]]; then
    echo "$error"
    exit 1
fi

if [[ ! -f "$GEM5ToMcPAT_XML_TEMPLATE" ]]; then
    echo "$error"
  echo "$GEM5ToMcPAT_XML_TEMPLATE not exist"

  exit 1
fi

if [[ $1 = "-h" ]]; then
    echo "$usage"
    exit 0
fi

output_dir="statsToXML"

if [[ $2 != "" ]]; then
    output_dir="$2"
fi

results_dir="$1"

if [[ ! -d "$results_dir" ]]; then
  echo "$error"
  echo "$results_dir not exist"
  exit 1
fi


stats_files=($(find $results_dir -iname "stats.txt"))
config_files=($(find $results_dir -iname "config.json"))

if [ "$stats_files" = "" ]; then
  echo "Error in $results_dir there is files named stats.txt"
  exit 1
fi

if [ "$config_files" = "" ]; then
  echo "Error in $results_dir there is files named config.json"
  exit 1
fi

if [ "${#config_files[*]}" != "${#stats_files[*]}" ]; then
  echo "Error in $results_dir some files is missing"
  exit 1
fi

mkdir -p $output_dir
chmod +x ./Scripts/GEM5ToMcPAT.py

for (( i = 0; i < ${#stats_files[*]}; i++ )); do
  echo "Convert directory "$(basename $(dirname ${stats_files[$i]}))
  $GEM5ToMcPAT_PY ${stats_files[$i]}  ${config_files[$i]} $GEM5ToMcPAT_XML_TEMPLATE -o $output_dir/$(basename $(dirname ${stats_files[$i]})).xml >> GEM5ToMcPAT_errors.txt
done

if [[ "$3" != "" ]]; then
  if [[ ! -f "$GEM5ToMcPAT_DIR" ]]; then
    echo "$error"
    echo "$GEM5ToMcPAT_DIR not exist"
    exit 1
  fi
  mcpat_out=$3
  mkdir -p $mcpat_out
  for (( i = 0; i < ${#stats_files[*]}; i++ )); do
    echo "Run in mcpat $(basename $(dirname ${stats_files[$i]})).xml"
    $GEM5ToMcPAT_DIR -infile $output_dir/$(basename $(dirname ${stats_files[$i]})).xml -print_level 1 > ./$mcpat_out/$(basename $(dirname ${stats_files[$i]})).txt
  done
fi
