# encoding: utf-8
# Тестовый сценарий для класса Link на базе RSpec

# Подключаю библиотеку rspec
require 'rspec'

# Подключаю классы Post и Link
require_relative '../lib/post' # post неообходим для работы с link
require_relative '../lib/link'

describe 'Link' do
  # Первый тест будет проверять метод to_db_hash
  it 'to_db_hash return link text and url' do
    # Создаю новую ссылку и обновляю её поля методом load_data
    link = Link.new
    link.load_data({
      'text' => 'Хорошая ссылка',
      'url' => 'бла-бла-бла',
      'created_at' => '12.05.2015, 12:00'
    })

    # Теперь получаю ассоциативный массив ссылки методом to_db_hash
    link_hash = link.to_db_hash

    # Проверяю поля
    expect(link_hash['type']).to eq('Link')
    expect(link_hash['created_at']).to eq('2015-05-12 12:00:00 +0300')
    expect(link_hash['text']).to eq('Хорошая ссылка')
    expect(link_hash['url']).to eq('бла-бла-бла')
  end

  # Теперь проверяю работу метода to_strings
  it "to_strings should return link strings arra" do
    # Создадаю ссылку и прописываю её поля
    link = Link.new
    link.load_data({
      'text' => 'Хорошая ссылка',
      'url' => 'бла-бла-бла',
      'created_at' => '12.05.2015, 12:00'
    })

    # Получаю массив строк для ссылки
    link_strings = link.to_strings

    # Проверяю, что  в этом массиве то, что нужно
    expect(link_strings[0]).to eq('бла-бла-бла')

    # Потом должен идти текст описания
    expect(link_strings[1]).to eq('Хорошая ссылка')

    # И, наконец, последняя строка - информация о дате создания
    expect(link_strings[2]).to eq("Создано: 2015.05.12, 12:00:00 \n\r \n\r")
  end
end
