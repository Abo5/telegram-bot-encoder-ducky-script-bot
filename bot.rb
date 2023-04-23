system("ruby -v")
system("gem install telegram-bot-ruby base64 open-uri tempfile")
system("clear")
sleep(10)
require 'telegram/bot'
require 'base64'
require 'open-uri'
require 'tempfile'

token = '<your-token>'

Telegram::Bot::Client.run(token) do |bot|
bot.listen do |message|
  case message.text
  when '/start'
    question = 'Choose one of the options sir 🫡'
    # See more: https://core.telegram.org/bots/api#replykeyboardmarkup
    answers =
        Telegram::Bot::Types::ReplyKeyboardMarkup.new(
          keyboard: [
            [{ text: '/encode 🚀' }, { text: '/help 🆘' }],
            [{ text: 'our channel ℹ️' }, { text: 'about ducky script 💀' }],
          ],
          one_time_keyboard: true
        )
    bot.api.send_message(chat_id: message.chat.id, text: question, reply_markup: answers)
  when '/help 🆘'
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, welcome to the encode ducky script bot. If you want to encode a file, click /encode, send the file in .txt format, click /help for more information 😁")
  when 'our channel ℹ️'
      bot.api.send_message(chat_id: message.chat.id, text: 'https://t.me/u8wvu')
  when 'about ducky script 💀'
    bot.api.send_message(chat_id: message.chat.id, text: 'DuckyScript™ is the programming language of the USB Rubber Ducky™, Hak5® hotplug attack gear and officially licensed devices (Trademark Hak5 LLC. Copyright © 2010 Hak5 LLC. All rights reserved.)')
  when '/encode 🚀'
      bot.api.send_message(chat_id: message.chat.id, text: "Send me a .txt file and I'll encode it to a .bin file 🚀	")
  end
  if message.document
    if File.extname(message.document.file_name) == '.txt'
        file_id = message.document.file_id
        file_path_info = bot.api.get_file(file_id: file_id)
        file_path = file_path_info['result']['file_path']
        url = "https://api.telegram.org/file/bot#{token}/#{file_path}"
        content = URI.open(url).read
        decoded_content = Base64.encode64(content)

        temp_file = Tempfile.new(['injact', '.bin'])
        temp_file.binmode
        temp_file.write(decoded_content)
        temp_file.rewind

        bot.api.send_document(chat_id: message.chat.id, document: Faraday::UploadIO.new(temp_file.path, 'application/octet-stream', 'injact.bin'), caption: 'Here is your decoded .bin file enjoy! ✅')

        temp_file.close
        temp_file.unlink
    else
        bot.api.send_message(chat_id: message.chat.id, text: "Please send a .txt file ❌	")
    end
  end
end
