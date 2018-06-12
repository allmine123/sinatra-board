#sinatra를 사용할거야
#sinatra를 계속 새로고침 (reload)
gem 'json', '~> 1.6' #c9에서만 나는 에러
require 'sinatra'
require "sinatra/reloader"
require 'data_mapper' # metagem, requires common plugins too.

#datamapper 로그 찍기
DataMapper::Logger.new($stdout, :debug)
# need install dm-sqlite-adapter
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog.db")

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

before do
   p '***************************************'
   p params
   p '***************************************'
end

#'/' 경로로 오면 index.html 파일을 보내줘
get '/' do
   send_file 'views/index.html' 
end

#'/lunch' 경로로 오면 @lunch.sample을 erb에서 보여줘
get '/lunch' do
@lunch = ["20층", "편의점", "순대국밥", "짜장면"]
erb :lunch
end

#게시글을 모두 보여주는 곳
get '/posts' do
    @posts = Post.all.reverse
    @posts = Post.all(order: [:id.desc])
    erb :'posts/posts'
end

#게시글을 쓸 수 있는 곳
get '/posts/new' do
    erb :'posts/new'
end

get '/posts/create' do
    @title = params[:title]
    @body = params[:body]
    Post.create(title: @title, body: @body)
   erb :'posts/create' 
end

#CRUD - Read
#variable routing을 통해 특정한 게시글을 가져온다.
get '/posts/:id' do
    @id = params[:id]
    @post = Post.get(@id)
    erb :'posts/show'
end

#CRUD - Delete
get '/posts/destroy/:id' do
    @post = Post.get(params[:id]).destroy
    #erb :'posts/destroy'
    redirect '/posts'
end

#CRUD - Update
get '/posts/edit/:id' do
    @id = params[:id]
    @post = Post.get(@id)
    erb :'posts/edit'
end

get '/posts/update/:id' do
    @id = params[:id]
    Post.get(@id).update(title: params[:title], body: params[:body])
    @post = Post.get(@id)
    redirect '/posts/'+@id
end