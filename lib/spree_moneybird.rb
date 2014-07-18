require 'spree_core'
require 'spree_moneybird/engine'
require 'active_resource'

module SpreeMoneybird
  mattr_accessor :company
  mattr_accessor :api
  mattr_accessor :password

  def self.setup
    yield self
  end
end

require 'spree_moneybird/resources/base'
require 'spree_moneybird/resources/tax_rate'
require 'spree_moneybird/resources/contact'
require 'spree_moneybird/resources/invoice'
