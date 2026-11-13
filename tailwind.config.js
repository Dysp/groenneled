/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ['./views/**/*.erb'],
  theme: {
    extend: {
      colors: {
        forest: '#173a2d',
        ink: '#1e2923',
        cream: '#f5f4ed',
        lime: '#d8e7ae',
        muted: '#6e786f'
      },
      fontFamily: {
        sans: ['Manrope', 'sans-serif'],
        display: ['"DM Sans"', 'sans-serif']
      }
    }
  },
  plugins: []
}
