module PartiesHelper
  def random_party_name
    "#{adjectives.sample}-#{genres.sample}-#{SecureRandom.uuid[0, 5]}"
  end

  def adjectives
    %w(
      8-bit a-capella acid ambient alternative art baroque celtic chill choral
      classic college crossover crunk deep death downtempo electric electro
      experimental experimental folk gangsta goth hard hard-core smooth chamber
      indie industrial lo-fi modern modern technical trip tropical vocal
    )
  end

  def genres
    %w(
      americana bebop bluegrass blues breakbeat breakcore chant chiptune classical
      country crunk dance dance doo-wop dubstep easy-listening edm folk garage
      glitch-hop hip-hop house house jams jazz jungle latin lounge metal
      minimalism opera outlaw-country pop punk punk rap rap reggae rhythm-and-bass
      rock rock singer-songwriter ska soundtrack speedcore swing techno trance
      trap world
    )
  end
end
