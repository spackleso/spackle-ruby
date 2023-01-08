module Spackle
  module Util
    def self.log_error(message)
      Spackle.logger.error(message)
    end

    def self.log_info(message)
      Spackle.logger.info(message)
    end

    def self.log_debug(message)
      Spackle.logger.debug(message)
    end
  end
end
