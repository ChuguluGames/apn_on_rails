class APN::APNSResponse
  RESPONSE_LENGTH = 6

  STATUS_NO_ERRORS            = 0
  STATUS_PROCESSING_ERROR     = 1
  STATUS_MISSING_DEVICE_TOKEN = 2
  STATUS_MISSING_TOPIC        = 3
  STATUS_MISSING_PAYLOAD      = 4 # skip notif
  STATUS_INVALID_TOKEN_SIZE   = 5 # skip device
  STATUS_INVALID_TOPIC_SIZE   = 6
  STATUS_INVALID_PAYLOAD_SIZE = 7 # skip notif
  STATUS_INVALID_TOKEN        = 8 # skip device
  STATUS_SHUTDOWN             = 10
  STATUS_WTF                  = 255
  # close/reopen the connection for every status[, skip faulty notif/device] and resume

  attr_reader :command, :status, :notification_identifier

  def initialize(data)
    self.data = data
  end

  def data=(new_data)
    @command, @status, @notification_identifier = new_data.unpack('CCN')
  end

  def data
    [@command, @status, @notification_identifier].pack('CCN')
  end

end