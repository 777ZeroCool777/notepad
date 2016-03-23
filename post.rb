# encoding: utf-8
# Программа "Блокнот" v. 2 (хранение данных в sqlite)

require 'sqlite3'
require 'time'

# Базовый класс "Запись"
# Задает основные методы и свойства, присущие всем разновидностям Записи
class Post

  # создаю статическое поле класса
  @@SQLITE_DB_FILE = 'notepad.sqlite'

  # updated in v. 2
  # теперь нужно будет читать объекты из базы данных
  # будет удобно всегда иметь под рукой связь между классом и его именем в виде строки
  def self.post_types
    {'Memo' => Memo, 'Task' => Task, 'Link' => Link, 'Tweet' => Tweet}
  end

  # updated in v. 2
  # Параметром теперь является строковое имя нужного класса
  def self.create(type)
    return post_types[type].new
  end

  # new in v. 2
  # Находит в базе запись по идентификатору или массив записей из базы данных, который можно например показать в виде таблицы на экране
  def self.find(limit, type, id)
    db = SQLite3::Database.open(@@SQLITE_DB_FILE) # открываю "соединение" к базе SQLite

    unless id.nil?
      db.results_as_hash = true # настройка соединения к базе, он результаты из базы преобразует в Руби хэши
      # выполняю наш запрос, он возвращает массив результатов, в данном случае из одного элемента
      result = db.execute("SELECT * FROM posts WHERE  rowid = ?", id)
      # получаю единственный результат (если вернулся массив)
      result = result[0] if result.is_a? Array
      db.close

      if result.empty?
        puts "Такой id #{id} не найден в базе :("
        return nil
      else
        # создаю с помощью метода create экземпляр поста,
        # тип поста взят из массива результатов [:type]
        post = create(result['type'])

        #   заполняю этот пост содержимым
        post.load_data(result)

        # и возвращаю его
        return post
      end

      #   эта ветвь выполняется если не передан идентификатор
    else

      db.results_as_hash = false # настройка соединения к базе, он результаты из базы НЕ преобразует в Руби хэши

      # формирую запрос в базу с нужными условиями
      query = "SELECT rowid, * FROM posts "

      query += "WHERE type = :type " unless type.nil? # если задан тип, надо добавить условие
      query += "ORDER by rowid DESC " # сортировка - самые свежие в начале

      query += "LIMIT :limit " unless limit.nil? # если задан лимит, надо добавить условие

      # готовим запрос в базу, как плов :)
      statement = db.prepare query

      statement.bind_param('type', type) unless type.nil?
      statement.bind_param('limit', limit) unless limit.nil?

      result = statement.execute! #(query) # выполняю
      statement.close
      db.close

      return result
    end
  end


  # конструктор
  def initialize
    @created_at = Time.now # дата создания записи
    @text = nil # массив строк записи — пока пустой
  end

  # Вызываться в программе когда нужно считать ввод пользователя и записать его в нужные поля объекта
  def read_from_console
    # todo: должен реализовываться детьми, которые знают как именно считывать свои данные из консоли
  end

  # Возвращает состояние объекта в виде массива строк, готовых к записи в файл
  def to_strings
    # todo: должен реализовываться детьми, которые знают как именно хранить себя в файле
  end

  # new in v. 2
  # должен вернуть хэш типа {'имя_столбца' -> 'значение'}
  # для сохранения в базу данных новой записи
  def to_db_hash
    {
        'type' => self.class.name,
        'created_at' => @created_at.to_s
    }
    #   todo: дочерние классы должны дополнять этот хэш массив своими полями
  end

  # new in v. 2
  # получает на вход хэш массив данных и должен заполнить свои поля
  def load_data(data_hash)
    @text = data_hash['text']
    @created_at = Time.parse(data_hash['created_at'])
    #   todo: остальные специфичные поля должны заполнить дочерние классы
  end

  # new in v. 2
  # Метод, сохраняющий состояние объекта в базу данных
  def save_to_db
    db = SQLite3::Database.open(@@SQLITE_DB_FILE) # открываю "соединение" к базе SQLite
    db.results_as_hash = true # настройка соединения к базе, он результаты из базы преобразует в Руби хэши

    # запрос к базе на вставку новой записи в соответствии с хэшом, сформированным дочерним классом to_db_hash
    db.execute(
        "INSERT INTO posts (" +
            to_db_hash.keys.join(', ') + # все поля, перечисленные через запятую
            ") " +
            " VALUES ( " +
            ('?,'*to_db_hash.keys.size).chomp(',') + # строка из заданного числа _плейсхолдеров_ ?,?,?...
            ")",
        to_db_hash.values # массив значений хэша, которые будут вставлены в запрос вместо _плейсхолдеров_
    )

    insert_row_id = db.last_insert_row_id

    # закрываю соединение
    db.close

    # возвращаю идентификатор записи в базе
    return insert_row_id
  end

  # Записывает текущее состояние объекта в файл
  def save
    file = File.new(file_path, "w:UTF-8") # открываю файл на запись

    for item in to_strings do # прохожу по массиву строк, полученных из метода to_strings
      file.puts(item)
    end

    file.close # закрываю
  end

  # Метод, возвращающий путь к файлу, куда записывать этот объект
  def file_path
    # Сохраняю в переменной current_path место, откуда была запущена программу
    current_path = File.dirname(__FILE__)

    # Получаю имя файла из даты создания поста метод strftime формирую строку типа "2014-12-27_12-08-31.txt"
    file_name = @created_at.strftime("#{self.class.name}_%Y-%m-%d_%H-%M-%S.txt")
    # (%S) — обеспечит уникальность имени файла

    return current_path + "/" + file_name
  end
end