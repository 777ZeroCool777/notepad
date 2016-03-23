# encoding: utf-8
# Программа "Блокнот" Версия 3.0, добавлен вид записи Твит, который автоматически постит себя в твитер
# Этот скрипт создает новые записи, чтением занимается другой скрипт

# XXX/ Этот код необходим только при использовании русских букв на Windows
if (Gem.win_platform?)
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end
# /XXX

# Подключаем класс Post и его детей
require_relative 'post.rb'
require_relative 'memo.rb'
require_relative 'tweet.rb'
require_relative 'link.rb'
require_relative 'task.rb'

# Вывожу приветствие)
puts "Привет, я блокнот версия 2, записываю новые записи в базу SQLite :)"

# Спрашивает, что надо записать
puts "Что хотите записать сегодня?"

# массив возможных видов Записи (поста)
choices = Post.post_types.keys
choice = -1

until choice >= 0 && choice < choices.size # пока юзер не выбрал правильно
  # вывожу заново массив возможных типов поста
  choices.each_with_index do |type, index|
    puts "\t#{index}. #{type}"
  end
  choice = gets.chomp.to_i
end

# выбор сделан, создаю запись с помощью статического метода класса Post
entry = Post.create(choices[choice])

# Прошу пользователя ввести пост
entry.read_from_console

# Сохраняю пост в базу данных
rowid = entry.save_to_db

puts "Запись сохранена в базе, id = #{rowid}"