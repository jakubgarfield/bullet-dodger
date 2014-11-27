Apipie.configure do |config|
  config.app_name                = "Bullet Dodger API"
  config.api_base_url            = ""
  config.doc_base_url            = "/apipie"
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/*.rb"
  config.copyright = "Jed Soane, Jakub Chodounsky & The Gestures"
  config.app_info = <<-eos
An API that allows users to play an awesome game of Bullet Dodger.

==Getting started

The common knowledge says that picture is a worth a thousand words, so you better get used to reading.

1. create or join a game
2. poll the game until it is running
3. get the current turn id
4. submit a turn to player turns
5. poll the turn until it is completed
6. check the state of the game and possibly get the new turn
7. repeat from 4. until the game is finished
  eos
end
