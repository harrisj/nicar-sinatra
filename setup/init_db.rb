require 'rubygems'
require "sinatra/activerecord"
require "american_date"
require_relative File.join("..", "models", "accident.rb")
require 'csv'

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: "hunt.db")

Accident.delete_all

CSV.foreach(File.join(File.dirname(__FILE__), "squirrel.csv"), :headers => true) do |row|
  date = Date.parse(row["date"])
  Accident.create final_report: row["final_report"].downcase == 'yes',
                  date: date.strftime("%Y-%m-%d"),
                  year: date.year,
                  injury: row["injury"],
                  county: row["county"],
                  fatal: row["fatal"].downcase == 'yes',
                  si_sp: row["si_sp"],
                  circumstances: row["circumstances"],
                  shooter_age: row["shooter_age"],
                  shooter_gender: row["shooter_gender"],
                  victim_age: (!row["victim_age"].nil? && row["victim_age"].downcase == 'same') ? row["shooter_age"] : row['victim_age'],
                  victim_gender: (!row["victim_age"].nil? && row["victim_age"].downcase == 'same') ? row["shooter_gender"] : row['victim_gender'],
                  weapon: row["firearm_type"]

end
