#!/bin/bash
FOLDER_TO_TRANSLATE="$1"
LANGUAGE_FOLDER="$2"
POT_FILE="$3"
DOMAIN="$4"
PO_FILES="$5"
STRING_TO_PREPEND_TO_JSONS="$6"
BRANCH="$7"

cd "$FOLDER_TO_TRANSLATE"
echo "Checking out to $BRANCH"
git checkout $BRANCH

echo "Generating $FOLDER_TO_TRANSLATE/$LANGUAGE_FOLDER/$POT_FILE"
wp i18n make-pot . "$LANGUAGE_FOLDER/$POT_FILE" --domain=$DOMAIN

readarray -d ";" -t PO_FILES_ARRAY <<<"$PO_FILES" 

echo "Removing all JSONs on $FOLDER_TO_TRANSLATE/$LANGUAGE_FOLDER"
rm -rf "$LANGUAGE_FOLDER"/*.json
for PO_FILE in "${PO_FILES_ARRAY[@]}"
do
   : 
	 echo "Updating $PO_FILE from $FOLDER_TO_TRANSLATE/$LANGUAGE_FOLDER/$POT_FILE"
	 msgmerge --backup=off -U $LANGUAGE_FOLDER/$PO_FILE $LANGUAGE_FOLDER/$POT_FILE
	 echo "Generating JSONs from $FOLDER_TO_TRANSLATE/$LANGUAGE_FOLDER/$PO_FILE"
	 wp i18n make-json $LANGUAGE_FOLDER/$PO_FILE --no-purge
	 
	 if [ ! -z "$STRING_TO_PREPEND_TO_JSONS" ]; then
		 
		 echo "Prepending $STRING_TO_PREPEND_TO_JSONS to all JSONs"
		 TRIMMED_PO_FILE=$(echo -n $PO_FILE | tr -d '\n')
		 PO_FILE_NO_EXT=${TRIMMED_PO_FILE/.po/}
		 
		 ls $LANGUAGE_FOLDER/${PO_FILE_NO_EXT/.po/}-*.json |  xargs -I {} echo mv {} foo{} | sed "s#foo$LANGUAGE_FOLDER/#$LANGUAGE_FOLDER/$STRING_TO_PREPEND_TO_JSONS#" | bash
	 fi
done

if [[ `git status --porcelain` ]]; then
	git config --global user.name 'Github'
	git config --global user.email 'cannarocks@users.noreply.github.com'
	git commit -am "chore: add json lang generated files for submodule: $DOMAIN (ci skip)"
	git push
else
	echo 'Nothing to commit'
fi
