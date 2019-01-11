# e.g. `heroku run ANNICK_WARNED=true rake db:seed`
unless ENV["ANNICK_WARNED"].present? or Rails.env.development?
  raise "Warn Annick first!"
end

Notification.delete_all
Event.delete_all
Message.delete_all
Project.delete_all
Comment.delete_all
ConversationParticipantJoin.delete_all
Conversation.delete_all
Resource.delete_all
LikeFlag.delete_all
StayInformedFlag.delete_all
GetInvolvedFlag.delete_all
User.delete_all

@users = []
@projects = []
@conversations = []
@resources = []

# No reason to seed Annick, since she'll need to create a new Auth0 acct anyway
# @annick = FactoryGirl.create(:user,
#   name: "Annick DeWitt",
#   email: "annickdewitt@gmail.com")

SCALE=1 # default: 5

puts "\nCreating users..."
(SCALE*10).times do |i|
  print "."
  # name = Faker::Name.name
  # sanitized_name = name.downcase.gsub(/^\w/, "")
  # email = "#{sanitized_name}@example.com".downcase.gsub(/[^\w\@\.]/, '')
  # location = Faker::LordOfTheRings.location

  uri = URI.parse('https://randomuser.me/api/')
  response = Net::HTTP.get_response(uri)
  json = JSON.parse(response.body)['results'].first

  user = FactoryGirl.create(:user, {
    email: json['email'].gsub(/\s/, ''),
    name: json['name']['first'].capitalize + " " + json['name']['last'].capitalize,
    location: json['location']['city'] + ' ' + json['location']['state'],
    image: json['picture']['large']
  })
  @users << user
end
@users = @users.sample(25)

# Make people follow other people first so that they receive notifications of followee activity.
puts "\nPeople following people..."
(SCALE*20).times do |i|
  print "."
  follower = @users.sample
  followee = @users.sample
  # Tolerate failure in case of duplicates
  if StayInformedFlag.create(user: follower, target: followee)
    Event.register(follower, :follow, followee)
  end
end

puts "\nCreating projects..."
(SCALE*5).times do |i|
  print "."
  user = @users.sample
  # TODO: Add stock images... the lorempixel URL we were using, kept timing out
  project = FactoryGirl.create(:project,
    owner: user,
    image: "https://source.unsplash.com/random/200x200"
  )
  Event.register(project.owner, :create, project)
  @projects << project
end

puts "\nCreating conversations..."
(SCALE*5).times do |i|
  print "."
  convo_creator = @users.sample
  convo = FactoryGirl.create(:conversation, creator: convo_creator)
  Event.register(convo_creator, :create, convo)
  rand(1..10).times do
    commenter = @users.sample
    comment = FactoryGirl.create(:comment, context: convo, author: commenter)
    ConversationParticipantJoin.where(conversation: convo, participant: commenter).first ||
      FactoryGirl.create(:conversation_participant_join, conversation: convo, participant: commenter)
    Event.register(commenter, :comment, convo)
  end
  @conversations << convo
end

puts "\nCreating resources..."
(SCALE*10).times do |i|
  print "."
  user = @users.sample
  resource = FactoryGirl.create(:resource,
    creator: user,
    target: [@conversations.sample, @projects.sample, nil, nil, nil, nil].sample
  )
  Event.register(user, :create, resource)
  @resources << resource
end

puts "\nAdding like flags..."
(SCALE*20).times do |i|
  print "."
  user = @users.sample
  target = [@users, @conversations, @projects, @resources].sample.sample
  # Tolerate failure in case of duplicates
  if LikeFlag.create(user: user, target: target)
    Event.register(user, :like, target)
  end
end

puts "\nPeople follow conversations / projects / resources..."
(SCALE*20).times do |i|
  print "."
  user = @users.sample
  target = [@conversations, @projects, @resources].sample.sample
  # Tolerate failure in case of duplicates
  if StayInformedFlag.create(user: user, target: target)
    Event.register(user, :follow, target)
  end
end

puts "\nAdding get involved flags..."
(SCALE*5).times do |i|
  print "."
  user = @users.sample
  project = @projects.sample
  # Tolerate failure in case of duplicates
  GetInvolvedFlag.create(user: user, target: project)
end

PredefinedTag.repopulate

puts "\nSeeding complete! Stats:"
puts "- #{User.count} Users"
puts "- #{Project.count} Projects"
puts "- #{Conversation.count} Conversations"
puts "- #{Resource.count} Resources"
