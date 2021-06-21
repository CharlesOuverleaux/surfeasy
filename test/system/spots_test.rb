require "application_system_test_case"

class SpotsTest < ApplicationSystemTestCase
  test "should return surfeasy when visiting the homepage" do
    visit root_url # "/"
    assert_selector "h1", text: "Surfeasy"
    # save_and_open_screenshot
  end
end
