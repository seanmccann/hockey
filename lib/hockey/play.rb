module Hockey
  class Play
    attr_accessor :seq, :period, :strength, :time, :event, :description,
      :home_on_ice, :away_on_ice

    def initialize(options)
      @seq = options[:seq]
      @period = options[:period]
      @strength = options[:strength]
      @time = options[:time]
      @event = options[:event]
      @description = options[:description]
      @home_on_ice = options[:home_on_ice]
      @away_on_ice = options[:away_on_ice]
    end
  end
end
