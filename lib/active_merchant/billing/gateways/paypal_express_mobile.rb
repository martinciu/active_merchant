module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class PaypalExpressMobileGateway < PaypalExpressGateway
      
      self.test_redirect_url = 'https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout-mobile&token='
      self.live_redirect_url = 'https://www.paypal.com/cgibin/webscr?cmd=_express-checkout-mobile&token='
      self.display_name = 'PayPal Express Mobile Checkout'
      
    end
  end
end

