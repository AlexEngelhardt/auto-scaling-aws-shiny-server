# Run this script (as user 'ubuntu') to set up a fresh EC2 instance
# (running Ubuntu, not Amazon Linux!)

# TODO set and update locale, it wants to use German stuff somehow

sudo apt update
sudo apt install lsb-core  # to suppress a warning in the output of 'lsb_release'
sudo apt install git
sudo apt install libssl-dev libxml2-dev libcurl4-openssl-dev  # required for some tidyverse-requirements

# Add the CRAN repo for installing the newest R version
sudo bash -c 'echo "deb https://cloud.r-project.org/bin/linux/ubuntu `lsb_release -a | grep Codename | cut -f 2`/" >> /etc/apt/sources.list'
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
sudo apt update
sudo apt install r-base

# Install the shiny package
sudo su - -c "R -e \"install.packages(c('shiny', 'tidyverse'), repos='https://cran.rstudio.com/')\""

# Install Shiny Server
sudo apt install gdebi-core
wget https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.7.907-amd64.deb
sudo gdebi shiny-server-1.5.7.907-amd64.deb

# Enable autostart after boot
sudo systemctl enable shiny-server  

# Clone git repository with shiny apps
ls /srv/shiny-server
sudo mv /srv/shiny-server /srv/shiny-server.bak
sudo git clone https://github.com/AlexEngelhardt/shiny-server.git /srv/shiny-server/
sudo cp /srv/shiny-server.bak/sample-apps /srv/shiny-server/

# TODO Shiny Server Admin Guide: http://docs.rstudio.com/shiny-server/
