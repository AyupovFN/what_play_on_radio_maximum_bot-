class Song
  attr_reader :artist_song

  def initialize (artist_song)
    @artist_song = artist_song
  end

  def to_s
    "-- #{artist_song} --"
  end
end