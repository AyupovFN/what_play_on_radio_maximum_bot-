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
    "#{artist} #{song}"
  end
end

token = ENV['TELEGRAM_BOT_API_KEY']

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
    when '/stop'
      bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
    end
  end
end

