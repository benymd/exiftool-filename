# exiftool-filename

[ExifTool](https://exiftool.org) を使用して、ファイル名に基づき動画ファイルの作成日時を変更する。

Usage: exif_by_filename.sh [option] yyyyMMdd-HHmm.[mp4|jpg]
       exif_by_filenames.sh [option] directory

Option: -v ... 実行時の情報を出力する。
        -l ... 作成日時の変更は行わず、Exif 情報を表示する。
        -e ... 強制的に作成日時を変更する。（未指定の場合、変更が不要な場合は変更しない）

注）まだデバック中です。
