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
  end
end
