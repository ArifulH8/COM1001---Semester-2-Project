get "/" do
  erb :index
end

get "/login" do
  erb :login  
end

get "/register" do
  @user = Users.new
  erb :register
end

post "/post-login" do
  email_u = params.fetch("email")
  password_u = params.fetch("password")
  # puts emailU
  # puts passwordU
  @user = Users.first(email: email_u, password: password_u)
  puts @user
  # if !user.empty?
  #     @foundUser = true
  #     @privilege = user.privilege
  #     if @privilege == "mentor"
  #         redirect "/mentorW"
  #     elsif @privilege == "mentee"
  #         redirect "/menteeW"
  #     else
  #         redirect "/admin"
  #     end
  # else
  #     @foundUser = false
  # end
  #s = "Welcome, #{user.name}. \n You have sucessfully logged in as a #{user.privilige.downcase}."
  #s
  @isLogged = false
  @privilige = @user.privilige
  #puts user.privilige
  if @privilige == "Mentee"
      @isLogged = true
      @id = @user.id
      puts @id
      redirect "/mentee?id=#{@id}"
  
  elsif @privilige == "Mentor"
    @isLogged = true
    redirect "/mentor"
  
  else 
      @isLogged = true
      redirect "/admin"
  end
end

post "/post-register" do
  puts params
  @user = User.new
  @user.load(params)
  if @user.valid?
    @user.save_changes
    redirect "/login"
  end

  erb :register
end