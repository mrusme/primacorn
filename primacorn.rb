require 'dotenv/load'
require "json"
require "selenium-webdriver"
require "test/unit"

class Primacom < Test::Unit::TestCase

  def setup
    @driver = Selenium::WebDriver.for :phantomjs
    @base_url = "https://www.primacom.de/"
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end

  def teardown
    @driver.quit
    assert_equal [], @verification_errors
  end

  def test_primacom
    @driver.get(@base_url + "/service/Kontaktformular")
    @driver.find_element(:css, "label.css-label").click
    sleep 2
    @driver.find_element(:id, "cboxClose").click
    sleep 1
    @driver.find_element(:id, "kontakt-vorname").clear
    @driver.find_element(:id, "kontakt-vorname").send_keys ENV['PRIMACOM_FIRSTNAME']
    @driver.find_element(:id, "kontakt-nachname").clear
    @driver.find_element(:id, "kontakt-nachname").send_keys ENV['PRIMACOM_LASTNAME']
    @driver.find_element(:id, "kontakt-email").clear
    @driver.find_element(:id, "kontakt-email").send_keys ENV['PRIMACOM_EMAIL']
    @driver.find_element(:id, "kontakt-telefon").clear
    @driver.find_element(:id, "kontakt-telefon").send_keys ENV['PRIMACOM_PHONE']
    @driver.find_element(:id, "kontakt-kundennummer").clear
    @driver.find_element(:id, "kontakt-kundennummer").send_keys ENV['PRIMACOM_CUSTOMERID']
    @driver.find_element(:css, "#kontakt-anliegen-button > span.ui-selectmenu-status").click

    @driver.execute_script("arguments[0].options[9].selected = true;" , @driver.find_element(:id, "kontakt-anliegen"))

    @driver.find_element(:id, "kontakt-emailnachricht").clear
    @driver.find_element(:id, "kontakt-emailnachricht").send_keys ENV['PRIMACOM_MESSAGE']
    @driver.find_element(:name, "submit").click
    sleep 2
  end

  def element_present?(how, what)
    @driver.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end

  def alert_present?()
    @driver.switch_to.alert
    true
  rescue Selenium::WebDriver::Error::NoAlertPresentError
    false
  end

  def verify(&blk)
    yield
  rescue Test::Unit::AssertionFailedError => ex
    @verification_errors << ex
  end

  def close_alert_and_get_its_text(how, what)
    alert = @driver.switch_to().alert()
    alert_text = alert.text
    if (@accept_next_alert) then
      alert.accept()
    else
      alert.dismiss()
    end
    alert_text
  ensure
    @accept_next_alert = true
  end
end
