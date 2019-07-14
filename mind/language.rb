module Vocal_Mimicry
  def coin_transaction(text)
    text.match(/^<@(.*?)>.*(\+\+|--|balance)(.*)/ix).try(:captures)
  end
end