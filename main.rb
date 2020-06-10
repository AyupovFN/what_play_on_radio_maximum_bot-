require 'telegram/bot'
require 'dotenv/load'
require 'open-uri'
require 'oga'
require 'pry'

class Song
  attr_reader :artist, :song

  def initialize (artist, song)
    @artist = artist
    @song = song
  end

  def to_s
    "#{artist} - #{song}"
  end
end

URL = 'https://maximum.ru/'
html = open(URL)
doc = Oga.parse_html(html)

doc.css('.track-animation').each do |m|
  artist = m.at_css('.artist').text
  song = m.at_css('.song').text

  @artist_song = Song.new(artist, song)
end

token = ENV['TELEGRAM_BOT_API_KEY']

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name} now play #{@artist_song}")
    when '/stop'
      bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
    end
  end
end
