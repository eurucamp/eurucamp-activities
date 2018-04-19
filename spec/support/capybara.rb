Capybara.configure do |config|
  config.default_max_wait_time = 5
end

Capybara.javascript_driver = :selenium_chrome_headless
