#!/bin/bash

CP=`pwd -P` #current path
NAME="" #name of the git repo
DB="" #name of the db
nextIsDB=false

function exit_usage {
  echo "Use ./build <name> [-db|--database DB]"
  exit 1
}

for arg;do
  if [ -z "$NAME" ];then
    NAME="$arg"
  elif [ "$arg" == "-db" ] || [ "$arg" == '--database' ];then
    nextIsDB=true
  elif $nextIsDB;then
    DB="$arg"
    nextIsDB=false
  fi
done

if [ -z "$NAME" ];then
  echo "no name specified"
  exit_usage
fi
if $nextIsDB;then
  echo "no database specified"
  exit_usage
fi

cd $CP
cd ..
mkdir $NAME
cp "node-template/index.js" "${NAME}"
cp "node-template/gulpfile.js" "${NAME}"
cp "node-template/.gitignore" "${NAME}"
cd $NAME
touch README.me
echo "${NAME}" >> README.md
mkdir build
cd build
mkdir public
mkdir views
cd public
mkdir js
mkdir css
cd ..
cd ..
cp -r "../node-template/lib" "."
cp -r "../node-template/config" "."
if [ -n "$DB" ];then
  cd config
  sed -i original "s/<#dbname>/${DB}/g" "development.js"
  sed -i original "s/<#dbname>/${DB}/g" "production.js"
  rm *original
  cd ..
fi
git init
npm init
npm install --save jade
npm install --save body-parser
npm install --save express
npm install --save mongodb
npm install --save nib
npm install --save path
npm install --save stylus
npm install --save superagent
npm install --save node-jsx
npm install --save react
npm install --save react-dom
npm install --save-dev gulp
npm install --save-dev gulp-browserify
npm install --save-dev gulp-react
npm install --save-dev gulp-jade
npm install --save-dev gulp-jshint
npm install --save-dev gulp-minify
npm install --save-dev gulp-rename
npm install --save-dev gulp-stylus
npm install --save-dev gulp-sync
npm install --save-dev gulp-uglify
npm install --save-dev gulp-watch
npm install --save-dev reactify
awk '/license/ {print; print "  \"browserify\": {";print "    \"transform\": ["; print "      \"reactify\""; print "    ]"; print "  },"; next}1' package.json >> package2.json
rm package.json
mv package2.json package.json
gulp
node "."
