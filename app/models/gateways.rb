module Gateways
  ACTIONS = {
    fake_gateway: {
      creation_validation: Gateways::FakeGateway::CreationValidation,
      send_async: Gateways::FakeGateway::SendAsync,
    }
  }

  LIST = ACTIONS.keys

  def self.dig(gateway_name, action_name)
    ACTIONS.dig(gateway_name.to_sym, action_name.to_sym)
  end
end
