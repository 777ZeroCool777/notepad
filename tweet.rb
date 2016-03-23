# encoding: utf-8
# Программа "Блокнот"

# подключаю библиотеку twitter
require 'twitter'

# Класс Твит, разновидность базового класса "Запись"
class Tweet < Post

  # конфигурируем твитер клиент согласно документации https://github.com/sferik/twitter/blob/master/examples/Configuration.md
  @@CLIENT = Twitter::REST::Client.new do |config|
    # ВНИМАНИЕ! Эти параметры уникальны для каждого приложения, вы должны
    # зарегистрировать в своем аккаунте новое приложение на https://apps.twitter.com
    # и взять со страницы этого приложения данные параметры!
    config.consumer_key = '___'
    config.consumer_secret = '_______'
    config.access_token = '______'
    config.access_token_secret = '______'
  end



  def read_from_console
    puts 'Новый твит (140 символов!):'
    @text = STDIN.gets.chomp[0..140]

    puts "Отправляем ваш твит: #{@text.encode('utf-8')}"
    @@CLIENT.update(@text.encode('utf-8'))
    puts 'Твит отправлен.'
  end

  # Массив из даты создания + тело твита
  def to_strings
    time_string = "Создано: #{@created_at.strftime('%Y.%m.%d, %H:%M:%S')} \n\r \n\r"

    #  добавляю в массив текста в начало строчку времени и возвращаю
    return [time_string, @text]
  end

  def to_db_hash
    # вызываю родительский метод ключевым словом super и к хэшу, который он вернул
    # присоединяю прицепом специфичные для этого класса поля методом Hash#merge
    return super.merge(
        {
            'text' => @text # твит
        }
    )
  end

# загружаю свои поля из хэш массива
  def load_data(data_hash)
    super(data_hash) # сперва дергаю родительский метод для общих полей

    # теперь прописываю свое специфичное поле
    @text = data_hash['text']
  end
end
