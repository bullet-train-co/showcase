const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  prefix: 'sc-',
  content: [
    './public/*.html',
    './app/{models,helpers}/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: defaultTheme.fontFamily.sans,
      },
    },
  },
  plugins: [
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
  ]
}
