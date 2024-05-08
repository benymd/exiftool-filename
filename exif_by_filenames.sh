#!/bin/bash
# ファイル名をもとにExif の日付を更新する
# Usage: $0 [Option] FILE¦DIR
# ファイル名の形式： yyyyMMdd-hhmm.mp4
# Option: -v : Debug情報を表示する
# Option: -l : Exif 情報を表示する
# Option: -e : 強制的に日付情報を更新する 

# 引数の数を確認
if [ $# = 0 ]; then
    echo "Usage: $0 [Options] Path"
    exit 1
fi

# 引数の数を確認
if [ $# = 0 ]; then
    echo "Usage: $0 [Options] FILE"
    exit 1
elif [ $# = 2 ]; then
    option=$1
    filepath=$2
else
    option=""
    filepath=$1
fi

# 引数で指定されたファイルの存在確認
if [ -f "${filepath}" ]; then
    exif_by_filename.sh $@
elif [ ! -e ${filepath} ]; then
    echo "file not found: ${filepath}"
    exit 1
fi

if [ "${option}" = "-v" ]; then
    echo "PATH: ${filepath}"
fi    

while read -r f; do

    fname=`basename "$f"`
    if [ ${fname:0:1} != "." ] ; then
        # ファイル一つ毎の処理
        #echo_args.sh -l "${f}"
        exif_by_filename.sh "${option}" "${f}"
    fi

done < <(find ${filepath} -name "*.mp4")
