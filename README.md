# uMessage

iMessage access away from your Apple devices, for those conversations that are too important to miss.

![Screenshot](https://raw.githubusercontent.com/cvincent/imessage_on_rails/master/app/assets/images/screenshot.png)

When I switched to Linux, the only thing I truly, persistently missed was the ability to respond to SMS and iMessage conversations from the comfort of my workstation. After a lot of research and mucking around, I decided I would write a Rails app that would run on my old Mac and give me a simple web interface into the Messages app.

uMessage is the result of this (ongoing) effort.

## The Bullet Points

* uMessage is a Rails app that runs on your Mac. You must have a Mac with an iCloud account that is able to use `Messages.app` for uMessage to be of any use.
* You can view and reply to existing one-to-one and group conversations.
* uMessage has been tested only on macOS High Sierra (10.13.6, specifically), and I plan to stick with that, as it is impossible to know what updates may break compatibility with uMessage. Reports of issues on other versions of macOS are welcome, but not as welcome as patches that fix such issues. I don't tend to upgrade to major macOS releases until long after they've shipped.

## Dependencies

This app relies on the [Contactor](https://github.com/kettle/Contactor) command line utility to replace phone numbers with real names. To install it, run `brew tap kettle/homebrew-kettle && brew install Contactor`.

You will also need a Redis server running for pub/sub for real-time chat updates.

## Installation

Install like a normal Rails app, but don't create a database! Then run `rake messages:setup`, which will create a symlink in your public directory to your iMessage attachments directory so the GUI can display messages with images.

Issue `foreman start` to start up both the app server and the chat polling process.

## Configuration

You can set your preferred time zone in `config/application.rb`. Use `rake time:zones:all` for a full list of valid time zone strings.

There is basic theme support for those of us who like to rice our DEs, WMs, pets, and loved ones. The default theme is Solarized Dark. Check `app/assets/stylesheets/themes/solarized-dark.sass` to see how it's implemented, and to use as a starting place for new themes (it doesn't have to be SASS; CSS and SCSS will also work). Themes are set by a string in `config/application.rb` which is added as a class to the container element in the page layout. All themes are loaded, but should be scoped to that element. Again, see the included theme for more info. To see the unthemed appearance, just change the config string to "unthemed" (or any non-existent theme).

## Important Caveats

* uMessage does not yet have an authentication mechanism. This means that uMessage *must not* be deployed where it is accessible from the public internet, unless you configure some kind of authentication mechanism in front of it on your own. It is your responsibility to use this software securely.
* In general, use at your own risk. It is a good idea to back up your `~/Library/Messages/chat.db*` files before running uMessage. It only reads from this database, but the nature of interfacing with closed softare such as `Messages.app` is that you never know how it might behave now or in the future. Again, it is your responsibility to take proper precautions and weigh the risks.

## TODO

Contributions are welcome!

- [x] Better support for Address Book name replacement
- [x] Improve name replacement further; right now not all "phone" fields are recognized
- [x] Submit messages with Ajax
- [x] Real-time message updates
- [x] Proper UI (properly-sorted conversations in sidebar)
- [x] Add theme as a configuration option
- [x] Implement a Solarized-based theme
- [ ] Attachments
  - [x] Render images in messages
  - [ ] Upload form
  - [ ] Drag-and-drop
  - [ ] Clipboard
- [ ] Browser notifications
- [ ] Copious hotkeys
- [ ] Authentication so it's safer to expose for remote access
