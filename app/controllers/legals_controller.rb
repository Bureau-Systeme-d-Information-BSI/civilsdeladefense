class LegalsController < ApplicationController

  def notice
    @page_title = "Mentions légales"
    render layout: "legals"
  end

  def tos
    @page_title = "Conditions générales d’utilisation"
    render layout: "legals"
  end

  def privacy
    @page_title = "Politique de confidentialité"
    render layout: "legals"
  end
end
