module APN
  module Connection

    class << self

      # Yields up an SSL socket to write notifications to.
      # The connections are close automatically.
      #
      #  Example:
      #   APN::Configuration.open_for_delivery do |conn|
      #     conn.write('my cool notification')
      #   end
      #
      # Configuration parameters are:
      #
      #   configatron.apn.passphrase = ''
      #   configatron.apn.port = 2195
      #   configatron.apn.host = 'gateway.sandbox.push.apple.com' # Development
      #   configatron.apn.host = 'gateway.push.apple.com' # Production
      #   configatron.apn.cert = File.join(rails_root, 'config', 'apple_push_notification_development.pem')) # Development
      #   configatron.apn.cert = File.join(rails_root, 'config', 'apple_push_notification_production.pem')) # Production
      def open_for_delivery(options = {}, &block)
        open(options, &block)
      end

      # Yields up an SSL socket to receive feedback from.
      # The connections are close automatically.
      # Configuration parameters are:
      #
      #   configatron.apn.feedback.passphrase = ''
      #   configatron.apn.feedback.port = 2196
      #   configatron.apn.feedback.host = 'feedback.sandbox.push.apple.com' # Development
      #   configatron.apn.feedback.host = 'feedback.push.apple.com' # Production
      #   configatron.apn.feedback.cert = File.join(rails_root, 'config', 'apple_push_notification_development.pem')) # Development
      #   configatron.apn.feedback.cert = File.join(rails_root, 'config', 'apple_push_notification_production.pem')) # Production
      def open_for_feedback(options = {}, &block)
        open(options, &block)
      end

      private
      def open(options = {}, &block) # :nodoc:
        puts "===> Connection::open ===> Begin"
        options = {:cert => configatron.apn.cert,
                   :passphrase => configatron.apn.passphrase,
                   :host => configatron.apn.host,
                   :port => configatron.apn.port}.merge(options)
        puts "===> Connection::open ===> Options merged"
        ctx = OpenSSL::SSL::SSLContext.new
        puts "===> Connection::open ===> Context initalized"
        ctx.key = OpenSSL::PKey::RSA.new(options[:cert], options[:passphrase])
        puts "===> Connection::open ===> Key initalized"
        ctx.cert = OpenSSL::X509::Certificate.new(options[:cert])
        puts "===> Connection::open ===> Certificat initalized"

        sock = TCPSocket.new(options[:host], options[:port])
        puts "===> Connection::open ===> Socket initalized"
        ssl = OpenSSL::SSL::SSLSocket.new(sock, ctx)
        puts "===> Connection::open ===> SSl initalized"
        ssl.sync = true
        ssl.connect
        puts "===> Connection::open ===> Connected !"

        begin
          yield ssl, sock if block_given?
        rescue Exception => e
          puts 'An exception raised, but ssl and sock will close'
          raise e
        ensure
          ssl.close
          sock.close
          puts 'Ssl and sock successfully closed'
        end
      end

    end

  end # Connection
end # APN