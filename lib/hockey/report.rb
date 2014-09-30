module Hockey
  class Report
    attr_accessor :season, :game_id

    def initialize(season, game_id, post_season=false)
      @post_season = post_season
      @season = season
      @game_id = sprintf '%04d', game_id.to_i
    end

    def season_prefix
      return @post_season ? "03" : "02"
    end

    def pl_doc
      filename = "/Users/sean/Desktop/#{@season}/PL#{season_prefix}#{@game_id}.HTM"
      f = File.open(filename)
      Nokogiri::HTML(f)
    end

    def away_team
      pl_doc.xpath("/html/body/table[@class='tablewidth'][1]/tr[1]/td/table[@class='tablewidth']/tr/td/table/tr/td[1]/table[@id='Visitor']/tr[3]/td/text()").first.to_s
    end

    def home_team
      pl_doc.xpath("/html/body/table[@class='tablewidth'][1]/tr[1]/td/table[@class='tablewidth']/tr/td/table/tr/td[3]/table[@id='Home']/tr[3]/td/text()").first.to_s
    end

    def game_number
      pl_doc.xpath("/html/body/table[@class='tablewidth'][1]/tr[1]/td/table[@class='tablewidth']/tr/td/table/tr/td[2]/table/tr[7]/td/text()").to_s.gsub('Match/', '').gsub('Game', '').to_i
    end

    def status
      pl_doc.xpath("/html/body/table[@class='tablewidth'][1]/tr[1]/td/table[@class='tablewidth']/tr/td/table/tr/td[2]/table/tr[8]/td/text()").to_s
    end

    def attendance
      pl_doc.xpath("/html/body/table[@class='tablewidth'][1]/tr[1]/td/table[@class='tablewidth']/tr/td/table/tr/td[2]/table/tr[5]/td/text()").to_s.split('at').first.gsub("Attendance", "").gsub(",","").to_i
    end

    def venue
      pl_doc.xpath("/html/body/table[@class='tablewidth'][1]/tr[1]/td/table[@class='tablewidth']/tr/td/table/tr/td[2]/table/tr[5]/td/text()").to_s.split("at").last.gsub("\u00a0","")
    end

    def played_on
      Date.parse pl_doc.xpath("/html/body/table[@class='tablewidth'][1]/tr[1]/td/table[@class='tablewidth']/tr/td/table/tr/td[2]/table/tr[4]/td/text()").to_s
    end

    def started_at
      start_time = pl_doc.xpath("/html/body/table[@class='tablewidth'][1]/tr[1]/td/table[@class='tablewidth']/tr/td/table/tr/td[2]/table/tr[6]/td/text()").to_s.split(';').first.gsub("Start", "").strip
      Chronic.parse "#{played_on.to_s} #{start_time}"
    end

    def ended_at
      end_time = pl_doc.xpath("/html/body/table[@class='tablewidth'][1]/tr[1]/td/table[@class='tablewidth']/tr/td/table/tr/td[2]/table/tr[6]/td/text()").to_s.split(';').last.gsub("End", "").strip
      Chronic.parse "#{played_on.to_s} #{end_time}"
    end

    def plays
      game_plays = []
      plays_doc = pl_doc.xpath("//tr[@class='evenColor']")
      plays_doc.each do |event|
        play_opts = {}
        play_opts[:game_id] = "#{@season}/#{season_prefix}/#{@game_id}"
        play_opts[:seq] = event.xpath("td[1]/text()").to_s
        play_opts[:period] = event.xpath("td[2]/text()").to_s
        play_opts[:strength] = event.xpath("td[3]/text()").to_s
        play_opts[:time] = event.xpath("td[4]/text()").first.to_s
        play_opts[:event] = event.xpath("td[5]/text()").to_s
        play_opts[:description] = event.xpath("td[6]/text()").to_s
        play_opts[:home_on_ice] = []
        play_opts[:away_on_ice] = []

        event.xpath("td[7]//font").each do |away_player|
          player_shift = {number: away_player.xpath('text()').to_s}
          player_shift[:position], player_shift[:name] = away_player.xpath("@title").to_s.split('-').map {|x| x.strip}
          play_opts[:away_on_ice] << player_shift
        end

        event.xpath("td[8]//font").each do |away_player|
          player_shift = {number: away_player.xpath('text()').to_s}
          player_shift[:position], player_shift[:name] = away_player.xpath("@title").to_s.split('-').map {|x| x.strip}
          play_opts[:home_on_ice] << player_shift
        end

        game_plays << Play.new(play_opts)
      end

      game_plays
    end

    # def home_players
    #   # []
    #   mag = pl_doc.xpath("/html/body/table[@class='tablewidth'][1]/tr/td/table[@class='tablewidth']/tr/td/table/tr[1]/td[@class='border'][1]/table/tr")
    #   # byebug
    # end
    #
    # def away_players
    #   []
    # end
  end
end
