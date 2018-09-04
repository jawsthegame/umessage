# About this fork

I recently switched to Linux as my daily workstation. The only thing I truly, persistently missed was the ability to respond to SMS and iMessage conversations from the comfort of my workstation.

After a lot of research and mucking around, I decided I would write a Rails app that would run on my old Mac and give me a simple web interface into the Messages app. I was going to do it from scratch until I found `coisnepe`'s project, and that really got the ball rolling.

Some notes about setup and some TODOs:

* Both individual and group chats are working!
* This app attempts to match phone numbers to names using a CSV export from your address book. It expects to find it at `db/contacts.csv`. I generated mine using an app from the App Store called AB2CSV. This doesn't work great and didn't capture all my contacts. I will be looking for better alternatives to finding the correct names. If you just want to see it in action without contact names, some small edits to `app/services/contacts.rb` should do the trick.
* Attachments are not supported yet. This is something I plan to add, including drag-and-drop as well as clipboard support.
* The app doesn't yet generate browser notifications or update in real-time. This is also something I intend to add.
* The UI is extremely minimal. I'll be working on this some, but ultimately I'd like to theme it like the rest of my desktop environment (Solarized, basically). Theming support as an actual feature would be cool, but probably outside my own scope here. Feel free to fork it and make it your own.
* I am interested in adapting this further as a bridge that can work with some other chat protocol so it's accessible without a browser. I haven't looked too deeply into this yet, but it is something I want to do. At the very least, adding a JSON API would open up all kinds of possibilities.
* It doesn't currently support starting new conversations. This isn't something I do that often at all outside using my phone, but if I find myself wanting it enough maybe I'll add it.
* I'm using this in macOS High Sierra (10.13.6, specifically), and I plan to stick with that. From my research, it looks like Apple frequently changes the iMessage database format and interfaces, seemingly (at least sometimes) deliberately to foil attempts at doing exactly what I'm trying to do here. So I suppose my old Mac will run High Sierra either forever or until Apple opens up the iMessage platform, whichever comes first.

# Original README:

##imessage_on_rails

A super simple Rails app to play with OSX's Messages database

To get your database (better not work with the actual imessage db!), run:

```
$ cp ~/Library/Messages/chat.db path/to/imessage_on_rails/db/chat.sqlite3
```

This shouldn't take more than a few seconds...

Right now I'm basically only using ActiveRecord, so `rails c` will get you going.

The models are as follows:
- Chat: a conversation
- Message
- Attachment
- Handle: a person

The joins are functional, giving you queries such as `Chat.where(chat_identifier: "johndoe@icloud.com").message`

To compensate for the lack of GUI, unleash the power of _awsome_print_ and make the query results easier on the eyes by prefixing your commands with `ap`

A graphical interface would be neat, so feel free to fork and submit pull requests.
