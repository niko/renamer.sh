# renamer.sh

Batch renaming files via your sharpest tool - your text editor.

Given a file pattern as argument renamer.sh opens $EDITOR with the selected files. Rename them in the editor, save and quit. You will be presented with the rename script so you can inspect what will happen when you continue.

renamer.sh will do the renaming in two steps. First all files will be renamed to temporary names with increasing IDs. Then the renaming to the final name will be done. That way naming conflicts are avoided when one file will be renamed to the original name of another file.
Note: For brevity the script to inspect will only show a single step renaming process.
