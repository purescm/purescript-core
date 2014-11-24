module.exports = function(grunt) {

  "use strict";

  grunt.initConfig({ 
  
    libFiles: [
      "src/**/*.purs",
      "bower_components/purescript-*/src/**/*.purs",
    ],
    
    clean: ["output"],
  
    pscMake: ["<%=libFiles%>"],
    dotPsci: ["<%=libFiles%>"],
    docgen: {
        readme: {
            src: "src/**/*.purs",
            dest: "README.md"
        }
    },
    jsvalidate: {
      options:{
        globals: {},
        esprimaOptions: {},
        verbose: false
      },
      targetName:{
        files:{
          src:["output/**/*.js"]
        }
      }
    }
  });

  grunt.loadNpmTasks("grunt-contrib-clean");
  grunt.loadNpmTasks("grunt-purescript");
  grunt.loadNpmTasks('grunt-jsvalidate');
  
  grunt.registerTask("make", ["pscMake", "jsvalidate", "dotPsci", "docgen"]);
  grunt.registerTask("default", ["make"]);
};
