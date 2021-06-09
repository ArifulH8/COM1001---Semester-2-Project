get "/mentor" do
  # Get the id cookie. If there is one, then continue. If not, then redirect to login.
  @id = request.cookies.fetch("id", "0")
  redirect "/login" if @id == "0"
  @user = User.first(id: @id)

  # Display a personalised message upon a successful mentor login
  @s = "Welcome, #{@user.name}. \n You have sucessfully logged in as a #{@user.get_privileges.downcase}."
  @mentees = User.where(has_mentor: @user.id)
  @table_show = true unless @mentees.empty?
  if @user.has_mentor != 0
    @table_show2 = true
    @table_show = false
    @mentee = User.first(id: @user.has_mentee)
  end
  erb :mentor
end

get "/mentor-register" do
  # When a Mentor is registering, we should add extra info
  @id = request.cookies.fetch("id", "0")
  redirect "/login" if @id == "0"

  @user = User.first(id: @id)
  @dataset_is = dataset_ret_is
  @message = "Hello prospective mentor, #{@user.name}. Please input the details below!"
  erb :mentor_register
end

post "/post-mentor-register" do
  @id = request.cookies.fetch("id")
  @user = User.first(id: @id)

  # Get the info and add them to the user db record
  @user.title = Title.new.from_name(params.fetch("title", ""))
  @user.job_title = params.fetch("job_Title", "")
  @user.industry_sector = Industry_sector.new.from_name(params.fetch("industry_Sector", ""))
  @user.available_time = params.fetch("available_Time", "")
  @description = Description.new
  @description.load(params)
  @description.save_changes
  @user.description = @description.id
  @user.save_changes
  redirect "/mentor"
end

get "/view-mentee" do
  @id = request.cookies.fetch("id", "0")
  redirect "/login" if @id == "0"
  
  @mentee_id = params[:id]
  @mentee = User.first(id: @mentee_id)
  erb :view_mentee
end

post "/post-mentor-accept" do
  @id = request.cookies.fetch("id")
  @user = User.first(id: @id)
  @mentee_id = params.fetch("mentee_Id")
  @mentee = User.first(id: @mentee_id)
  decision = params.fetch("decision")
  puts decision

  # Constructs a notification email to inform user of their
  # acceptance / rejection
  case decision
  when "accept"
    @user.has_mentee = @mentee_id
    @user.has_mentor = 1
    @user.save_changes

    @mentee.has_mentee = 1
    @mentee.save_changes

    subject = "Your mentorship by #{@user.name} has been accepted!"
    body = "Please go back to the mentee dashboard to see the communicative method of your mentor!"
  when "reject"
    @mentee.has_mentor = 0
    @mentee.save_changes
    subject = "Your mentorship by #{@user.name} has been rejected!"
    body = "Please go back to the mentee dashboard to choose a new mentor!
     (Only available 24 hours after initial invite to mentor)"
  end
  email = @mentee.email
  puts "Sending email..."
  if send_mail(email, subject, body)
    puts "Email Sent Ok."
  else
    puts "Sending failed."
  end
  redirect "/mentor"
end
