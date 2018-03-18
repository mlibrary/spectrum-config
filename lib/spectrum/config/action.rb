module Spectrum
  module Config
    class Action
      attr_accessor :id, :type, :driver, :credentials
      def initialize(data)
        data ||= {}
        self.id          = data['id']
        self.type        = data['type']
        self.driver      = data['driver']
        self.credentials = Credentials.new(data['credentials'])
      end

      def configure!
        driver.constantize.configure!(credentials)
      end

      def <=>(other)
        id <=> other.id
      end
    end
  end
end
