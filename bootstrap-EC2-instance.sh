# This script configures one Ubuntu instance, installs Shiny Server,
#  downloads my Shiny apps and hosts them on port 80.
# It works on any Ubuntu server, not only AWS EC2 instances.

# If running on AWS, though:
# Run this script (as user 'ubuntu') to set up a fresh EC2 instance
# (running Ubuntu, not Amazon Linux!)

# set and update locale, it wants to use German stuff somehow
sudo locale-gen en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8
# sudo update-locale LANGUAGE=en_US.UTF-8  # do we need this if we already set LC_ALL?
# TODO this requires a reboot at the end. Can I do that without one somehow?

# Set correct timezone:
sudo cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime

sudo apt update
sudo apt install -y lsb-core  # to suppress a warning in the output of 'lsb_release'
sudo apt install -y libssl-dev libxml2-dev libcurl4-openssl-dev  # required for some tidyverse-requirements

# Add the CRAN repo for installing the newest R version
sudo bash -c 'echo "deb https://cloud.r-project.org/bin/linux/ubuntu `lsb_release -a | grep Codename | cut -f 2`/" >> /etc/apt/sources.list'
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
sudo apt update
sudo apt install -y r-base

# Install the necessary R packages
sudo su - -c "R -e \"install.packages(c('shiny', 'rmarkdown', 'tidyverse'), repos='https://cran.rstudio.com/')\""

# Install Shiny Server
sudo apt install -y gdebi-core
wget https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.7.907-amd64.deb
# I couldn't find a -y parameter for gdebi. And for the pipe to work you can't
#  just prepend 'sudo', but have to run the entire command in a sudo environment:
sudo bash -c "yes | gdebi shiny-server-1.5.7.907-amd64.deb"

# Enable autostart after boot
sudo systemctl enable shiny-server
# have the server on port 80 instead of 3838
sudo sed -i 's/listen 3838/listen 80/' /etc/shiny-server/shiny-server.conf
sudo systemctl restart shiny-server

# Clone git repository with shiny apps
sudo mv /srv/shiny-server /srv/shiny-server.bak
sudo git clone https://github.com/AlexEngelhardt/shiny-server.git /srv/shiny-server/
# This adds a cronjob that pulls your repository's master branch every minute:
sudo bash -c "echo '* * * * * root cd /srv/shiny-server && git pull' >> /etc/crontab"

# TODO Shiny Server Admin Guide: http://docs.rstudio.com/shiny-server/
#  - Add Google Analytics
