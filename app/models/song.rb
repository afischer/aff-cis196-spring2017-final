class Song < ActiveRecord::Base
  belongs_to :party

  def upvote
    self.score += 1
    save
    redirect_to @party, notice: 'Upvoted!'
  end

  def downvote
    self.score -= 1
    save
    redirect_to @party, notice: 'Downvoted!'
  end
end
