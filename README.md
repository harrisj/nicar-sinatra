# Ruby seems cool, but can you do one of them there websites with it?

Yes! This section of the class will discuss how to build websites with Ruby.

The biggest and most popular web framework in Ruby is of course [Ruby on Rails](http://rubyonrails.org/), but Rails is really fancy and complicated and not really the best introduction to web development in a single hour class. So, we're going to try something simpler.

[Sinatra](http://www.sinatrarb.com/) is a lightweight Domain-Specific Language Framework for creating simple web applications in a simple fashion. In this class, we'll build a simple web application with Sinatra to show what is possible.

## Domain Specific Whatsit?

Wow, this got jargontastic fast. But it's actually pretty cool. A domain-specific language is a subset of a programming language that is used only for specific problems. Sinatra is a special language that is for building websites like so

```
get '/hi' do
  "Hello World!"
end
```

This is in contrast to a general purpose language like Ruby itself. So what is the point of this? All of these specialized language constructs are implemented with Ruby methods, but it allows us to build things in a much simpler way than using general language constructs. With its widespread support for metaprogramming, Ruby is great for implementing DSLs.

## Getting Started

If you want to get it working, we first need to install a few things on your machine.

* Ruby (2.2 or above is preferred)
* The [Sqlite3](https://sqlite.org/) database library

We will also need to install a few gems. This is made simpler by using the bundler gem. To setup this project, run the following steps:

* gem install bundler
* bundle install (_this will install all other requirements_)

You might need to run these commands as `sudo` if it's failing because of permission issues.