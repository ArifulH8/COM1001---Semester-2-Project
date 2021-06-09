def perm_redirect
  case @privilege
  when "Mentee"
    redirect "/mentee"
  when "Mentor"
    redirect "/mentor"
  else
    redirect "/admin"
  end
end

