# encoding: utf-8
# Тестовый сценарий для класса Memo на базе RSpec

# подключаю RSpec
require 'rspec'

# подключаю post и memo
require '../lib/post.rb' # (Родительский класс) нужен для работы с классом Memo
require '../lib/memo.rb'

describe 'Memo' do

  # объявляю переменную memo - в ней будет класс Memo
  let(:memo) {Memo.new}

  # обновляю поля заметки
  before(:each) do
    memo.load_data({'text' => 'Хорошая заметка', 'created_at' => '23.06.2016, 00:43'})
  end

  # сценарий для метода to_db_hash
  it 'to_db_hash return memo, text and url' do

    # получаю асоциативный массив для заметок методом to_db_hash
    memo_hash = memo.to_db_hash

    # проверяю поля
    expect(memo_hash['type']).to eq 'Memo'
    expect(memo_hash['created_at']).to eq '2016-06-23 00:43:00 +0300'
    expect(memo_hash['text']).to eq 'Хорошая заметка'
  end

  # Сценарий для метода to_strings
  it "to_string should return memo string array" do

    memo_string = memo.to_strings

    # должно вернуть дату создания (и 2 отступа ;) и текст заметки
    expect(memo_string[0]).to eq "Создано: 2016.06.23, 00:43:00 \n\r \n\r"
    expect(memo_string[1]).to eq 'Хорошая заметка'
  end
end