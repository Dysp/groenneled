require "sinatra/base"
require_relative "pages"

class App < Sinatra::Base
  helpers do
    def service_pages
      SERVICE_PAGES
    end

    def current_page?(path)
      request.path_info.delete_suffix("/") == path.delete_suffix("/")
    end
  end

  get "/" do
    erb :index
  end

  SERVICE_PAGES.each do |slug, page|
    get %r{/#{slug}/?} do
      @page = page
      @title = page[:title]
      @description = page[:description]
      erb :service
    end
  end

  get %r{/kontakt-os/?} do
    @title = "Kontakt os"
    @description = "Kontakt Grønneled Tømrerentreprise i Brøndby på 93 93 87 35 eller info@groenneled.dk. Få en uforpligtende snak om dit projekt."
    erb :contact
  end

  get %r{/cookie-politik/?} do
    @title = "Cookiepolitik"
    @description = "Information om cookies og eksterne tjenester på Grønneleds hjemmeside."
    erb :cookies
  end
end
