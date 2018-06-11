### Sinatra 정리

##### - 준비사항

필수 gem 설치

`$gem install sinatra`

`$gem install sinatra-reloader`



##### - 시작페이지 만들기

```ruby
#app.rb
require 'sinatra'
require 'sinatra-reloader'

get '/' do #routing '/'경로로 들어왔을 때
	send_file 'index.html'    #index.html 파일을 보내줘
end

get '/lunch' do #'/lunch'경로로 들어왔을 때
 erb :lunch # views 폴더 안에 있는 lunch.erb를 보여줘    
end
```



##### - 폴더 구조

- app.rb
- views/
  - .erb


##### - erb에서 루비코드 활용하기
```ruby
#app.rb
get '/lunch' do
    @lunch = ["바스버거"] #이 안에서만 사용가능함
    erb :lunch
end

```
```erb
<!-- lunch.erb -->
%= @lunch.sample %>를 먹자요!!
<a href="/">홈으로 가기</a>
```


##### - ORM : Object Relational-Mapper

객체지향언어(Ruby)와 데이터베이스(sqlite)의 연결을 도와주는 도구

Datamapper : http://recipes.sinatrarb.com/p/models/data_mapper

##### - 사전준비사항

`$gem install datamapper`

`$gem install dm-sqlite-adapter`



```ruby
#app.rb
#c9에서 json 라이브러리 충돌로 인한 코드
gem 'json','~>1.6'
require 'datamapper'

#sqlite blog.db세팅
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog.db")

#Post 객체 생성
class Post
  include DataMapper::Resource
  property :id, Serial
  property :title, String
  property :body, Text
  property :created_at, DateTime
end

# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
DataMapper.finalize

# automatically create the post table
Post.auto_upgrade!
```



##### - 데이터 조작

- 기본

  `Post.all`

- C(Create)

```ruby
#첫 번째방법
Post.create(title: "test", body: "test123")

#두 번째 방법
p = Post.new
p.title = "test"
p.body = "test123"
p.save #db에 작성
```

- R(Read)

  ```ruby
  Post.get(1) # get(id)
  Post.first
  Post.last
  ```

  

- U(Update)

```ruby
#첫 번째
Post.get(1).update(title: "test1", body: "test1")

#두 번째
p. Post.get(1)
p.title = "test2"
p.body="test2"
p.save
```

- D(Delete)

```ruby
Post.get(1).destroy
```