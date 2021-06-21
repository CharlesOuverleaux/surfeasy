require "application_system_test_case"

class SpotsTest < ApplicationSystemTestCase
  test "visiting the homepage" do
    visit root_url # "/"
    assert_selector "h1", text: "Surfeasy"
  end
end
