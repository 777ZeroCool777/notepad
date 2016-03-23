# encoding: utf-8
# Тестовый сценарий для класса "Post" на базе RSpec

# подключаю библиотеку RSpec
require 'rspec'

# подключаю post
require '../post.rb'

describe 'Post' do

  # Сценарий для метода to_db_hash класса Post
  it 'should do ok for to_db_hash' do
    post = Post.new # создаю экземпляр класса Post
    created_at = Time.now.to_s # текущее время преобразованное в строку

    # метод должен возращать для 'type' - имя класса,
    # для 'created_at' - текущее время преобразованное в строку
    expect(post.to_db_hash).to eq "type" => "Post",\
    "created_at" => created_at
  end
end