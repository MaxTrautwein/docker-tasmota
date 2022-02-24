FROM python:latest

LABEL description="Docker Container with a complete build environment for Tasmota using PlatformIO" \
      version="9.4" \
      maintainer="blakadder_" \
      organization="https://github.com/tasmota"       

# Install platformio. 
RUN pip install --upgrade pip &&\ 
    pip install --upgrade platformio

# Init project
COPY init_pio_tasmota /init_pio_tasmota

# Install project dependencies using a init project.
RUN cd /init_pio_tasmota &&\ 
    pio run &&\
    cd ../ &&\ 
    rm -fr init_pio_tasmota &&\ 
    cp -r /root/.platformio / &&\ 
    chmod -R 777 /.platformio

RUN platformio upgrade

RUN platformio platform update

RUN platformio platform install https://github.com/tasmota/platform-espressif32/releases/download/v2.0.2/platform-tasmota-espressif32-2.0.2.zip --with-package framework-arduinoespressif32

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

