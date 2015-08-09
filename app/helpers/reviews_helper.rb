module ReviewsHelper
  def render_stars(value)
    output = ''
    if (1..5).include?(value.to_i)
      value.to_i.times { output += "\u2605"}
    end
    output
  end
end
