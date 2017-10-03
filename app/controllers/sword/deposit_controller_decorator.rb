Sword::DepositController.class_eval do
  http_basic_authenticate_with name: "example_sword_user", password: "example_secret"
end
