
#!/usr/bin/python
#####################################################################
## Test Case ID     : AutomateSoundCloud.py
## Module           : N/A
## Description      : A sample webdriver script showing how to automate a website (soundcloud example here).
## Pre-requisites   : Python, selenium webdriver, firefox
## Author           : Steve Osteen sosteen@gmail.com
######################################################################

import time
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.common.exceptions import TimeoutException
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By

browser = webdriver.Firefox()
browser.implicitly_wait(5)

def WaitUntilLoaded(bymethod, identifier):
	"""A default 10 second wait for an element to be loaded"""
	try:
		WebDriverWait(browser, 10).until(EC.presence_of_element_located((bymethod, identifier)))
		return
	except TimeoutException:
		raise Exception("Unable to find element: %s", identifier)


browser.get('https://soundcloud.com/') #Open Soundcloud
WaitUntilLoaded(By.XPATH, "//a[@title='Terms of use']") #Verify page loaded
browser.find_element_by_xpath('/html/body/div[1]/div[2]/div/div/div[2]/div/div[1]/span/form/input').send_keys('SlumberMachine' + Keys.RETURN) #Search for SlumberMachine
WaitUntilLoaded(By.XPATH, "//*[contains(., 'results')]") #Verify results loaded
browser.find_element_by_xpath("//a[contains(@href,'/slumbermachine')]").click() #Click on slumbermachine page
WaitUntilLoaded(By.XPATH, "//span[contains(.,'1976 (76>84 mix)')]") #Verify page loaded
browser.find_element_by_xpath("//button[@title='Play']").click() #Play song

time.sleep(30)

browser.quit()
