module SpreeMoneybird
  class BaseResource < ActiveResource::Base
    self.site = nil
    self.user = nil
    self.password = nil

    self.include_root_in_json = true
  end
end
