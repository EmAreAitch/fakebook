// // // // // const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',    
  ],
  theme: {
    extend: {
      fontFamily: {
// // // // //         sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ],
  safelist: [
    // Grid classes from grid_container helper
    { pattern: /grid-cols-([1-9]|1[0-2])/ },  // Handles grid-cols-1 through grid-cols-12
    
    // Column span classes from grid_item helper
    { pattern: /col-span-([1-9]|1[0-2])/ },   // Handles col-span-1 through col-span-12
    
    // Gap classes used in both grid_container and stack helpers
    { pattern: /gap-([0-9]|1[0-2])/ },        // Handles gap-0 through gap-12    
  ],

}
