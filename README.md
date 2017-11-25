# ToggleCurrentBot

## What is it?

I have multiple instances of my bots when testing, but with the same prefix they interfere. So I wrote this bot to toggle the current "in use" bot.

## How does it work?

Bot requires +h (where available) or higher to modify roles.

On `=setup`, the bot will put the channel in (+m) and de-voice any bots found in the bots.yaml.

Type `=switch [bottag]` where bottag is whatever is defined in the config. The bot will voice that bot and, as a check, devoice all other bots in the bots file.

## How do I use it?

Configure `config.yaml`, this decides the bot's nick, where it conencts, the usual.

Run `=nsregister [email] [pass]` to register. If needed, run `=nsverify [code]` found in the email.

Go ahead and give the bot auto-halfop or above, it'll need it.

Go to `bots.yaml` and follow this format:

```yaml
botTag: nick
botTag2: nick2
```

Example with my bots:

```yaml
stable: Chewbotcca
beta: Chewbotcca-BETA
alpha: Chewbotcca-ALPHA
```

Save, restart, and run `=setup`. Done!

When ready, `=switch [bottag]`.

Enjoy testing your bots!
