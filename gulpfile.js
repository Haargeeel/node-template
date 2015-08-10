var gulp = require('gulp')
  , jade = require('gulp-jade')
  , browserify = require('gulp-browserify')
  , stylus = require('gulp-stylus')
  , jshint = require('gulp-jshint')
  , rename = require('gulp-rename')
  , gulpsync = require('gulp-sync')(gulp)
  , fs = require('fs')

gulp.task('jade', function() {
  return gulp.src('lib/app/views/*.jade')
        .pipe(gulp.dest('build/views'))
})

gulp.task('browserify', function() {
  return gulp.src('lib/public/js/app.js')
        .pipe(browserify())
        .pipe(gulp.dest('build/public/js'))
})

gulp.task('stylus', function() {
  return gulp.src('lib/public/css/*.styl')
        .pipe(stylus({
          compress: true
        }))
        .pipe(gulp.dest('build/public/css'))
})

gulp.task('fonts', function() {
  return gulp.src('lib/public/fonts/*')
        .pipe(gulp.dest('build/public/fonts'))
})

gulp.task('server', function() {
  return gulp.src('lib/app/**/*.js')
         .pipe(jshint())
})

gulp.task('clean', function() {
  var oldestJS = {file: '', date: Date.now()}
  var oldestCSS = {file: '', date: Date.now()}
  var jsFiles = fs.readdirSync('build/public/js')
  if (jsFiles.length > 2) {
    jsFiles.forEach(function(file) {
      var ctime = fs.statSync('build/public/js/' + file).ctime
      if (file.match('^app.*') && ctime < oldestJS.date) {
        oldestJS = {file: file, date: ctime}
      }
    })
    fs.unlinkSync('build/public/js/' + oldestJS.file)
  }

  var cssFiles = fs.readdirSync('build/public/css')
  if (cssFiles.length > 2) {
    cssFiles.forEach(function(file) {
      var ctime = fs.statSync('build/public/css/' + file).ctime
      if (file.match('^style.*') && ctime < oldestCSS.date) {
        oldestCSS = {file: file, date: ctime}
      }
    })
    fs.unlinkSync('build/public/css/' + oldestCSS.file)
  }

})

gulp.task('rename', function() {
  var timestamp = Date.now()

  gulp.src('build/public/js/app.js')
  .pipe(rename('app' + timestamp + '.js'))
  .pipe(gulp.dest('build/public/js'))

  gulp.src('build/public/css/style.css')
  .pipe(rename('style' + timestamp + '.css'))
  .pipe(gulp.dest('build/public/css'))

  fs.readFile('build/views/layout.jade', 'utf8', function(err, str) {
    if (err) return console.log(err)
    var compiled = str.replace(/<%=(.+?)%>/g, timestamp)

    fs.writeFile('build/views/layout.jade', compiled, function(err) {
      if (err) return console.log(err)
    })
  })
})

gulp.task('sync', ['jade', 'browserify', 'stylus', 'fonts', 'server'])
gulp.task('async', ['rename'])

gulp.task('default', gulpsync.sync(['sync', 'rename', 'clean']))

gulp.task('watch', function() {
  gulp.watch('lib/public/**/*', ['default'])
})
