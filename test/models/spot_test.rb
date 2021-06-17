require "test_helper"

class SpotTest < ActiveSupport::TestCase
  test "should save spot correctly, when given valid params" do
    spot = Spot.create(name: "agucadoura",
                     surfline_id: "5842041f4e65fad6a7708e5a",
                     lat: 41.432386,
                     lon: -8.789592,
                     country: "Portugal",
                     ideal_swell_direction: 270,
                     ideal_wind_direction: 45,
                     ideal_tide: "All tides",
                     description: "Agucadoura in North Portugal is an exposed beach break that has fairly consistent surf and can work at any time of the year. Works best in offshore winds from the east. Windswells and groundswells in equal measure and the ideal swell direction is from the west.. Good surf at all stages of the tide",
                     ability_level: "All Abilities",
                     vibe: "Super friendly locals",
                     access: "Big parking nearby, also possible to park on the side of the road")
    assert_equal "agucadoura", spot.name
  end
end
