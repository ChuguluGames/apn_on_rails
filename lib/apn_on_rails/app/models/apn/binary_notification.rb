class APN::BinaryNotification
  COMMAND = 2

  ITEM_DEVICE_TOKEN    = {id: 1, length: 32}
  ITEM_PAYLOAD         = {id: 2} # variable length
  PAYLOAD_MAXLENGTH    = 256
  ITEM_IDENTIFIER      = {id: 3, length: 4}
  ITEM_EXPIRATION_DATE = {id: 4, length: 4}
  ITEM_PRIORITY        = {id: 5, length: 2}
  PRIORITY_HIGH = 10
  PRIORITY_LOW  = 5

  attr_reader :priority, :device_token, :expiration_date, :identifier, :payload

  def device_token=(new_token)
    new_token = new_token.gsub(/[<\s>]/, '').downcase
    @device_token = new_token unless (new_token =~ /^[0-9a-f]{64}$/).nil?
  end

  def payload=(new_payload)
    new_payload = new_payload.gsub(/\\u([0-9a-f]{4})/) {|s| [$1.to_i(16)].pack("U")}
    @payload    = new_payload if new_payload.bytesize <= PAYLOAD_MAXLENGTH
  end

  def identifier=(new_identifier)
    @identifier = new_identifier
  end

  def expiration_date=(new_date)
    @expiration_date = new_date if new_date.is_a?(Date) or new_date.is_a?(Time) or new_date.nil?
  end

  def priority=(new_priority)
    @priority = new_priority if new_priority == PRIORITY_LOW or new_priority == PRIORITY_HIGH or new_priority.nil?
  end

  def data
    items = String.new

    items << [ITEM_DEVICE_TOKEN[:id], ITEM_DEVICE_TOKEN[:length], @device_token].pack('CnH64') if @device_token

    items << [ITEM_PAYLOAD[:id], @payload.bytesize, @payload].pack('Cna*') if @payload

    items << [ITEM_IDENTIFIER[:id], ITEM_IDENTIFIER[:length], @identifier].pack('CnN') if @identifier

    if @expiration_date
      ts = (@expiration_date.is_a?(Date) ? @expiration_date.to_time : @expiration_date).to_i
      items << [ITEM_EXPIRATION_DATE[:id], ITEM_EXPIRATION_DATE[:length], ts].pack('CnN')
    end

    items << [ITEM_PRIORITY[:id], ITEM_PRIORITY[:length], @priority].pack('CnC') if @priority

    [COMMAND, items.bytesize, items].pack('CNa*')
  end

end
