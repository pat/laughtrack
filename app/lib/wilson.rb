class Wilson
  attr_reader :positive, :total, :power

  def initialize(positive, total, power = 0.10)
    @positive, @total, @power = positive, total, power
  end

  # Taken from http://www.evanmiller.org/how-not-to-sort-by-average-rating.html
  # No, I don't understand it. I'm so very glad someone else had written the
  # function in Ruby already. I have cleaned it up a little, mind you.
  def lower_bound
    return 0 if total == 0

    (
      phat + dist_sq/(2*total) - dist * Math.sqrt((phat*(1-phat)+dist_sq/(4*total))/total)
    ) / (
      1+dist_sq/total
    )
  end

  private

  def dist
    @dist ||= Statistics2.pnormaldist(1-power/2)
  end

  def dist_sq
    @dist_sq ||= dist * dist
  end

  # Named as in p with a ^ (hat). Not phat as in fat.
  def phat
    @phat ||= 1.0 * positive/total
  end
end
