# docker-F.U.N.K.O.
Flask, uWSGI, NGINX, kerberos, and OpenSUSE in a docker image

Just a Dockerfile (and friends) to build:
 * an [OpenSUSE](https://hub.docker.com/_/opensuse/) image
 * running a [Flask](http://flask.pocoo.org/) application
 * served by [uWSGI](http://uwsgi-docs.readthedocs.io/en/latest/) and [nginx](https://www.nginx.com/)
 * monitored by [circus](http://circus.readthedocs.io/en/latest/)
 * for querying a [MS sql database](https://docs.microsoft.com/en-us/sql/connect/odbc/linux/installing-the-microsoft-odbc-driver-for-sql-server-on-linux)
 * using [kerberos authentication](https://www.eyrie.org/~eagle/software/kstart/)

Much inspiration taken from [tiagngolo/uwsgi-nginx-docker](https://github.com/tiangolo/uwsgi-nginx-flask-docker). See his documentation for more details
