#!/bin/bash
# ファイル名をもとにExif を更新する
# Usage: $0 [Option] FILE
# ファイル名の形式： yyyyMMdd-hhmm.mp4
# Option: -v ... Debug情報を表示する
# Option: -l ... Exif 情報を表示する
# Option: -e ... 強制的に日付情報を更新する 

# 引数の数を確認
if [ $# = 0 ]; then
    echo "Usage: $0 [Option] FILE"
    exit 1
elif [ $# = 2 ]; then
    option=$1
    filepath=$2
else
    option=""
    filepath=$1
fi

# 拡張子を確認する
suffix=${filepath##*.}
filetypes=("mp4" "jpeg" "jpg" "JPEG")
supported=1
for v in "${filetypes[@]}"
do
    if [ ${v} = ${suffix} ]; then
        supported=0
        break
    fi
done
if [ ${supported} = 1 ]; then
    echo "Unsuppoted file type: ${suffix}"
    exit 1
fi

# 引数で指定されたファイルの存在確認
if [ ! -f "${filepath}" ]; then
    echo "file not found: ${filepath}"
    exit 1
fi
if [ "${option}" = "-v" ]; then
    echo "File name: ${filepath}"
fi    

# オプション：Exif の情報を出力する
if [ "${option}" = "-l" ]; then
    exiftool -g -s "${filepath}"
    exit 0
fi

# ファイル名の形式が yyyyMMdd-hhmm になっているか確認
filename=`basename "${filepath}" .mp4`
if [ `date "+%Y%m%d" -d ${filename:0:8} > /dev/null 2>&1; echo $?` -ne 0 ]; then
    echo "Invalid file name: ${filepath}"
    exit 1
fi
if [ `date "+%H%M" -d ${filename:9:4} > /dev/null 2>&1; echo $?` -ne 0 ]; then
    echo "Invalid file name: ${filepath}"
    exit 1
fi

# exif の日付フォーマットに変換する
printf -v newdate "%4s:%2s:%2s %2s:%2s" ${filename:0:4} ${filename:4:2} ${filename:6:2} ${filename:9:2} ${filename:11:2}
if [ "${option}" = "-v" ]; then
    echo "New Date: ${newdate}"
fi    

# exif 現在の "Create Date" を取得する 
currentdate=`exiftool -T -CreateDate "${filepath}"`
if [ "${option}" = "-v" ]; then
    echo "Current Date: ${currentdate}"
fi

# exif を更新する必要はない場合は何もせずに終了
if [ "${option}" != "-e" ] && [ "${newdate}" = "${currentdate}" ]; then
    echo "Do nothing: ${filename}"
    exit 0
fi

# update exif : CreateDate, DateTimeOriginal, ModifyDate, FileModifyDate
# exiftool -overwrite_original_in_place -alldates="${newdate}" -ModifyDate="${newdate}" -FileModifyDate="${newdate}" "${filepath}"

# update exif : CreateDate, DateTimeOriginal
echo exiftool -overwrite_original_in_place  -alldates="${newdate}" "${filepath}"
