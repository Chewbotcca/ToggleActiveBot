class Main
  include Cinch::Plugin

  match /setup/, method: :setup
  match /switch (.+)/, method: :switch
  listen_to :join, method: :online

  def getrank(m, user)
    return 4 if m.channel.owners.join(' ').split(' ').include?(user)
    return 3 if m.channel.admins.join(' ').split(' ').include?(user)
    return 2 if m.channel.ops.join(' ').split(' ').include?(user)
    return 1 if m.channel.half_ops.join(' ').split(' ').include?(user)
    return 0 if m.channel.voiced.join(' ').split(' ').include?(user)
    -1
  end

  def setup(m)
    if getrank(m, m.user.name) < 2
      m.reply 'Only operators or above may run `=setup`!'
      return
    end
    begin
      m.channel.mode "+m"
    rescue
      m.reply "I do not have permission to set mode +m! Aborting!"
      return
    end
    Bots.each do |tag, name|
      m.channel.mode "-v #{name}"
    end
    m.reply 'Channel ready for switching!'
  end

  def online(m)
    Bots.each do |tag, name|
      if name == m.user.name
        if @current == name
          switch(m, tag)
        end
      end
    end
  end

  def switch(m, tag)
    Bots.each do |tags, name|
      m.channel.mode "-v #{name}"
    end
    begin
      m.channel.mode "+v #{Bots[tag]}"
    rescue
      m.reply 'Tag not found!'
      return
    end
    @current = Bots['tag']
  end
end
