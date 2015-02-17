# Ruby seems cool, but can you build web stuff with it?

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

This is in contrast to a general purpose language like Ruby itself. So what is the point of this? All of these specialized language constructs are implemented with Ruby methods, but it allows us to build things in a much simpler way than using general language constructs. With its widespread support for metaprogramming, Ruby is great for implementing DSLs. What do I mean by this? You'll see.

## Getting Started

If you want to get it working, we first need to install a few things on your machine.

* Ruby (2.2 or above is preferred)
* The [Sqlite3](https://sqlite.org/) database library.

We will also need to install a few gems. This is made simpler by using the bundler gem. To setup this project, run the following steps:

* gem install bundler
* bundle install (_this will install all other requirements_)

You might need to run these commands as `sudo` if they fail because of permission issues. Once you have this, we should be good to go.

## A Simple Web Application

Look at [lesson_one.rb](lesson_one.rb) for an example of a really simple Sinatra application. This app seems pretty basic, but it's pretty powerful to write a web app like this in a few simple lines. To run it, type `ruby lesson_one.rb` and you should see something like the following output in your terminal:

```
== Sinatra/1.4.5 has taken the stage on 4567 for development with backup from Thin
Thin web server (v1.6.3 codename Protein Powder)
Maximum connections set to 1024
Listening on localhost:4567, CTRL+C to stop
```

Open your browser and navigate to [http://localhost:4567/hi](http://localhost:4567/hi) and see what your app does. Not bad for a few lines of code. This is what a Domain Specific Language is, a simplified syntax for tersely defining the things you need to. So, 

```
get '/hi' do
  'Hello world!'
end
```

means "Define a method to run when a web browser requests GET /hi that returns "Hello World!" as its response" This bit of Sinatra code actually gets interpreted into a much longer sequence of regular Ruby code that does a bunch of things to setup a webserver and register methods to respond to specific web request paths or **routes**. This would be tedious to repeat and reimplement, so the DSL lets us ignore all that busywork and define our website as simply as possible.

Now, let's try this request [http://localhost:4567/](http://localhost:4567/). Uh oh! It's an error! Time to add another route for that.

```
get '/' do
  redirect to('/hi')
end
```

Reload in the browser, and it still doesn't work. Ooops. We need to `ctrl-C` Sinatra and restart it with `ruby lesson_one.rb` again and now it works. What you should see when you call [http://localhost:4567/](http://localhost:4567/) is that it redirects to [http://localhost:4567/hi](http://localhost:4567/hi). Your browser follows the redirect automatically and loads the new page, but what a request to [http://localhost:4567/](http://localhost:4567/) looks like is this

```
HTTP/1.1 302 Moved Temporarily
X-Content-Type-Options: nosniff
Content-Type: text/html;charset=utf-8
Location: http://localhost:4567/hi
Server: thin
X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
Content-Length: 0
Connection: close
```

Let's try one more thing here for kicks. Routes do not necessarily have to be single strings, they can be complicated and dynamic. Add this to lesson_one.rb.

```
get '/hello/:name' do
  "Hello <strong>#{params[:name].capitalize}</strong>!"
end
```

Restart Sinatra and go to [http://localhost:4567/ruby](http://localhost:4567/ruby) to see what happens here. How this code works is left as an exercise to the reader.

## HTML Templating

Right now, our current applications are pretty simple, but it's time to consider a little bit of organization. Enter the *Model-View-Controller* paradigm! It sounds pretty technical, but all it means is that we build our web apps from three basic types of parts:

* Model - classes that represent your data and best how to work with it
* View - templates written in special HTML or other markup
* Controller - methods that describe how your app should respond to a web request and use models to render a view

This sounds complicated, but we've already been using controllers in our previous lesson. There we defined a few routes and the controller methods to run when those pages were requested. And we even saw how to print out some HTML to return from the controller method that


## Adding a Database

