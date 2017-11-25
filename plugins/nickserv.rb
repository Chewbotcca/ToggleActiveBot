class NickServ
  include Cinch::Plugin

  listen_to :connect, method: :identify
  match /nsregister (.+) (.+)/, method: :register
  match /nsverify (.+)/, method: :verify

  def identify(_m)
    unless CONFIG['nickservpass'].nil? || CONFIG['nickservpass'] == ''
      User('NickServ').send("identify #{CONFIG['nickservpass']}")
    end
  end

  def getrank(m, user)
    return 4 if m.channel.owners.join(' ').split(' ').include?(user)
    return 3 if m.channel.admins.join(' ').split(' ').include?(user)
    return 2 if m.channel.ops.join(' ').split(' ').include?(user)
    return 1 if m.channel.half_ops.join(' ').split(' ').include?(user)
    return 0 if m.channel.voiced.join(' ').split(' ').include?(user)
    -1
  end

  def register(m, pass, email)
    if getrank(m, m.user.name) > 1
      User('NickServ').send("register #{pass} #{email}")
      CONFIG['nickservpass'] = pass.to_s
      File.open('config.yaml', 'w') { |f| f.write CONFIG.to_yaml }
      m.reply 'I sent verification to nickserv. It might need to verify the email. In that case, type `=nsverify [code]` to verify it. Otherwise, the password has been logged into the config and it will auto-authenticate on startup!'
    else
      m.reply 'You are not permitted to do this action!'
    end
  end

  def verify(m, code)
    if m.user.host == CONFIG['ownerhost']
      User('NickServ').send("verify register #{CONFIG['nickname']} #{code}")
      m.reply 'Hey! NickServ verified!'
    else
      m.reply 'You are not permitted to do this action!'
    end
  end
end
