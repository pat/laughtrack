class TwitterController < Devise::OmniauthCallbacksController
  def twitter
    user = User.load_from_oauth(request.env['omniauth.auth'])

    if user.present?
      flash[:notice] = 'Thanks for stopping by!'
      sign_in_and_redirect user, :event => :authentication
    else
      redirect_to root_path, :alert => "You don't have access to moderate LaughTrack. If you'd like to help, send a tweet to <a href=\"http://twitter.com/pat\">@pat</a>.".html_safe
    end
  end

  private

  def after_sign_in_path_for(resource)
    manage_tweets_path
  end
end
