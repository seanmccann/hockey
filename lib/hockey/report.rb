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

    def doc
      filename = "/Users/sean/Desktop/#{@season}/PL#{season_prefix}#{@game_id}.HTM"
      f = File.open(filename)
      Nokogiri::HTML(f)
    end

    def away_team
      doc.xpath("/html/body/table[@class='tablewidth'][1]/tr[1]/td/table[@class='tablewidth']/tr/td/table/tr/td[1]/table[@id='Visitor']/tr[3]/td/text()").first.to_s
    end

    def home_team
      doc.xpath("/html/body/table[@class='tablewidth'][1]/tr[1]/td/table[@class='tablewidth']/tr/td/table/tr/td[3]/table[@id='Home']/tr[3]/td/text()").first.to_s
    end

    def game_number
      doc.xpath("/html/body/table[@class='tablewidth'][1]/tr[1]/td/table[@class='tablewidth']/tr/td/table/tr/td[2]/table/tr[7]/td/text()").to_s.gsub('Match/', '').gsub('Game', '').to_i
    end

    def status
      doc.xpath("/html/body/table[@class='tablewidth'][1]/tr[1]/td/table[@class='tablewidth']/tr/td/table/tr/td[2]/table/tr[8]/td/text()").to_s
    end

    def attendance
      doc.xpath("/html/body/table[@class='tablewidth'][1]/tr[1]/td/table[@class='tablewidth']/tr/td/table/tr/td[2]/table/tr[5]/td/text()").to_s.split('at').first.gsub("Attendance", "").gsub(",","").to_i
    end

    def venue
      doc.xpath("/html/body/table[@class='tablewidth'][1]/tr[1]/td/table[@class='tablewidth']/tr/td/table/tr/td[2]/table/tr[5]/td/text()").to_s.split("at").last.gsub("\u00a0","")
    end

    def played_on
      Date.parse doc.xpath("/html/body/table[@class='tablewidth'][1]/tr[1]/td/table[@class='tablewidth']/tr/td/table/tr/td[2]/table/tr[4]/td/text()").to_s
    end

    def started_at
      start_time = doc.xpath("/html/body/table[@class='tablewidth'][1]/tr[1]/td/table[@class='tablewidth']/tr/td/table/tr/td[2]/table/tr[6]/td/text()").to_s.split(';').first.gsub("Start", "").strip
      Chronic.parse "#{played_on.to_s} #{start_time}"
    end

    def ended_at
      end_time = doc.xpath("/html/body/table[@class='tablewidth'][1]/tr[1]/td/table[@class='tablewidth']/tr/td/table/tr/td[2]/table/tr[6]/td/text()").to_s.split(';').last.gsub("End", "").strip
      Chronic.parse "#{played_on.to_s} #{end_time}"
    end
  end
end
