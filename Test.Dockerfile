FROM nodered/node-red-docker:rpi
#FROM resin/rpi-raspbian:jessie
#FROM audumla/audiot-rpi-nodered
USER root
RUN sudo apt-get update && apt-get install build-essential python-dev python-openssl git -y 
RUN apt-get install python-rpi.gpio
RUN pwd

WORKDIR /home/pi 
RUN git clone https://github.com/adafruit/Adafruit_Python_DHT.git 
RUN apt-get install -y python-setuptools 
WORKDIR /home/pi/Adafruit_Python_DHT 
CMD python setup.py install 
RUN python setup.py install 

RUN apt-get install python-pip

WORKDIR /home/pi
RUN git clone https://github.com/adafruit/Adafruit_Python_BMP.git
WORKDIR /home/pi/Adafruit_Python_BMP
RUN python setup.py install 

WORKDIR /home/pi
RUN git clone https://github.com/janwh/dht22-mqtt-daemon.git 
WORKDIR /home/pi/dht22-mqtt-daemon 
RUN pip install -r requirements.txt

RUN echo [mqtt] > config.ini && \ 
echo >> config.ini && \ 
echo hostname = 192.168.178.74 >> config.ini && \ 
echo port = 1883 >> config.ini && \ 
echo timeout = 60 >> config.ini && \ 
echo topic = home/office/temp >> config.ini && \ 
echo >> config.ini && \ 
echo [sensor] >> config.ini && \ 
echo >> config.ini && \ 
echo pin = 4 >> config.ini && \ 
echo type = dht22 >> config.ini && \ 
echo interval = 60 >> config.ini && \ 
echo decimal_digits = 4 >> config.ini

WORKDIR /home/pi

RUN echo i2c-bcm2708 >> /etc/modules && \
echo i2c-dev >> /etc/modules
RUN apt-get install python-smbus i2c-tools git

WORKDIR /home/pi/dht22-mqtt-daemon 

ENTRYPOINT python mqtt-dht.py