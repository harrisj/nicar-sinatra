class Accident < ActiveRecord::Base
  # Some named scopes
  scope :fatal, -> { where(fatal: true) }
  scope :self_inflicted, -> { where(si_sp: 'SI') }
  scope :same_party, -> { where(si_sp: 'SP') }
  scope :chronological, -> { order("date ASC") }
  scope :reverse_chron, -> { order("date DESC") }

  # attributes
  def self_inflicted?
    si_sp == 'SI'
  end

  def same_party?
    si_sp == 'SP'
  end
end