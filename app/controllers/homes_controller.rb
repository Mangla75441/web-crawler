class HomesController < ApplicationController	
	require 'mechanize'
	require 'open-uri'

  def index
  	
  end

  def new

  end

  def create
  	 param_url = URI.parse(params[:url])
  	 if param_url.kind_of?(URI::HTTP) || param_url.kind_of?(URI::HTTPS)
  	 		SitemapGenerator::Sitemap.default_host = params[:url]
  	 else
  	 		flash[:error] = "please provide http or https"
  	 		return	redirect_to root_path 
  	 end
  	 		
		SitemapGenerator::Sitemap.create do
			# binding.pry
  		agent = Mechanize.new
    	page = agent.get(SitemapGenerator::Sitemap.default_host)
    	url = page.uri.to_s
    	@links = page.links
    	@uniq_links =  @links.map { |link| link.href }.uniq.compact
			@uniq_links.each do |link|
				if link.present? && !(link == "/" || link.starts_with?("#") || link.include?("pdf"))
					url_encode = URI.encode(link)
					unless url_encode.include?("tel") || url_encode.include?("mailto") 
						resolve_url = agent.resolve(url_encode).to_s.starts_with?(url)
					end
					if resolve_url.present?	
  					add("#{link}")
  				end
  			end
			end
		end
		output_file = File.open('app/views/homes/index.xml.erb', 'w')
		gz_extract = Zlib::GzipReader.open("public/sitemap.xml.gz")
		gz_extract.each_line do |extract|
  		output_file.write(extract)
		end
		output_file.close
		redirect_to "/generated_sitemap.xml"
  end
end
