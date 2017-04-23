class Song < ActiveRecord::Base
  belongs_to :party

  def upvote
    self.score += 1
    save
  end

  def downvote
    self.score -= 1
    save
  end
end
