# It does affect me
module Temperature
  def weather_report
    25
  end

  def thermal_effect(degrees)
    state = thermal_sensation_of(degrees)
    delay = thermal_delay(state)
    sleep(delay)
  end

  def thermal_sensation_of(degrees)
    mood = { 0..10 => 'freeze',
             11..19 => 'cold',
             20..27 => 'warm',
             28..33 => 'hot',
             34..37 => 'burn' }
    mood.select { |mood| mood === degrees }.values.first
  end

  def thermal_delay(state)
    delay = { 'freeze' => 2,
              'cold' => 0.8,
              'warm' => 0.1,
              'hot' => 0.5,
              'burn' => 1 }
    delay[state].to_i
  end
end

# Environment
module Physical
 # Given by the user
end