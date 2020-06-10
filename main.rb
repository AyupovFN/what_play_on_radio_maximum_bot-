require 'telegram/bot'
require 'dotenv/load'
require 'open-uri'
require 'oga'
require 'pry'

def take_song
  url = 'https://maximum.ru/'
  html = open(url)
  doc = Oga.parse_html(html)

  doc.css('.track-animation').each do |m|
    artist = m.at_css('.artist').text
    song = m.at_css('.song').text

    @artist_song = Song.new(artist, song)
  end
  @artist_song
end

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

token = ENV['TELEGRAM_BOT_API_KEY']

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name} now play:
 -- #{take_song} --")
    when '/stop'
      bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
    end
  end
end
