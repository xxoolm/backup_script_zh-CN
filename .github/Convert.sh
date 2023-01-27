home="."
#home="${0%/*}"

run() {
  echo "==================[ Run: $2 ]==================="
  [ ! -d "${home}/zip" ] && echo "- 创建${home}/zip目录" && mkdir -p ${home}/zip
  echo "- 创建${home}/Download目录"
  mkdir -p ${home}/Download

  echo "- 将$2文件下载至${home}/Download目录"
  curl -o "${home}/Download/$2" "$1" -sL

  echo "- 查看${home}/Download/$2文件大小"
  ls -lh ${home}/Download/$2

  echo "- 创建${home}/$3目录"
  mkdir -p ${home}/$3

  echo "- 解压$2到${home}/$3目录"
  7za x ${home}/Download/$2 -o${home}/$3 -aoa

  echo "- 列出${home}/$3目录文件/文件夹"
  ls ${home}/$3

  echo "- 开始转换"
  # 转文件名为简体
  for file in `find ${home}/$3 -type f -name "*.sh" -or -name "*.zip"`
  do
    echo "${file}"
    mv "${file}" "$(echo "${file}" | opencc -c t2s)" 1>/dev/null 2>&1
  done

  # 转文件内容为简体
  for file_Content in `find ${home}/$3 -type f -name "*.md" -or -name "*.conf" -or -name "*.sh" -or -name "restore*" -or -name "update-binary" -or -name "toast" -or -name "log" -or -name "*Magisk*" -or -name "module.prop*" -or -name "*_*"`
  do
    echo "${file_Content}"
    chmod 777 ${file_Content}
    opencc -i ${file_Content} -c t2s -o ${file_Content} 1>/dev/null 2>&1
    chmod 777 ${file_Content}
  done
  echo "- 转换完成!"

  echo "- 压缩${home}/$3目录下所有文件/文件夹到${home}/zip/$2"
  #zip -r ${home}/zip/$2 ${home}/$3(辣鸡zip吃屁去！)
  7za a -tzip -r ${home}/zip/$2 ${home}/$3/*

  echo "- 查看${home}/zip/$2文件大小"
  ls -lh ${home}/zip/$2

  echo "- 移动$2文件到${home}/Release目录"
  mv ${home}/zip/$2 ${home}/Release

  rm -rf ${home}/Download/
  rm -rf ${home}/zip/
  rm -rf ${home}/$3/
  echo "==================[ END: $2 ]==================="
}

source ${home}/message/update.md
[ ! -d ${home}/Release ] && mkdir -p ${home}/Release

if [ ! -z "${Backup_script_url}" ]; then
  # run 链接 文件名 标签
  run "${Backup_script_url}" "${Backup_script}" "${tgas_name}"
fi

magisk_modules() {
  if [ ! -z "${Magisk_modules_url}" ]; then
    # run 链接 文件名 标签
    run "${Magisk_modules_url}" "${Magisk_modules}" "${tgas_name}"
  fi
  [ ! -z "${Magisk_modules}" ] && Magisk_name="[${Magisk_modules}](https://github.com/Petit-Abba/backup_script_zh-CN/releases/download/${tgas_name}/${Magisk_modules})" || Magisk_name="无"
  #sed -i "/| :----: | :----: | :----: | :----: |/a\\| $(date "+%Y/%m/%d %H:%M:%S") | ${tgas_name} | [${Backup_script}](https://github.com/Petit-Abba/backup_script_zh-CN/releases/download/${tgas_name}/${Backup_script}) | ${Magisk_name} |" "${home}/README.md"
}
magisk_modules

sed -i "/| :----: | :----: | :----: |/a\\| $(date "+%Y/%m/%d %H:%M:%S") | ${tgas_name} | [${Backup_script}](https://github.com/Petit-Abba/backup_script_zh-CN/releases/download/${tgas_name}/${Backup_script}) |" "${home}/README.md"

[ "$?" == "0" ] && echo "(&) 输出完成！"
