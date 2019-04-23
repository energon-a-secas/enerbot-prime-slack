# It does affect me
module Temperature
  def weather_report
    25
  end

  def thermal_sensation_of(degrees)
    mood = { 0..10 => 'extreme cold',
             11..19 => 'cold',
             20..27 => 'warm',
             28..33 => 'very warm',
             34..37 => 'hot' }
    mood.select { |mood| mood === degrees }.values.first
  end

  def thermal_delay(state)
    delay = { 'extreme cold' => 2,
              'cold' => 0.8,
              'warm' => 0.1,
              'very warm' => 0.5,
              'hot' => 1 }
    delay[state].to_i
  end
end

# Environment
module Physical
 # Given by the user
end