#Script to automate tar creation
myname="Abhilasha"
s3bucket="upgrad-abhilasha"
timestamp=$(date '+%d%m%Y-%H%M%S')
sudo apt update -y
packages_status=$(dpkg-query --show --showformat='${db:Status-Status}' 'apache2' | grep "installed")
echo "Debug: $packages_status"
if [ $packages_status -ne "installed" ]
then
        sudo apt install apache2

else
        echo "Apache2 is installed"
fi
apache_run_status=$(sudo systemctl status apache2.service | grep "active (running)")
echo "Debug: $apache_run_status"
if [ $apache_run_status -ne 'active (running)'  ]
then
sudo systemctl start apache2.service
else
        echo "Apache2 server is already running"
fi
apache_enable_status=$(sudo systemctl status apache2.service | grep "enabled")
echo "Debug: $apache_enable_status"
if [ $apache_enable_status -ne 'enabled' ]
then
sudo systemctl enable apache2
else
        echo "Apache2 server is already enabled"
fi
cd /tmp/
tar -cvf ${myname}-httpd-logs-${timestamp}.tar /var/log/apache2/*.log
aws s3 cp /tmp/${myname}-httpd-logs-${timestamp}.tar s3://${s3bucket}/${myname}-httpd-logs-${timestamp}.tar
cd -
