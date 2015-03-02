# Ruby seems cool, but can you build web stuff with it?

Yes! This section of the class will discuss how to build websites with Ruby.

The biggest and most popular web framework in Ruby is of course [Ruby on Rails](http://rubyonrails.org/), but Rails is really fancy and complicated and not really the best introduction to web development in a single hour class. So, we're going to try something simpler.

[Sinatra](http://www.sinatrarb.com/) is a lightweight Domain-Specific Language Framework for creating simple web applications in a simple fashion. In this class, we'll build a simple web application with Sinatra to give you an idea of some basic concepts of web frameworks in Ruby.

## Getting Started

If you want to get it working, we first need to install a few things on your machine.

* Ruby (2.2 or above is preferred)
* The [Sqlite3](https://sqlite.org/) database library.

We will also need to install a few gems. This is made simpler by using the bundler gem. To setup this project, run the following steps:

* gem install bundler
* bundle install (_this will install all other requirements_)

You might need to run these commands as `sudo` if they fail because of permission issues. Once you have this, we should be good to go.

## A Simple Web Application

As I said before, [Sinatra](http://www.sinatrarb.com/) is a lightweight Domain-Specific Language Framework for creating simple web applications in a simple fashion. Wow, this got jargontastic fast. But it's actually pretty cool. A domain-specific language is a subset of a programming language that is used only for specific problems. Sinatra is a special language that is for building websites like so

```
get '/hi' do
  "Hello World!"
end
```

**Nerd Note:** This is still Ruby code, but it's written in a special way to make it easier to just define a website in a few lines of streamlined code. What is happening here is we are calling a method named `get` defined by Sinatra with 2 arguments: the relative URL _route_ to respond to and a Ruby block containing the code to run when remote browsers connect to that route. What Sinatra does is create a registry of routes and actions and startup a web server to handle remote requests. This is many, many many more lines of code, but as users of Sinatra, we don't have to worry about all that busywork and just can use the minimal amount of code to do the work we need to do.

Look at [lesson_one.rb](lesson_one.rb) for an example of a really simple Sinatra application. This app seems pretty basic, but it's pretty powerful to write a web app like this in a few simple lines. To run it, type `ruby lesson_one.rb` and you should see something like the following output in your terminal:

```
== Sinatra/1.4.5 has taken the stage on 4567 for development with backup from Thin
Thin web server (v1.6.3 codename Protein Powder)
Maximum connections set to 1024
Listening on localhost:4567, CTRL+C to stop
```

Open your browser and navigate to [http://localhost:4567/hi](http://localhost:4567/hi) and see what your app does. Not bad for a few lines of code! Like I said before, Sinatra is doing all the hard work of defining the webserver, so our 3 lines of code gets expanded outward into a full web application. TK

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

This sounds complicated, but we've already been using controllers in our previous lesson. There we defined a few routes and the corresponding controller blocks to run when those pages were requested. And we even saw how they might print out some HTML directly to the browser. You could build HTML in the controller blocks like that, but it's a bit awkward. Instead, let's move our HTML markup out from inside the controller and put it into a separate file. Look at [views/hello.erb](views/hello.erb) for a simple example of an template file _view_. Let's look at the template and you'll notice a line like this

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
* The next line tells Sinatra to render an **e**mbedded **r**u**b**y template in the `views` directory called `hello.erb`

Embedded Ruby? This is a templating language where we can take ordinary HTML and embed ruby declarations within it using `<%= %>` for things we want included in the output and `<% %>` for commands like `<% if visible? %>` we don't. Why do this? It's a lot easier to use an external template file than to build up a string within our methods. It's also easier to have our designer create the HTML format we want and then wire up the templates with embedded directives like this. ERB is simple because it looks like HTML, but it's not the only choice. Here is the same page in another templating language called HAML with a really different syntax. (FIXME)

**Nerd Note:** Some of you might be wondering how Sinatra knew to look in the `views` directory for the `hello.erb` file. In some languages like Java, we would probably have to define a configuration file in XML or something that told Sinatra that our view named `hello` is located at the `views/hello.erb`. These configuration files are usually annoying though, since they are an extra file to edit and often out-of-date on a fast-developed project. So, often a lot of Ruby projects like Sinatra or Rails take the approach of *convention over configuration*, where the framework defines certain conventions it expects your project to follow in naming and locating files. So, by default, Sinatra expects views to be located in a `views` directory and to have a name that is the view name and template type like `hello.erb`. You can override the conventions if you really need to, but generally it's a good idea to learn them, if only because it makes it easier for the next developer working on your project to understand where files are located.

So, let's see how well you understand what we did here. Suppose we want to add this to our pages from hello: `<p>There are 5 letters in your name</p>`. Implement this with the following steps:

1. Define a new variable @count and assign it the value `@name.length` which is the length of the @name string
2. Include a HTML snippet in the `hello.erb` template to print out the letters in the name.

**Nerd Note:** What is with that `@` in the variable name? What happens if we remove it? Suddenly our template just prints out "Hello, " Why? The simple explanation is that variables are usually only reachable or _scoped_ within their methods. In Ruby though, _instance variables_ on objects are defined by prefixing them with `@`. So, we are defining a variable that's also reachable from within the context of our rendered templates. If it didn't have that @, our template would look for a locally defined variable called `name` within the template and crash. But why does it print "Hello, " if our controller doesn't set @name? In that case, Ruby assumes you are defining a variable `@name` in your view, sets it to `nil` by default which is rendered in the view as an empty string. Remember that, since it's a common issue if you mistype a variable name in your template

## Adding a Database

Okay, we've totally nailed the **VC** part of the **MVC** paradigm. Let's add a database and build a simple data viewer!

I've compiled a small database in this project called `hunt.db` that includes all of the hunting accidents in Wisconsin between 2007 and 2013 that involved squirrels. Let's see how big this is

```
SQLite version 3.8.5 2014-08-15 22:37:57
Enter ".help" for usage hints.
sqlite> select count(*) from accidents;
22
```

Welcome to the world of **BIG DATA**. Let's look at a single record to see what it's like:

Field|Value
-----|-----
ID|1
Final|t
Date|2012-05-20
Year|2012
County|Fond Du Lac
Injury|Arrow struck victim half way between waistline and shoulder blades
Fatal|f
SI/SP|N/A
Circumstances|Shooter shot an arrow from inside a sliding patio...
Shooter Age|16
Shooter Gender|M
Victim Age|7
Victim Gender|F
Weapon|Bow Premier Archery Outlaw

Shooting a 7-year-old girl with an arrow? Yikes.

Anyhow, we could construct SQL statements like `select * from accidents` to get our records, but this is kinda tedious and not very Ruby-like. So, instead we will use a popular Ruby library called *ActiveRecord* that implements a specific convention of **Object-Relational Mapping**. What? Huh? In English, this means it is code that allows us to load records from a DB, interact with them like they are Ruby object and save them back to the DB if we need to. It's probably easier to demonstrate, and so let's try this.

At the command line, type `tux` and hit enter. You should see something like this

```
Loading development environment (Rack 1.3)
>> 
```

What's this? It's waiting for our input. So, let's try something. I have defined an ActiveRecord model named `Accident` that allows us to query the `accidents` table in the database. So we can do things like this:

```
Loading development environment (Rack 1.3)
>> Accident.count
D, [2015-03-01T11:39:34.694741 #20226] DEBUG -- :    (0.2ms)  SELECT COUNT(*) FROM "accidents"
=> 22
>> a = Accident.where(shooter_gender: 'F').order('date ASC').first
D, [2015-03-01T11:39:53.869276 #20226] DEBUG -- :   Accident Load (0.3ms)  SELECT  "accidents".* FROM "accidents"  ORDER BY date ASC LIMIT 1
=> #<Accident id: 16, final_report: true, date: "2007-09-18", year: 2007, county: "La Crosse", injury: ".22 bullet wound to right cheek and right side of ...", fatal: false, si_sp: "SP", circumstances: "Victim squirrel hunting with husband. Shot in foot...", shooter_age: 41, shooter_gender: "F", victim_age: 62, victim_gender: "M", weapon: ".22 caliber semi-automatic rifle">
>> a.injury
=> ".22 bullet wound to right cheek and right side of neck"
```

What is happening here? Notice I am typing Ruby code and it is translating that into database queries to find objects and then returning Ruby types. In the second one, it returned a single `Accident` object that contains all the data from that record in the DB. Pretty awesome. And all it takes for us to use this in our code is to define a single subclass of ActiveRecord that defines `Accident` objects that are mapped to the `accidents` table

```
class Accident < ActiveRecord::Base
end
```

**Nerd Note:** What? How does this work? This is a perfect encapsulation of a lot of common Ruby practices in a single library:

* *Convention* - by default, ActiveRecord objects are named after the upper-case singular of the object (`Accident`) and expect to find records in a table named with the lower-case plural (`accidents`). You can override this if you need to.
* *DSL* - ActiveRecord defines its own helper methods for SQL database concepts like ordering or `where` constraints. We can use these instead of raw SQL to query our database.
* *Reflection* - you don't need to explicitly tell the `Accident` class what the columns in the database table are or their type. Instead, it figures that out on the fly by looking at the DB's table definitions and figuring out what Ruby types best represent the database columns.
* *Metaprogramming* - notice that my `Accident` class doesn't define an `injury` method, but when I call that, it works and returns the corresponding field from the database. The ActiveRecord library defines method_missing actions that look if a method is a DB column and returns that if it's not explicitly defined.
* *Magic* - taken together, reflection and metaprogramming can seem pretty uncanny. Indeed, one of the common complaints against Ruby is that there is too much magic. Sometimes, magic can be a drawback. But in this case, it makes it super simple to work with databases like you are working with native Ruby objects and that's pretty cool.

So, let's build a web application. 

Look at [lesson_three.rb](lesson_three.rb). I've defined two routes for our application:

* The `/` index page will display a list of all accidents on one page
* The `/show/:id` gives a detailed view of a specific accident

Let's look also at [views/index.erb](views/index.erb) which will render the index page. I've taken the liberty of writing this HTML out for you. But I wanted you to notice a few interesting things:

* I am including the [Bootstrap stylesheet](http://getbootstrap.com/) to make my table look pretty. By convention, static files like stylesheets and javascript are put within the `/public` directory.
* Notice how I am rendering out the rows of the table by interating through the accidents with `<% @accidents.each do |accident| %>`. This creates a variable named `accident` I can reference to display the values for each accident in the `@accidents` array.
* You can also use other Ruby control flow methods to control the page output. For instance, `<% if accident.self_inflicted? %>SELF<% else %><%= accident.victim_age %> yr. <%= accident.victim_gender %>`. Often we move this sort of logic into separate *helper* methods to keep the views simple.
* I defined a method in the `Accident` model named `self_inflicted?` that returns true if `si_sp == 'SI'`. I could put that condition in my view, but it's better to define an abstraction in my model for special conditions like this.
* My code for linking to a separate `show` page for each accident is pretty ugly. Other frameworks like Rails offer better helpers for dynamic URL construction.

*Your Turn:* Okay, let's see how well you understand all this with the two simple tasks:

1. Add a `weapon` column to the index page. This means adding both a header and another column in the table.
2. Fix the `show` method so that it properly defines a single accident record.

Remember, you probably need to ctrl-C and restart when you edit a file. But, once you've figured this out, you've made your first Ruby web application.

**Nerd Note:** Let me close with one other cool thing about ActiveRecord: named scopes. I've already briefly touched on how ActiveRecord lets you define complicated SQL queries by chaining several useful methods like this

```
Accident.where(si_sp: 'SI').where("year < 2010").order('date DESC')
```

But this still requires code that calls our models to know the underlying schema of our database or that special codes like 'SI' mean _self-inflicted_. It's more useful if we can hide the underlying structure of our database and instead define other DB-query methods that can be called by controllers without them having to know how the model is structured. Enter named scopes, a DSL for defining these methods. The `->` is shorthand for `lambda`, Ruby's mechanism for defining anonymous functions.

```
scope :fatal, -> { where(fatal: true) }
scope :self_inflicted, -> { where(si_sp: 'SI') }
scope :same_party, -> { where(si_sp: 'SP') }
scope :chronological, -> { order("date ASC") }
scope :reverse_chron, -> { order("date DESC") }

Accident.self_inflicted.reverse_chron
```
