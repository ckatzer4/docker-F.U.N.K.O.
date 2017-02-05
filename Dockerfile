FROM opensuse:latest

MAINTAINER Charles Katzer <cpkatzer@gmail.com>

# made with much inspiration from tiagngolo/uwsgi-nginx-docker
# but with a different base image
# and added microsoft sql/kerberos dependencies

# freshen up
RUN zypper --non-interactive update

# install build and python dependencies
RUN zypper --non-interactive install wget tar make tk-devel tcl-devel gcc gcc-c++ python3-devel

# install python
RUN zypper --non-interactive install python3 python3-pip

# update pip
RUN pip install --upgrade pip

# install pip packages
RUN pip install Flask Flask-WTF circus uwsgi

# replace krb5-mini with krb5 
RUN zypper --non-interactive install --force-resolution krb5 krb5-client krb5-devel

# install k5start from source
RUN wget http://archives.eyrie.org/software/kerberos/kstart-4.2.tar.gz -O /tmp/kstart-4.2.tar.gz \
 && cd /tmp/ \
 && tar xzvf /tmp/kstart-4.2.tar.gz \
 && cd /tmp/kstart-4.2/ \
 && ./configure \
 && make \
 && make install \
 && cd / \
 && rm -rf /tmp/kstart-4.2*

# install Microsoft odbc driver
RUN zypper --non-interactive ar  https://packages.microsoft.com/yumrepos/mssql-suse12-release/ "mssql" \
 && wget "http://aka.ms/msodbcrhelpublickey/dpgswdist.v1.asc" -O /tmp/dpgwsdist.v1.asc \
 && rpm --import /tmp/dpgwsdist.v1.asc \
 && wget "https://apt-mo.trafficmanager.net/keys/microsoft.asc" -O /tmp/microsoft.asc \
 && rpm --import /tmp/microsoft.asc \
 && zypper --non-interactive update \
 && ACCEPT_EULA=Y zypper --non-interactive install msodbcsql mssql-tools \
 && zypper --non-interactive install unixODBC-utf16-devel \
 && rm /tmp/dpgwsdist.v1.asc /tmp/microsoft.asc

# install pyodbc now that unixODBC is installed
RUN pip install pyodbc

# install and configure nginx for uwsgi
RUN zypper --non-interactive install nginx
# Overwrite the nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf
# Copy the base uWSGI ini file to enable default dynamic uwsgi process number
RUN mkdir /etc/uwsgi/
COPY uwsgi.ini /etc/uwsgi/

# configure circusd
RUN mkdir /etc/circusd/
COPY circusd.ini /etc/circusd/circusd.ini

# copy in kerberos configuration
COPY krb5.conf /etc/krb5.conf
COPY krb5.keytab /etc/krb5.keytab

# copy in the application directory
COPY ./app /app
WORKDIR /app

# get the show on the road
CMD ["/usr/bin/circusd", "/etc/circusd/circusd.ini"]
