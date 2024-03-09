# README

rails g trailblazer:pro:import 9661db app/concepts/posting/posting-v1.json
rails g trailblazer:pro:discover Posting::Collaboration "<ui> author workflow"  app/concepts/posting/posting-v1.json


## ChromeDriver on Ubuntu 20.04

You might get an error when running integration tests on Ubuntu.

```
Failed to find Chrome binary. (Webdrivers::BrowserNotFound)
```

```
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
```

Stolen from: https://tecadmin.net/setup-selenium-chromedriver-on-ubuntu/

```
wget https://chromedriver.storage.googleapis.com/2.41/chromedriver_linux64.zip
unzip chromedriver_linux64.zip
sudo mv chromedriver /usr/bin/chromedriver
sudo chown root:root /usr/bin/chromedriver
sudo chmod +x /usr/bin/chromedriver
```
