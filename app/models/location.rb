class Location < ActiveRecord::Base
  def loc_projected
    self.loc
  end
  def loc_projected=(value)
    self.loc = value
  end

  def loc_geographic
    FACTORY.unproject(self.loc)
  end
  def loc_geographic=(value)
    self.loc = FACTORY.project(value)
  end

  # w,s,e,n are in lat-long
  def self.in_rect(w, s, e, n)
    sw = FACTORY.point(w, s).projection
    ne = FACTORY.point(e, n).projection
    where("loc && geometry(polygon('#{sw.x},#{sw.y},#{ne.x},#{ne.y}'::box))")
  end
end
