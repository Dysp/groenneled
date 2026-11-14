# Grønneled

En dansk præsentationsside for Grønneled Tømrerentreprise ApS, bygget med Sinatra og Tailwind CSS.

## Kom i gang

```sh
bundle install
npm install
npm run build:css
bundle exec rackup
```

Åbn <http://localhost:9292>. Under udvikling kan `npm run watch:css` genbygge CSS ved ændringer. Kontaktknapperne åbner telefon eller e-mail; siden gemmer eller sender ikke formularbeskeder.

Tekster, kontaktoplysninger og billeder er hentet fra den eksisterende hjemmeside. Kontrollér indhold og billedrettigheder inden offentliggørelse.

## Undersider

De fem ydelsessider findes på `/terrasse-tilbygning/`, `/gulv-loft/`, `/kokken/`, `/tag/` og `/total-entrepriser-renoveringer/`. Derudover findes `/kontakt-os/` og `/cookie-politik/`. Adresserne virker med og uden afsluttende skråstreg.

Ydelsesteksterne er tilpasset fra den eksisterende hjemmeside og samlet i `pages.rb`. Fælles navigation og footer ligger i `views/header.erb` og `views/footer.erb`. Den tidligere cookie-side var tom; den nye beskriver denne hjemmesides brug af eksterne tjenester.

Hver ydelsesside bruger `image` og `image_alt` i `pages.rb` til sit hero-billede. De bruger også `hero_video: "/videos/groenneledplaceholder.mp4"` som fælles hero-video. Videoen afspilles lydløst i loop, og sidens billede bruges som poster og fallback. Skift `hero_video` på en side for at bruge en anden MP4 fra `public/videos/`. MP4 med H.264 anbefales for bred browserunderstøttelse; brug gerne 16:9, 1080p, uden lyd og hold filen kort og komprimeret.

Kør `bundle exec ruby test/pages_test.rb` for at kontrollere sider, navigation, billeder og interne ankerlinks.
