get '/users/new' do
  @user = User.new
  erb :'users/new'
end

post '/users' do
  username = params[:username]
  username.gsub!(/\s/, '_')
  @user = User.create(username: username,
                      name: params[:name],
                      email: params[:email],
                      password: params[:password],
                      password_confirmation: params[:password_confirmation])
  if @user.save
    session[:user_id] = @user.id
    redirect to('/')
  else
    flash.now[:errors] = @user.errors.full_messages
    erb :'users/new'
  end
end

get '/users' do
  if params[:username].nil?
    redirect to('/')
  else
    username = params[:username]
    @user = User.first(username: username)
    erb :'users/username'
  end
end

post '/users/reset_password' do
  email = params[:forgot]
  user = User.first(email: email)
  user.password_token = (1..50).map{('A'..'Z').to_a.sample}.join
  user.password_token_timestamp = Time.now
  user.save
  user.email_token
  flash[:notice] = 'Token submitted'
  redirect to('/')
end

get '/users/reset_password/:password_token' do
  @password_token = params[:password_token]
  if User.count(password_token: @password_token) == 0
    flash[:errors] = ['No such token exists in the database']
    redirect to('/')
  else
    @user = User.first(password_token: @password_token)
    if Time.now > (@user.password_token_timestamp + (60 * 60))
      flash[:errors] = ['Over an hour has passed since token issued; please request another']
      redirect to('/')
    else
      erb :'users/set_new_password'
    end
  end
end

post '/users/set_new_password' do
  @password_token = params[:password_token]
  @user = User.first(password_token: @password_token)
  @user.password = params[:password]
  @user.password_confirmation = params[:password_confirmation]
  @user.password_token = nil
  @user.password_token_timestamp = nil
  if @user.save
    flash[:notice] = 'Password has been reset'
    redirect to('/')
  else
    flash.now[:errors] = @user.errors.full_messages
    erb :'users/set_new_password'
  end
end