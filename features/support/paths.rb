module NavigationHelpers
  def path_to(page_name)
    case page_name
    
    when /the home page/i
      root_path
    when /the sign up page/i
      new_user_registration_path
    when /the sign in page/i
      new_user_session_path
    when /the admin login page/i
      new_admin_session_path
    when /the password reset request page/i
      new_password_path
    when /the shows page/i
      shows_path
    when /the admin shows page/i
      admin_shows_path
    when /the admin show page for/
      show = Show.find_by_name(page_name[/"([^"]+)"$/, 1])
      edit_admin_show_path show
    when /the show page for/
      show = Show.find_by_name(page_name[/"([^"]+)"$/, 1])
      show_path show
    when /the admin performers page/
      admin_performers_path
    when /the admin performer page for/
      performer = Performer.find_by_name(page_name[/"([^"]+)"$/, 1])
      edit_admin_performer_path performer
    # Add more page name => path mappings here
    
    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end
 
World(NavigationHelpers)
