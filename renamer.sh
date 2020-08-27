#!/bin/bash
 
# Batch renaming files via your sharpest tool - your text editor.
# Given a file pattern as argument renamer.sh opens $EDITOR
# with the selected files. Rename them in the editor, save
# and quit. You will be presented with the rename script
# so you can inspect what will happen when you continue.
# renamer.sh will do the renaming in two steps. First all
# files will be renamed to temporary names with increasing
# IDs. Then the renaming to the final name will be done.
# That way naming conflicts are avoided when one file will
# be renamed to the original name of another file.
# Note: For brevity the script to inspect will only show a
# single step renaming process.
 
RENAME_EDITOR="${VISUAL:-${EDITOR:-vi}}"
TMPFILE=/tmp/rename.sh.txt
OLD_FILES=`ls "$@"`
 
echo "$OLD_FILES"
 
echo "$OLD_FILES" > $TMPFILE
 
$RENAME_EDITOR $TMPFILE < `tty` > `tty`
 
OLD_NUMBER_OF_FILES=$((0 + `echo "$OLD_FILES" | wc -l`))
NEW_NUMBER_OF_FILES=$((0 + `wc -l $TMPFILE | awk '{print $1}'`))
 
if [[ $NEW_NUMBER_OF_FILES -ne $OLD_NUMBER_OF_FILES ]]; then
  echo "You should not delete line when editing. Old and new number of files should be the same."
  echo "Old number of files was ${OLD_NUMBER_OF_FILES}, new number of files is ${NEW_NUMBER_OF_FILES}."
  echo "bailing out."
  exit 1
fi
 
echo "Old number of files was ${OLD_NUMBER_OF_FILES}, new number of files is ${NEW_NUMBER_OF_FILES}."
 
NL=$'\n'
IFS=$NL
NEW_FILES=( $(cat ${TMPFILE}) )
RENAME_TO_TMP_COMMAND=''
RENAME_FROM_TMP_COMMAND=''
RENAME_COMMAND_CTL=''
 
i=0
for OLD_FILE in $OLD_FILES ; do
  NEW_FILE="${NEW_FILES[$i]}"
  let i=$(($i+1));
  if [[ "$OLD_FILE" != "$NEW_FILE" ]]; then
    RENAME_TO_TMP_COMMAND+="mv \"${OLD_FILE}\" __renamer.sh.tempfile.${i}${NL}"
    RENAME_FROM_TMP_COMMAND+="mv __renamer.sh.tempfile.${i} \"${NEW_FILE}\"${NL}"
    RENAME_COMMAND_CTL+="mv \"\033[1;31m${OLD_FILE}\033[0m\" \"\033[0;32m${NEW_FILE}\033[0m\"${NL}"
  fi
done
echo -e "$RENAME_COMMAND_CTL"
 
echo "Does this replace script look good to you?"
select yn in "Yes" "No"; do
  case $yn in
    # Yes ) echo "$RENAME_TO_TMP_COMMAND"; echo "$RENAME_FROM_TMP_COMMAND"; break;;
    Yes ) eval "$RENAME_TO_TMP_COMMAND"; eval "$RENAME_FROM_TMP_COMMAND"; break;;
    No ) exit;;
  esac
done
