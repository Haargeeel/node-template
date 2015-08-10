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
echo "${NAME}" >> README.me
mkdir build
mkdir lib
cp -r "../node-template/config" "."
if [ -n "$DB" ];then
  cd config
  sed -i original "s/<#dbname>/${DB}/g" "development.js"
  sed -i original "s/<#dbname>/${DB}/g" "production.js"
  rm *original
  cd ..
fi
cd lib
mkdir app
mkdir public
cd app
mkdir controller
mkdir models
cp -r "../../../node-template/plugins" "."
cp -r "../../../node-template/views" "."
cd ..
cd public
mkdir css
cp "../../../node-template/style.styl" "css"
mkdir fonts
mkdir js
touch "js/app.js"
mkdir react
cp "../../../node-template/react_interface.jsx" "react"
cd ..
cd ..
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
npm install --save-dev gulp
npm install --save-dev gulp-browserify
npm install --save-dev gulp-jade
npm install --save-dev gulp-jshint
npm install --save-dev gulp-minify
npm install --save-dev gulp-rename
npm install --save-dev gulp-stylus
npm install --save-dev gulp-sync
npm install --save-dev gulp-uglify
npm install --save-dev gulp-watch
gulp
node "."