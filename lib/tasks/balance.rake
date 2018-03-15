desc " Fetch account balance"
task :fetch_balance => :environment do

  require 'watir'
  require 'nokogiri'
  require 'open-uri'
  require 'selenium-webdriver'

  Account.all.each do |account|

      # Credentials
      username = "29629"
      password = "1234"

      #Get SimCards
      #active

      simcardNumber = account.simcardNumber

      #open Browser
      browser = Watir::Browser.new :chrome, headless: true
      browser.goto  "https://www.h2odealer.com/mainCtrl.php?page=DbEquip"

      #Login
      browser.text_field(:name => "dc").set username
      browser.text_field(:type => "password").set password
      browser.input(:type => "image").click

      #Get SimNumber
      browser.option(:value => "GSM").click
      browser.text_field(:id => "gsm_mdn_sim").set simcardNumber
      browser.image(:src => "images/db/bt_submit.png").click

      sleep (11)

      if browser.element(:xpath, "//*[@id='rep_error_note']").text == "Cancelled"
        phoneNumber = browser.element(:xpath, "//*[@id='rep_error_mdn']").text
      else
        phoneNumber = browser.element(:xpath, "//*[@id='rep_gsm_mdn']").text
      end
      sleep(1)
      accountStatus = browser.element(:xpath, "//*[@id='rep_gsm_mdn_status']").text
      expiredAccount =  browser.element(:xpath, "//*[@id='rep_error_note']").text
      sleep(1)

      browser.goto  "https://www.h2odealer.com/mainCtrl.php?page=DbBalance"

      #get DbBalance
      browser.option(:value => "GSM").click
      browser.text_field(:id => "txtMDN").set phoneNumber
      browser.image(:src => "images/db/bt_submit.png").click


      sleep(2)
      #collect Data
      balance = browser.element(:xpath, "//*[@id='fcard_bal']").text
      expiration = browser.element(:xpath, "//*[@id='exp']").text
      puts "SimCard Number:" + simcardNumber
      puts "Phone Number: " + phoneNumber
      puts "Account Balance: " + balance
      puts "Expiration Date: " + expiration
      puts "Account Status: " + accountStatus
      puts expiredAccount
      account.update_attribute(:balance, balance)
      account.update_attribute(:accountStatus, accountStatus)
      account.update_attribute(:accountStatus, expiredAccount)
      account.update_attribute(:phoneNumber, phoneNumber)
      account.update_attribute(:expirationDate, expiration)


    end
end
