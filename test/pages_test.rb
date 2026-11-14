require "rack/mock"
require_relative "../app"

request = Rack::MockRequest.new(App)
paths = %w[
  /
  /terrasse-tilbygning/
  /gulv-loft/
  /kokken/
  /tag/
  /total-entrepriser-renoveringer/
  /kontakt-os/
  /cookie-politik/
]
responses = {}

paths.each do |path|
  response = request.get(path)
  raise "#{path}: expected 200, got #{response.status}" unless response.status == 200
  raise "#{path}: missing page heading" unless response.body.scan(/<h1\b/).size == 1
  %w[header main footer].each do |element|
    raise "#{path}: expected one #{element}" unless response.body.scan(/<#{element}\b/).size == 1
  end
  responses[path] = response.body

  next if path == "/"

  bare_response = request.get(path.delete_suffix("/"))
  raise "#{path}: slashless route differs" unless bare_response.status == 200 && bare_response.body == response.body
  raise "#{path}: missing active navigation" unless response.body.include?('aria-current="page"')
end

raise "Pages should have unique titles" unless responses.values.map { |body| body[/<title>(.*?)<\/title>/, 1] }.uniq.size == paths.size

SERVICE_PAGES.each do |slug, page|
  body = responses.fetch("/#{slug}/")
  source = %(<source src="#{page[:hero_video]}" type="video/mp4">)
  raise "#{slug}: missing configured hero video" unless body.include?(source)
  raise "#{slug}: missing image poster" unless body.include?(%(poster="#{page[:image]}"))
end

responses.each do |path, body|
  body.scan(/(?:href|src)="([^"]+)"/).flatten.each do |url|
    next unless url.start_with?("/", "#")

    destination, fragment = url.split("#", 2)
    destination = path if destination.empty?
    target = responses[destination] || request.get(destination).then do |response|
      raise "#{path}: broken local link #{url} (#{response.status})" unless response.status == 200
      response.body
    end
    if fragment && !target.include?("id=\"#{fragment}\"")
      raise "#{path}: missing anchor #{url}"
    end
  end
end

tag_page = SERVICE_PAGES.fetch("tag")
original_video = tag_page[:hero_video]
begin
  tag_page[:hero_video] = "/videos/tag.mp4"
  video_response = request.get("/tag/")
  raise "Tag page: missing hero video" unless video_response.body.include?('<video class="service-hero-video" autoplay muted loop playsinline')
  raise "Tag page: missing video source" unless video_response.body.include?('<source src="/videos/tag.mp4" type="video/mp4">')
  raise "Tag page: missing poster fallback" unless video_response.body.include?('poster="/images/tag.png"') && video_response.body.include?('<img src="/images/tag.png"')
ensure
  if original_video
    tag_page[:hero_video] = original_video
  else
    tag_page.delete(:hero_video)
  end
end

%w[/missing /tag/extra /prefix/tag/].each do |path|
  raise "#{path}: expected 404" unless request.get(path).status == 404
end

puts "Passed: all 8 pages, slashless routes, unique titles, shared layout, local links, images and anchors."
