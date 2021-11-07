# Задание 
Нужно написать Rails API приложение с таким списком endpoints:
1. POST /urls - должен возвращать короткий url
2. GET /urls/:short_url - должен возвращает длинный URL и увеличивать счетчик запросов на 1
3. GET /urls/:short_url/stats - должен возвращать счетчик для этого URL

Проект необходимо реализовать на Ruby on Rails и покрыть тестами на RSpec. Ответ нужно прислать ссылкой на репозиторий
## Ход выполнения работы
### 1. Для начала было необходимо проверить установленны ли  все компонетны для успешной работы Rails
```
C:\Users\Nick Smirnov>ruby --version
ruby 3.0.2p107 (2021-07-07 revision 0db68f0233) [x64-mingw32]

C:\Users\Nick Smirnov>sqlite3 version
SQLite version 3.30.0 2019-10-04 15:03:17
Enter ".help" for usage hints.

C:\Users\Nick Smirnov>node --version
v16.13.0

C:\Users\Nick Smirnov>yarn --version
1.22.17

C:\Users\Nick Smirnov>rails --version
Rails 6.1.4.1
```
### 2. Создание проекта
Пропишем команду 
```
rails new blog
```
Перейдем в каталог blog
```
cd /blog
```
Теперь мы можем запустить наш собственный сервер, и увидим 
```
ruby bin/rails server
```
![image](https://user-images.githubusercontent.com/57058926/140607665-1261f9af-5992-41a8-a4c1-f0b54dfe70cc.png)

### 3. MVC
MVC - это шаблон проектирования, разделяющий ответственности приложения для его упрощения. Rails по соглашению следует этому шаблону проектирования. Для генерации модели используем команду и это создат несколько файлов
```
bin/rails generate model Article title:string body:text
```
```
invoke  active_record
create    db/migrate/<timestamp>_create_articles.rb
create    app/models/article.rb
invoke    test_unit
create      test/models/article_test.rb
create      test/fixtures/articles.yml
```
Мы будем использовать два файла из них это _create_articles.rb и app/models/article.rb
Содержимое данного файла миграции будет 
```
class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
``` 
Вызов create_table указывает на то, как должна быть сконструированна таблица articles. По умолчанию метод create_table добавляет столбец id в качестве автоматически увеличевающегося первичного ключа. Таким образом в таблице будет id 1, а у следующей записи 2 и т.д

В блоке были добавлены два столбца title, body. Они были добавлены генератором, так как мы включили их в команду генерации.

В последней строчке блока вызывается t.timestamps. Этот метод определяет два дополнительных столбца с именами created_at и updated_at. Как увидите, Rails позаботится о них. устанавливая значения при создании или обновлении объекта модели.
####Запустим нашу миграцию
```
$ bin/rails db:migrate
```
Эта команда выведет, что таблица была создана
==  CreateArticles: migrating ===================================
-- create_table(:articles)
   -> 0.0018s
==  CreateArticles: migrated (0.0018s) ==========================
### 4. Использование модели для взаимодействия с базой данных
Запустим консоль с помощью команды и увидим интерфейс irb
```
ruby bin/rails console
```
```
Loading development environment (Rails 7.0.0)
irb(main):001:0>
```
в этом интерфейсе можно инициализоровать объект Article, но важно помнить, что мы только инициализируем этот объект, он не сохранен в базе данных. Для его сохранения необходимо вызвать save
```
irb> article = Article.new(title: "Hello Rails", body: "I am on Rails!")

irb> article.save
(0.1ms)  begin transaction
Article Create (0.4ms)  INSERT INTO "articles" ("title", "body", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["title", "Hello Rails"], ["body", "I am on Rails!"], ["created_at", "2020-01-18 23:47:30.734416"], ["updated_at", "2020-01-18 23:47:30.734416"]]
(0.9ms)  commit transaction
=> true
```
 Сохранение произошло успешно. Теперь если вызвать all то получим
![image](https://user-images.githubusercontent.com/57058926/140608308-33b71593-3bb4-4721-9041-e53db4b8ff6e.png)
### Отображение списка статей
Давайте вернемся к нашему контроллеру в app/controllers/articles_controller.rb и изменим экшн index, чтобы он извлекал все статьи из базы данных:
```
class ArticlesController < ApplicationController
  def index
    @articles = Article.all
  end
end
```
К переменным экземпляра контроллера можно получить доступ из вью. Это означает, что мы можем ссылаться на @articles в app/views/articles/index.html.erb. Давайте откроем этот файл и заменим его содержимое на:
```
<h1>Articles</h1>

<ul>
  <% @articles.each do |article| %>
    <li>
      <%= article.title %>
    </li>
  <% end %>
</ul>
```
Тут мы видим два типа тегов ERB: <% %> и <%= %>. Тег <% %> означает "вычислить заключенный код Ruby". Тег <%= %> означает "вычислить заключенный код Ruby и вывести значение, которое он возвратит". Все, что можно написать в обычной программе на Ruby, можно вложить в эти теги ERB.

Так как мы не хотим вывести значение, возвращаемое @articles.each, мы заключили этот код в <% %>. Но, поскольку мы хотим вывести значение, возвращаемое article.title (для каждой статьи), мы заключили этот код в <%= %>.

Окончательный результат можно увидеть, посетив http://localhost:3000. Вот что произойдет при этом:

Браузер сделает запрос: GET http://localhost:3000.
Rails автоматически отрендерит вью app/views/articles/index.html.erb.
Для выполнения запросов в браузере необходимо написать.

```
Rails.application.routes.draw do
  root "articles#index"

  #get "/articles", to: "articles#index"
  #get "/articles/:id", to: "articles#show"
  resources :articles
end
```
Rails предоставляет маршрутный метод resources, который связывает все общепринятые маршруты. Можно посмотреть, какие маршруты связаны, запустив команду bin/rails routes:
```
$ bin/rails routes
      Prefix Verb   URI Pattern                  Controller#Action
        root GET    /                            articles#index
    articles GET    /articles(.:format)          articles#index
 new_article GET    /articles/new(.:format)      articles#new
     article GET    /articles/:id(.:format)      articles#show
             POST   /articles(.:format)          articles#create
edit_article GET    /articles/:id/edit(.:format) articles#edit
             PATCH  /articles/:id(.:format)      articles#update

```
### 5 Создание новой страницы
Для создания новой страницы в rails традиционно обрабатываются экшнами контроллера new и create
```
class ArticlesController < ApplicationController
  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(title: "...", body: "...")

    if @article.save
      redirect_to @article
    else
      render :new, status: :unprocessable_entity
    end
  end
end

```
Экшн new инициализирует новую статью, но не сохраняет ее. Эта статья будет использована во вью при построении формы. По умолчанию экшн new будет рендерить app/views/articles/new.html.erb, которую мы создадим далее.

Экшн create инициализирует новую статью со значениями для заголовка и содержимого и пытается сохранить ее. Если статью успешно сохранена, экшн перенаправляет браузер на страницу статьи "http://localhost:3000/articles/#{@article.id}". Иначе экшн отображает форму заново.
### Результат
Теперь запустим наш сервер.
#### результат запроса будет GET /urls/:short_url 
Адрес http://127.0.0.1:3000/articles
![image](https://user-images.githubusercontent.com/57058926/140610738-187829f2-cbb8-464a-9e52-1e616919b8f6.png)
#### результат GET /urls/:short_url/stats - 
http://127.0.0.1:3000/articles/1
![image](https://user-images.githubusercontent.com/57058926/140610824-4fe90ae1-af79-4660-b330-3c5b79de0d48.png)
#### результат POST /urls
http://127.0.0.1:3000/articles/new
![image](https://user-images.githubusercontent.com/57058926/140610858-a59c5868-e8b3-4f92-964c-e08796397e7a.png)

## Тестирование на rspeс
Протестируем работу контроллера create для создания нового раздела.
```
require 'spec_helper'
require 'rails_helper'
require_relative 'C:/Users/Nick Smirnov/RoR/blog/app/controllers/articles_controller.rb'
describe ArticlesController < ApplicationController do
	describe '.create' do
		it 'sets the name' do
			articles = Article.new(title: 'Ruby_test', body: 'testing')
			
			expect(articles.title).to eq 'Ruby_test'
		end
  end

end

```
В этот тесте программа пробует создать новый элемент с названием Ruby_test и телом "testing"
пропишем команду
````
bundle exec rspec spec/articles_controller_spec.rb
````
И как результат увидим, что программа успешно прошла тест
![image](https://user-images.githubusercontent.com/57058926/140651751-307e612f-3b47-4c43-b996-9a68b24d9615.png)


