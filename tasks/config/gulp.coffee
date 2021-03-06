gulp = require "gulp"
sass = require "gulp-sass"
concat = require "gulp-concat"
browserify = require "gulp-browserify"

buildConfig = require "../../config/buildConfig.coffee"

argv = require('minimist')(process.argv.slice(2))

module.exports =
  sass: ->
    gulp.src("#{buildConfig.dir.sass}/supersonic.scss")
      .pipe(sass())
      .pipe(concat("supersonic.css"))
      .pipe(gulp.dest("#{buildConfig.dir.dist}/css"))

  sassDocs: ->
    gulp.src("#{buildConfig.dir.sass}/ionicons/ionicons.scss")
      .pipe(sass())
      .pipe(concat("supersonic-icons.css"))
      .pipe(gulp.dest("#{buildConfig.dir.docsCSS}/"))

  fontsDocs: ->
    gulp.src("#{buildConfig.dir.fonts}/*")
      .pipe(gulp.dest("#{buildConfig.dir.docsFonts}/"))


  # TODO: This does in no way need to be a gulp task
  fonts: ->
    gulp.src("#{buildConfig.dir.fonts}/*")
      .pipe(gulp.dest("#{buildConfig.dir.dist}/fonts/"))

  # Only the core supersonic experience
  core: ->
    gulp.src("#{buildConfig.dir.src}/supersonic/core.coffee", read: false)
      .pipe(browserify(
        transform: ['coffeeify']
        extensions: ['.coffee']
      ))
      .pipe(concat 'supersonic.core.js')
      .pipe(gulp.dest "#{buildConfig.dir.dist}")

  # Core plus Angular modules
  bundle: ->
    gulp.src("#{buildConfig.dir.src}/supersonic.coffee", read: false)
      .pipe(browserify(
        transform: ['coffeeify']
        extensions: ['.coffee']
      ))
      .pipe(concat 'supersonic.js')
      .pipe(gulp.dest "#{buildConfig.dir.dist}")
