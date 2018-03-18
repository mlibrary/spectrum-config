module Spectrum
  module Config
    class Credentials
      attr_accessor :type, :token, :account, :service
      def initialize(data)
        data ||= {}
        self.type = data['type']
        self.token = data['token']
        self.account = data['account']
        self.service = data['service']
      end
    end
  end
end
