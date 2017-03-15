require "sinatra"
require "sinatra/reloader" if development?
require 'sinatra/content_for'
require "tilt/erubis"

configure do
  enable :sessions
  set :session_secret, 'secret'
  set :erb, :escape_html => true
end

helpers do
  def todos_remaining(list)
    list[:todos].select {|todo| !todo[:completed]}.size
  end

  def list_complete?(list)
    todos_count(list) > 0 && todos_remaining(list) == 0
  end

  def list_class(list)
    list_complete?(list) ? "complete" : "new"
  end

  def todos_count(list)
    list[:todos].size
  end

  def sort_lists(lists, &block)
    incomplete_lists, complete_lists = lists.partition { |list| list_complete?(list) }

    complete_lists.each{ |list| yield(list, lists.index(list))}
    incomplete_lists.each{ |list| yield(list, lists.index(list))}
  end

  def sort_todos(todos, &block)
    incomplete_todos, complete_todos = todos.partition {|todo| todo[:completed] }

    complete_todos.each{ |todo| yield(todo, todos.index(todo))}
    incomplete_todos.each{ |todo| yield(todo, todos.index(todo))}
  end

  def load_list(index)
    list = session[:lists][index] if index
    return list if list

    session[:fail] = "The specified list was not found."
    redirect "/lists"
  end
end

before do
  session[:lists] ||= [] 
end

get "/" do
  redirect "/lists"
end

# view all lists
get "/lists" do
  @lists = session[:lists]
  erb :lists, layout: :layout
end

# renders the new list form
get "/lists/new" do
  erb :new_list, layout: :layout
end

# creates a new list
post "/lists" do
  list_name = params[:list_name].strip
  error = error_for_list_name(list_name)
  if error
    session[:fail] = error
    erb :new_list, layout: :layout
  else
    session[:lists] << {
    name: list_name,
    todos: []
  }
    session[:success] = "The list has been created."
    redirect "/lists"
  end
end

# return the error message for invalid list_name inputs
def error_for_list_name(name)
  if !(1..100).cover?(name.size) 
    "The list name must be between 1 and 100 chars."
  elsif session[:lists].any? {|list| list[:name] == name}
    "The list name must be unique"
  end
end

get "/lists/:id" do
  @list_id = params[:id].to_i
  @list = load_list(@list_id)
  erb :current_list
end

# edit existing todo list
get "/lists/:id/edit" do
  @list = session[:lists][params[:id].to_i]
  erb :edit_list, layout: :layout
end

post "/lists/:id" do
  list_name = params[:list_name].strip
  id = params[:id].to_i
  @list = session[:lists][id]

  error = error_for_list_name(list_name)
  if error
    session[:fail] = error
    erb :edit_list, layout: :layout
  else
    @list[:name] = list_name
    session[:success] = "The list has been updated"
    redirect "/lists/#{id}"
  end
end

# delete todo list
post "/lists/:id/delete" do
  id = params[:id].to_i
  session[:lists].delete_at(id)
  session[:success] = "The list has been deleted"
  redirect "/lists"
end

def error_for_todo(name)
  if !(1..100).cover?(name.size) 
    "The todo name must be between 1 and 100 chars."
  end
end

# add new todo to the list
post "/lists/:list_id/todos" do
  @list_id = params[:list_id].to_i
  @list = load_list(@list_id)
  todo_name = params[:todo_name].strip
  
  error = error_for_todo(todo_name)
  if error
    session[:fail] = error
    erb :current_list, layout: :layout
  else
    @list[:todos] << {name: todo_name, completed: false}
    session[:success] = "The todo was added."
    redirect "/lists/#{@list_id}"
  end
end

# delete todo item from current todo list
post "/lists/:list_id/todos/:item/delete" do
  @list_id = params[:list_id].to_i
  @item_id = params[:item].to_i
  @list = load_list(@list_id)

  @list[:todos].delete_at(@item_id)
  session[:success] = "Todo item has been deleted"
  redirect "/lists/#{@list_id}"
end

# complete todo item from current todo list

post "/lists/:list_id/todos/:item/complete" do
  @list_id = params[:list_id].to_i
  @item_id = params[:item].to_i
  @list = load_list(@list_id)
  is_completed = params[:completed] == "true"
  @list[:todos][@item_id][:completed] = is_completed
  session[:success] = "Todo list has been updated"
  redirect "/lists/#{@list_id}"
end

# complete all todo items from current todo list
post "/lists/:id/complete_all" do
  @list_id = params[:id].to_i
  @list = load_list(@list_id)

  @list[:todos].each {|todo| todo[:completed] = true}

  session[:success] = "All todos have been completed"
  redirect "/lists/#{@list_id}"
end
