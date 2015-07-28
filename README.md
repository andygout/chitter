[![Build Status](https://travis-ci.org/andygout/chitter.png)](https://travis-ci.org/andygout/chitter)  [![Coverage Status](https://coveralls.io/repos/andygout/chitter/badge.png)](https://coveralls.io/r/andygout/chitter)  [![Code Climate](https://codeclimate.com/github/andygout/chitter/badges/gpa.svg)](https://codeclimate.com/github/andygout/chitter)


Chitter
=================


Brief:
-------

A Twitter clone that will allow the users to post messages to a public stream


Technologies used:
-------

- Ruby (language) on Sinatra (Web Application Framework)
- PostgreSQL Database (using DataMapper (Object Relational Mapper (ORM) written in Ruby))
- Tested using RSpec (behaviour-driven development framework)
- Rake gem (*to run pieces of the application in development outside of the web request/response cycle (i.e. maintenance tasks, periodic calculations, reporting in production environment)*)
- [Mailgun API](https://documentation.mailgun.com/) to send password recovery tokens


Site setup:
-------

- Run site on local server: `$ rackup`


Testing setup:
-------

- Run RSpec tests: `$ rspec`


User stories:
-------

```
As a new user
So that I can post messages on Chitter as me
I want to sign up for Chitter

As a new user who loves their username
So that I know my username is shared with no others
I want the sign-up protocol to only allow me to use a unique username

As a user who is ready to peep
So that I can post messages on Chitter as me
I want to log in to Chitter

As a security conscious user
So that I can avoid others posting messages on Chitter as me
I want to log out of Chitter

As a security conscious user
So that others cannot log into my account
I want to validate the login process with a secret password

As a forgetful user
So that I can reset my password if I forget it
I want to be able to do so via a password recovery system

As a user with something to share
So that I can let people know what I am doing
I want to post a message (peep) to chitter

As a user who likes to keep up to date with others
So that I can see what others are saying
I want to see all peeps in reverse chronological order

As a user who likes to know who has said what
So that I can which peeps are attributed to which user
I want this information displayed alongside each peep

As a pedantic user
So that I can better appreciate the context of a peep
I want to see the time at which it was made

As a sociable user
So that I can reply to other users' peeps
I want to be able to reply to their peeps

As a socially curious user
So that I can see replies to other peeps
I want to be able to view those replies with attributed user and time of reply

As a forgetful user
So that I don't accidentally reply to my own peeps
I do not want to be presented with that option

As a user without much time
So that I can see all peep info without having to be signed in
I want that to be displayed regardless of being signed in/out

As a user with an interest in other users
So that I can see a page relating solely to a particular user
I want to be able to see a page that displays their tweets alone

As a user with an interest in specific peeps
So that I can see a page relating solely to such with all associated replies
I want to be able to see a page that displays this alone and allows me to reply
```


Learning
-------

- `controllers/users.rb`: Alternate method for updating user data below; updates the user directly rather than current method in codebase which retrieves user from database, reassigns the attributes, and then saves the user; introduction to principle of [dirty resources](http://stackoverflow.com/questions/8671446/what-is-a-dirty-resource).
```
post '/users/set_new_password' do
  @password_token = params[:password_token]
  @user = User.first(password_token: @password_token)
  if @user.update(password: params[:password],
                password_confirmation: params[:password_confirmation],
                password_token: nil,
                password_token_timestamp: nil)
    flash[:notice] = 'Password has been reset'
    redirect to('/')
  else
    flash.now[:errors] = @user.errors.full_messages
    erb :'users/set_new_password'
  end
end
```


Next Steps
-------

- Reinstate test for recovery token submission to pass Travis CI - current error reads: `Failure/Error: click_button 'Email token'` / `RestClient::Unauthorized:` / `401 Unauthorized`
- Raise error if user tries to respond to own peep (can this also be enforced at DB level?) (+ test)
- Only display certain links ('Add Peep', 'Reply') when user is signed in (+ test)
- Additional tests to ensure user feed page includes no other user's peeps
- Additional tests to ensure no blank entries for: username/name/email/password/password confirmation; peeps; replies (again, can this be enforced at DB level?)
- Deploy to Heroku


Links:
-------

[Makers Academy: Chitter Challenge brief](https://github.com/makersacademy/chitter-challenge)

[Makers Academy: Bookmark Manager tutorial](https://github.com/makersacademy/course/blob/master/bookmark_manager/bookmark_manager.md)


Database layout:
-------

![Screenshot DB Layout](/public/git_img/db_layout.png)


Images:
-------

- Sign up
![Screenshot Sign Up](/public/git_img/sign_up.png)

- Sign up errors
![Screenshot Sign Up](/public/git_img/sign_up_error.png)

- Home page
![Screenshot Home Page](/public/git_img/home_page.png)

- Sign in
![Screenshot Sign Up](/public/git_img/sign_in.png)

- Sign in errors
![Screenshot Sign Up](/public/git_img/sign_in_error.png)

- Add new peep
![Screenshot Home Page](/public/git_img/add_new_peep.png)

- Reply
![Screenshot Home Page](/public/git_img/reply.png)

- User feed
![Screenshot User Feed](/public/git_img/user_feed.png)

- Goodbye message
![Screenshot User Feed](/public/git_img/goodbye.png)