# frozen_string_literal: true

xml.instruct! :xml, version: "1.0", encoding: "UTF-8"
xml.instruct! "xml-stylesheet", type: "text/xsl", href: "/sitemap.xsl"

xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
  xml.url do
    link = job_offers_url
    xml.loc(link)
    xml.lastmod(@job_offers.max_by(&:updated_at).updated_at.to_date)
    xml.changefreq("daily")
    xml.priority("0.8")
  end

  @job_offers.each do |entry|
    xml.url do
      link = job_offer_url(entry)
      xml.loc(link)
      xml.lastmod(entry.updated_at.to_date)
      xml.changefreq("daily")
      xml.priority("0.6")
    end
  end
end
