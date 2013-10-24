module ApplicationHelper
	# Returns the full title on a per-page basis.
  def full_title(page_title)
  	base_title = "TWR-LFBI Almanac App v 0.1.1 (alpha)"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def greet_user()
  	time = Time.new
  	if time.hour > 14
  		"Bonsoir"
  	else
  		"Bonjour"
  	end
  end

  def helper_date()
  	time = Time.new.utc
	"#{["Dimanche","Lundi","Mardi","Mercredi","Jeudi","Vendredi","Samedi"][time.wday]} #{time.day} #{["Janvier","Février","Mars","Avril","Mai","Juin","Juillet","Août","Septembre",
	"Octobre","Novembre","Décembre"][time.month-1]} #{time.year} #{time.hour}:#{time.min} Z."
  end
end
