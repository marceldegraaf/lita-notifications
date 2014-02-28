require "spec_helper"

describe Lita::Handlers::Notifications, lita_handler: true do

  it { routes_http(:post, "/notifications/kitchen").to(:kitchen) }
  it { routes_http(:post, "/notifications/github").to(:github) }
  it { routes_http(:post, "/notifications/goomba").to(:goomba) }

end
