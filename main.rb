require 'telegram/bot'
require 'dotenv/load'
require 'open-uri'
require 'oga'
require 'pry'
require_relative 'song'

def take_song
  url = 'http://online-red.com/radio/playlist/Maximum.html'
  html = open(url)
  doc = Oga.parse_html(html)
  song_list = []

  doc.css('.track').each { |m| song_list  << m.text.chomp.split('\n') }
  Song.new(song_list.flatten.first)
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
