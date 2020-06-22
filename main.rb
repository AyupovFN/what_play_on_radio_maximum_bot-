require 'telegram/bot'
require 'dotenv/load'
require 'open-uri'
require 'oga'
require 'pry'

def take_song
  url = 'http://online-red.com/radio/playlist/Maximum.html'
  html = open(url)
  doc = Oga.parse_html(html)

  doc.css('.track').each do |m|
    artist_song = m.text.chomp
    @artist_song = Song.new(artist_song)
  end
  @artist_song
end

class Song
  attr_reader :artist_song

  def initialize (artist_song)
    @artist_song = artist_song
  end

  def to_s
    "-- #{artist_song} --"
  end
end

token = ENV['TELEGRAM_BOT_API_KEY']

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name} now play:
  #{take_song}")
    when '/stop'
      bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
    end
  end
end
