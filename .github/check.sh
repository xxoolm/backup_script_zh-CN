
home="."

sed -i "/^若使用有问题/c 若使用有问题，请建立[issues](https://github.com/Petit-Abba/backup_script_zh-CN/issues)。\`$(date "+%Y-%m-%d %H:%M:%S")\`" "${home}/README.md"

A="`cat ${home}/message/record.md | awk 'END {print}'`"
B="`cat ${home}/message/record.md | awk 'END {print}'`"

version_list="`curl 'https://github.com/YAWAsau/backup_script/releases' -sL | grep "/YAWAsau/backup_script/releases/download" | awk -F 'href="' '{print $2}' | awk -F '"' '{print $1}'`"

for i in ${version_list}
do
  if [ "`cat ${home}/message/record.md | grep "${i}"`" == "" ]; then
    A="https://github.com${i}"
    echo "${A}" >> ${home}/message/record.md
    if [ ! -f "${home}/message/update_url" ]; then
      echo "${A}" > ${home}/message/update_url
    else
      echo "${A}" >> ${home}/message/update_url
    fi
  fi
done

echo "- 当前时间: $(date '+%Y-%m-%d %H:%M:%S')"
if [ "${A}" != "${B}" ]; then
  echo "- 可更新构建"
  tgas_name="$(echo ${A} | awk -F '/' '{print $8}')"
  echo "- 新标签: ${tgas_name}"
  echo "# $(date '+%Y-%m-%d %H:%M:%S')" > ${home}/message/update.md
  echo ""  >> ${home}/message/update.md
  echo "tgas_name=\"${tgas_name}\"" >> ${home}/message/update.md
  echo "ReleaseVersion=${tgas_name}" >> ${GITHUB_ENV} 
  echo "new_version=yes" >> ${GITHUB_ENV}
  for i in $(cat ${home}/message/update_url)
  do
    case ${i} in
      *agisk*)
        echo "- Magisk模块更新: $(echo ${i} | awk -F '/' '{print $9}')"
        echo ""  >> ${home}/message/update.md
        echo "Magisk_modules=\"$(echo ${i} | awk -F '/' '{print $9}')\"" >> ${home}/message/update.md
        echo ""  >> ${home}/message/update.md
        echo "Magisk_modules_url=\"${i}\"" >> ${home}/message/update.md
        ;;
      *.*.*) 
        echo "- 备份脚本更新: $(echo ${i} | awk -F '/' '{print $9}')"
        echo ""  >> ${home}/message/update.md
        echo "Backup_script=\"$(echo ${i} | awk -F '/' '{print $9}')\""  >> ${home}/message/update.md
        echo ""  >> ${home}/message/update.md
        echo "Backup_script_url=\"${i}\"" >> ${home}/message/update.md
        ;;
    esac
  done
  rm -rf ${home}/message/update_url
else
  echo "- 暂无新版更新"
fi
rm -rf ${home}/Release 1>/dev/null 2>&1
