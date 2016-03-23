# encoding: utf-8
# Тестовый сценарий для класса "Task" на базе RSpec

# Подключим библиотеку rspec
require 'rspec'

# Подключаю классы Post и Task (просто Task недостаточно, т.к. он наследуется от Post)
require_relative '../post'
require_relative '../task'

describe 'Task' do
  # # объявляю переменную task - в ней будет класс Memo
  let(:task) { Task.new }
  
  # Обновляю поля task перед каждым тестом
  before (:each) do
    task.load_data({
      'text' => 'Хорошая ссылка',
      'due_date' => '17.05.2016',
      'created_at' => '23.03.2016, 15:49'
    })
  end

  # Проверяю работу метода to_db_hash
  it 'to_db_hash return task text and url' do
    task_hash = task.to_db_hash

    expect(task_hash['type']).to eq('Task')
    expect(task_hash['created_at']).to eq('2016-03-23 15:49:00 +0200')
    expect(task_hash['text']).to eq('Хорошая ссылка')
    expect(task_hash['due_date']).to eq('2016-05-17')
  end

  # Проверяю работу метода to_strings
  it "to_strings should return task strings arra" do
    task_strings = task.to_strings

    expect(task_strings[0]).to eq('Крайний срок: 2016-05-17')
    expect(task_strings[1]).to eq('Хорошая ссылка')
    expect(task_strings[2]).to eq("Создано: 2016.03.23, 15:49:00 \n\r \n\r")
  end
end
