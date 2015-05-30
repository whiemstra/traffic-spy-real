require_relative '../test_helper'
require 'pry'

class ApplicationDetailsTest < Minitest::Test

  def setup
    x = Source.create!(identifier: 'turing', rooturl: 'http://turing.io')

    @payload_1 = 'payload={"url":"http://turing.io/team","requestedAt":"2013-02-13 21:38:28 -0700","respondedIn":37,"referredBy":"http://turing.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1200","resolutionHeight":"800","ip":"63.29.38.214"}'
    @payload_2 = 'payload={"url":"http://turing.io/team","requestedAt":"2013-02-14 21:38:28 -0700","respondedIn":88,"referredBy":"http://google.com","requestType":"POST","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1200","resolutionHeight":"800","ip":"100.100.38.214"}'
    @payload_3 = 'payload={"url":"http://turing.io/admissions","requestedAt":"2013-02-14 21:38:28 -0700","respondedIn":130,"referredBy":"http://yahoo.com","requestType":"PUT","parameters":[],"eventName": "checking_it_out","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1280","resolutionHeight":"1150","ip":"63.99.40.218"}'
    @payload_4 = 'payload={"url":"http://turing.io/admissions","requestedAt":"2013-02-14 21:38:28 -0700","respondedIn":65,"referredBy":"http://turing.com","requestType":"POST","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1200","resolutionHeight":"1000","ip":"52.29.38.888"}'
    @payload_5 = 'payload={"url":"http://turing.io/tuition","requestedAt":"2013-02-15 21:38:28 -0700","respondedIn":40,"referredBy":"http://google.com","requestType":"GET","parameters":[],"eventName": "moneymoneymoney","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1300","resolutionHeight":"1100","ip":"93.92.11.245"}'
    @payload_6 = 'payload={"url":"http://turing.io/admissions","requestedAt":"2013-02-15 21:38:28 -0700","respondedIn":40,"referredBy":"http://gschool.com","requestType":"GET","parameters":[],"eventName": "checking_it_out","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"120","resolutionHeight":"160","ip":"77.730.38.594"}'

    post('/sources/turing/data', @payload_1)
    post('/sources/turing/data', @payload_2)
    post('/sources/turing/data', @payload_3)
    post('/sources/turing/data', @payload_4)
    post('/sources/turing/data', @payload_5)
    post('/sources/turing/data', @payload_6)

    # binding.pry
    visit '/sources/turing'
  end

  def test_path_exists
    assert_equal '/sources/turing', current_path
  end

  def test_displays_error_message_if_identifier_unknown
    visit '/sources/gschool'

    assert page.has_content?("Application Not Registered")
  end

  def test_it_displays_most_to_least_hits
    assert page.has_content?("http://turing.io/team")
  end

  def test_it_displays_the_screen_res
    assert page.has_content?("1200 x 800 : 2")
    assert page.has_content?("120 x 160 : 1")
  end

  def test_it_displays_browsers
    assert page.has_content?("Chrome") || page.has_content?("Firefox") || page.has_content?("Safari")
  end

  def test_it_displays_the_OS
    assert page.has_content?("Macintosh") || page.has_content?("Windows")
  end

  # def test_it_displays_least_to_most_response_time
  #
  # end

  def test_the_url_path_exist
    assert_equal '/sources/turing', current_path
    visit '/sources/turing/urls/admissions'
    assert_equal '/sources/turing/urls/admissions', current_path
  end

  def test_it_displays_correct_error_message_if_path_does_not_exist
    visit '/sources/turing/urls/contact'
    assert page.has_content?('Relative URL Does Not Exist')
  end

  def test_it_displays_longest_average_response_time_per_url_among_all_urls
    assert page.has_content?('78.3')
  end

  def test_it_displays_shortest_average_response_time_per_url_among_all_urls
    assert page.has_content?('40')
  end


  def test_for_each_specific_url_it_displays_longest_response_time
    visit '/sources/turing/urls/admissions'
    assert page.has_content?('130')
  end

  # def test_for_each_specific_url_it_displays_shortest_response_time
  #   visit '/sources/turing/urls/admissions'
  #   assert page.has_content?('40')
  # end

  # def test_for_each_specific_url_it_displays_average_response_time
  #   visit '/sources/turing/urls/admissions'
  #   assert page.has_content?('78.3')
  # end

  def test_when_one_http_verb_has_been_used
    visit '/sources/turing/urls/team'
    assert page.has_content?('GET')
  end

  def test_when_two_http_verbs_have_been_used
    visit '/sources/turing/urls/admissions'
    assert page.has_content?('GET')
    assert page.has_content?('POST')
  end

  def test_it_counts_events
    visit '/sources/turing/events'
    assert page.has_content?(
        "moneymoneymoney: 1
        checking_it_out: 2
        socialLogin: 3 ")
  end

  # def test_most_popular_referrers
  #   visit '/sources/yahoo/urls/weather'
  #   assert page.has_content?('jumpstart')
  # end
  #
  # def test_most_popular_user_agent_browser
  #   visit '/sources/yahoo/urls/weather'
  #   save_and_open_page
  #   assert page.has_content?('Chrome')
  # end
  #
  # def test_most_popular_user_agent_platform
  #   visit '/sources/yahoo/urls/weather'
  #   assert page.has_content?('Windows')
  # end

end
