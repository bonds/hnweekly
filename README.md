This web app shows an Atom (RSS) feed of the top rated Hacker News articles
from the past week. [Try it][1].

## Why

I created Hacker News Weekly because I found myself checking Hacker News
constantly, afraid to miss any tidbit of nerd awesomeness and using HN
to fill moments that I'd rather fill with something more satisfying. On the
other hand, I would like to stay current on the HN memes and new tech
goodness going down, but I only need the top stuff.

My new diet consists of the top 5 HN articles of the past week, delivered once
a week, every Sunday morning, through this app and [r2e][2], a tool that checks
for updated RSS feeds and emails them out. Oh, and [leechblock][3], to keep me
honest.

## Code

This app is written in Ruby on Rails (and hosted on Heroku) because I'm lazy.
The only file that does something interesting (unless you find a vanilla Rails
app interesting) is [main_controller.rb][4].

  [1]: http://hnweekly.herokuapp.com/
  [2]: http://www.allthingsrss.com/rss2email/
  [3]: http://www.proginosko.com/leechblock.html
  [4]: https://github.com/bonds/hnweekly/blob/master/app/controllers/main_controller.rb

