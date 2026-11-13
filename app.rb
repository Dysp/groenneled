require "sinatra/base"

class App < Sinatra::Base
  get "/" do
    erb :index
  end

  {
    "/terrasse-tilbygning/?" => "/#terrasse",
    "/gulv-loft/?" => "/#gulv",
    "/kokken/?" => "/#kokken",
    "/tag/?" => "/#tag",
    "/total-entrepriser-renoveringer/?" => "/#totalentreprise",
    "/kontakt-os/?" => "/#kontakt"
  }.each do |path, destination|
    get Regexp.new(path) do
      redirect destination, 301
    end
  end
end
