require "spec_helper"

describe Lita::Handlers::ThirdPartyNotifications, lita_handler: true do

  it { routes_http(:post, "/notifications/kitchen").to(:kitchen) }

end
