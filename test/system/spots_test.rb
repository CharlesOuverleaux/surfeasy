require "application_system_test_case"

class SpotsTest < ApplicationSystemTestCase
  test "should return surfeasy when visiting the homepage" do
    visit root_url # "/"
    assert_selector "h1", text: "Surfeasy"
    # save_and_open_screenshot
  end

  test "should have a form when visiting the homepage" do
    visit root_url # "/"
    assert_selector ".form", count: 1
    # save_and_open_screenshot
  end

  test "should return 3 levels when visiting the homepage" do
    visit root_url # "/"
    assert_selector ".skill_pill", count: 3
    # save_and_open_screenshot
  end
end
