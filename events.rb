require 'curb'
require 'nokogiri'
require 'oj'
require 'chronic'

# settings
year = "20132014"
total_games = 1230

#
def home_team(doc)
  doc.xpath("/html/body/table[@class='tablewidth'][1]/tr[1]/td/table[@class='tablewidth']/tr/td/table/tr/td[3]/table[@id='Home']/tr[3]/td/text()").first
end

def away_team(doc)
  doc.xpath("/html/body/table[@class='tablewidth'][1]/tr[1]/td/table[@class='tablewidth']/tr/td/table/tr/td[1]/table[@id='Visitor']/tr[3]/td/text()").first
end


# run it
(11..total_games).to_a.each do |n|
  game_id = "02#{sprintf '%04d', n}"
  filename = "/Users/sean/Desktop/#{year}/PL#{game_id}.HTM"

  f = File.open(filename)
  doc = Nokogiri::HTML(f)

  away =
  home =

  game_number = doc.xpath("/html/body/table[@class='tablewidth'][1]/tr[1]/td/table[@class='tablewidth']/tr/td/table/tr/td[2]/table/tr[7]/td/text()").to_s.gsub('Match/', '').gsub('Game', '').to_i
  status = doc.xpath("/html/body/table[@class='tablewidth'][1]/tr[1]/td/table[@class='tablewidth']/tr/td/table/tr/td[2]/table/tr[8]/td/text()").to_s
  played_on = doc.xpath("/html/body/table[@class='tablewidth'][1]/tr[1]/td/table[@class='tablewidth']/tr/td/table/tr/td[2]/table/tr[4]/td/text()").to_s
  started_at, ended_at = doc.xpath("/html/body/table[@class='tablewidth'][1]/tr[1]/td/table[@class='tablewidth']/tr/td/table/tr/td[2]/table/tr[6]/td/text()").to_s.gsub(/Début\//, '').gsub('Start', '').gsub('Fin/', '').gsub('End', '').split(";").map {|x| x.split(' ').first}

  # started_at = Chronic.parse "#{played_on}#{started_at}"
  # ended_at = Chronic.parse "#{played_on}#{ended_at}"
  # puts "#{played_on}#{ended_at}"
  puts game_number
  puts played_on
  puts "=" * 50

  events = doc.xpath("//tr[@class='evenColor']")

  events.each do |event|
    play = {}
    play[:game_id] = "#{year}/#{game_id}"
    play[:seq] = event.xpath("td[1]/text()").to_s
    play[:period] = event.xpath("td[2]/text()").to_s
    play[:strength] = event.xpath("td[3]/text()").to_s
    play[:time] = event.xpath("td[4]/text()").first.to_s
    play[:event] = event.xpath("td[5]/text()").to_s
    play[:description] = event.xpath("td[6]/text()").to_s
    play[:home_on_ice] = []
    play[:away_on_ice] = []

    event.xpath("td[7]//font").each do |away_player|
      player_shift = {number: away_player.xpath('text()').to_s}
      player_shift[:position], player_shift[:name] = away_player.xpath("@title").to_s.split('-').map {|x| x.strip}
      play[:away_on_ice] << player_shift
    end

    event.xpath("td[8]//font").each do |away_player|
      player_shift = {number: away_player.xpath('text()').to_s}
      player_shift[:position], player_shift[:name] = away_player.xpath("@title").to_s.split('-').map {|x| x.strip}
      play[:home_on_ice] << player_shift
    end

    # puts Oj.dump play

    # puts "=" * 50
  end
end
