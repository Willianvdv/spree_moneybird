module SpreeMoneybird
  class BaseResource < ActiveResource::Base
    self.site = "https://bluetools.moneybird.nl"
    self.user = "admin"
    self.password = "testtest"

    self.include_root_in_json = true
  end
end
