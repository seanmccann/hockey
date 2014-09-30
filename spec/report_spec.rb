require 'spec_helper'

describe Hockey::Report, vcr: { match_requests_on: [:host] } do
  context "style 20132014a" do
    let(:report) { Hockey::Report.new("20132014", 10) }

    it { expect(report.away_team).to eq "NASHVILLE PREDATORS" }
    it { expect(report.home_team).to eq "ST. LOUIS BLUES" }
    it { expect(report.played_on).to eq Date.parse("2013-10-3") }
    it { expect(report.started_at).to eq Time.parse("2013-10-3 7:47 CDT") }
    it { expect(report.ended_at).to eq Time.parse("2013-10-3 10:10 CDT") }
    it { expect(report.attendance).to eq 18851 }
    it { expect(report.venue).to eq "Scottrade Center" }
    it { expect(report.game_number).to eq 10 }
    it { expect(report.status).to eq "Final" }
    it { expect(report.plays.class).to eq Array }
    it { expect(report.plays.count).to eq 255 }
    it { expect(report.plays.last.description).to include "Game End" }

    describe 'players on ice' do
      it { expect(report.plays[50].description).to include "NSH ONGOAL" }
      it { expect(report.plays[50].strength).to eq "EV" }
      it { expect(report.plays[50].away_on_ice.count).to eq 6 }
      it { expect(report.plays[50].home_on_ice.count).to eq 6 }
      it { expect(report.plays[50].home_on_ice.first.class).to eq Hash }
      it { expect(report.plays[50].home_on_ice.first.keys.count).to eq 3 }
      it { expect(report.plays[50].home_on_ice.first[:name]).to eq "DEREK ROY" }
    end
  end

    context "style 20132014a playoff" do
    let(:report) { Hockey::Report.new("20132014", "411", post_season=true) }

    it { expect(report.away_team).to eq "NEW YORK RANGERS" }
    it { expect(report.home_team).to eq "LOS ANGELES KINGS" }
    it { expect(report.played_on).to eq Date.parse("2014-06-04") }
    it { expect(report.started_at).to eq Time.parse("2014-06-04 5:21 PDT") }
    it { expect(report.ended_at).to eq Time.parse("2014-06-04 08:12 PDT") }
    it { expect(report.attendance).to eq 18399 }
    it { expect(report.venue).to eq "Staples Center" }
    it { expect(report.game_number).to eq 411 }
    it { expect(report.status).to eq "Final" }
    it { expect(report.plays.class).to eq Array }
    it { expect(report.plays.count).to eq 358 }
    it { expect(report.plays.last.description).to include "Game End" }

    describe 'players on ice' do
      it { expect(report.plays[68].description).to include "NYR won" }
      it { expect(report.plays[68].strength).to eq "PP" }
      it { expect(report.plays[68].away_on_ice.count).to eq 6 }
      it { expect(report.plays[68].home_on_ice.count).to eq 5 }
      it { expect(report.plays[68].home_on_ice.first.class).to eq Hash }
      it { expect(report.plays[68].home_on_ice.first.keys.count).to eq 3 }
      it { expect(report.plays[68].home_on_ice.first[:name]).to eq "TREVOR LEWIS" }
    end
  end
end
