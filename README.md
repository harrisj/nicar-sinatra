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

This sounds complicated, but we've already been using controllers in our previous lesson. There we defined a few routes and the corresponding controller methods to run when those pages were requested. And we even saw how they might print out some HTML in the browser. Which worked, but it's a bit awkward. Instead, let's move our HTML markup out from inside the controller and put it into a separate file. Look at [views/hello.erb](views/hello.erb) for a simple example of an template file _view_. Let's look at the template

```
<h1>Hello <%= @name %></h1>
```

This kind of looks like HTML, but there is a special tag `<%= @name %>` in there that isn't HTML at all. What is that? Look at our [lesson_two.rb](lesson_two.rb) for this templateized version of our hello `route` from lesson one:

```
get '/hello/:name' do
  @name = params[:name].capitalize
  erb :hello
end
```

Notice two interesting things about our revised method:

* There is the `@name` variable we saw in our template being given a value
* The next line tells Sinatra to render an **e**mbedded **r**u**b**y template in the views directory called hello.erb

Embedded Ruby? This is a templating language where we can take ordinary HTML and embed ruby declarations within it using `<%= %>` for things we want included in the output and `<% %>` for commands like `<% if visible? %>` we don't. Why do this? It's a lot easier to use an external template file than to build up a string within our methods. It's also easier to have our designer create the HTML format we want and then wire up the templates with embedded directives like this. ERB is simple because it looks like HTML, but it's not the only choice. Here is the same page in another templating language called HAML with a really different syntax. (FIXME)

So, let's see how well you understand what we did here. Suppose we want to add this to our pages from hello: `<p>There are 5 letters in your name</p>`. Implement this with the following steps:

1. Define a new variable @count and assign it the value `@name.length` which is the length of the @name string
2. Include a HTML snippet in the `hello.erb` template to print out the letters in the name.

What is with that `@` in the variable name? What happens if we remove it? Suddenly our template just prints out "Hello, " Why? The simple explanation is that variables are usually only reachable or _scoped_ within their methods. In Ruby though, _instance variables_ on objects are defined by prefixing them with `@`. So, we are defining a variable that's also reachable from within the context of our rendered templates. If it didn't have that @, our template would look for a locally defined variable called `name` within the template and crash. But why does it print "Hello, " if our controller doesn't set @name? In that case, Ruby assumes you are defining a variable `@name` in your view, sets it to `nil` by default which is rendered in the view as an empty string. Remember that, since it's a common issue if you mistype a variable name in your template

## Adding a Database

