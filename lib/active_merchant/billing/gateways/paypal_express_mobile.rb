module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class PaypalExpressMobileGateway < PaypalExpressGateway

      self.test_redirect_url = 'https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout-mobile&token='
      self.live_redirect_url = 'https://www.paypal.com/cgibin/webscr?cmd=_express-checkout-mobile&token='
      self.display_name = 'PayPal Express Mobile Checkout'

      def build_setup_request(action, money, options)
        xml = Builder::XmlMarkup.new :indent => 2
        xml.tag! 'SetExpressCheckoutReq', 'xmlns' => PAYPAL_NAMESPACE do
          xml.tag! 'SetExpressCheckoutRequest', 'xmlns:n2' => EBAY_NAMESPACE do
            xml.tag! 'n2:Version', API_VERSION
            xml.tag! 'n2:SetExpressCheckoutRequestDetails' do
              xml.tag! 'n2:PaymentAction', action
              xml.tag! 'n2:OrderTotal', amount(money).to_f.zero? ? amount(100) : amount(money), 'currencyID' => options[:currency] || currency(money)
              if options[:max_amount]
                xml.tag! 'n2:MaxAmount', amount(options[:max_amount]), 'currencyID' => options[:currency] || currency(options[:max_amount])
              end
              add_address(xml, 'n2:Address', options[:shipping_address] || options[:address])
              xml.tag! 'n2:AddressOverride', options[:address_override] ? '1' : '0'
              xml.tag! 'n2:NoShipping', options[:no_shipping] ? '1' : '0'
              xml.tag! 'n2:ReturnURL', options[:return_url]
              xml.tag! 'n2:CancelURL', options[:cancel_return_url]
              xml.tag! 'n2:IPAddress', options[:ip] unless options[:ip].blank?
              xml.tag! 'n2:OrderDescription', options[:description]
              xml.tag! 'n2:BuyerEmail', options[:email] unless options[:email].blank?
              xml.tag! 'n2:InvoiceID', options[:order_id]

              if options[:billing_agreement]
                xml.tag! 'n2:BillingAgreementDetails' do
                  xml.tag! 'n2:BillingType', options[:billing_agreement][:type]
                  xml.tag! 'n2:BillingAgreementDescription', options[:billing_agreement][:description]
                  xml.tag! 'n2:PaymentType', options[:billing_agreement][:payment_type] || 'InstantOnly'
                end
              end

              # Customization of the payment page
              xml.tag! 'n2:PageStyle', options[:page_style] unless options[:page_style].blank?
              xml.tag! 'n2:cpp-image-header', options[:header_image] unless options[:header_image].blank?
              xml.tag! 'n2:cpp-header-back-color', options[:header_background_color] unless options[:header_background_color].blank?
              xml.tag! 'n2:cpp-header-border-color', options[:header_border_color] unless options[:header_border_color].blank?
              xml.tag! 'n2:cpp-payflow-color', options[:background_color] unless options[:background_color].blank?
              xml.tag! 'n2:SolutionType', 'Mark'

              if options[:allow_guest_checkout]
                xml.tag! 'n2:SolutionType', 'Sole'
                xml.tag! 'n2:LandingPage', 'Billing'
              end

              xml.tag! 'n2:LocaleCode', options[:locale] unless options[:locale].blank?
            end
          end
        end

        xml.target!
      end

    end
  end
end
