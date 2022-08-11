FROM ubuntu:20.04

MAINTAINER pengfei <yuepf01@jsfund.cn>

ENV DEBIAN_FRONTEND=noninteractive

# Add user
RUN adduser --quiet --disabled-password qtuser && usermod -a -G audio qtuser

# This fix: libGL error: No matching fbConfigs or visuals found
ENV LIBGL_ALWAYS_INDIRECT=1

COPY source.list /etc/apt/sources.list

# Install Python 3, PyQt5
RUN apt-get update && apt-get install -y python3 python3-pip libglib2.0-dev libgl1-mesa-glx libnss3 libxcomposite-dev libxdamage1 libxrender1 libxrandr2 libfreetype6 libfontconfig libxcursor-dev libxi6 libxtst6 libxkbcommon-x11-0 libdbus-1-3 libasound2 libgssapi-krb5-2

WORKDIR /app
#COPY hello.py /tmp/hello.py
ADD code /app

# Using douban pipy mirror
RUN pip3 install -i https://pypi.douban.com/simple/ -U pip
RUN pip3 config set global.index-url https://pypi.douban.com/simple/
COPY requirements.txt .
RUN pip3 install --force-reinstall --no-deps PyQt5==5.14.1
RUN pip3 install -r requirements.txt

CMD ["python3", "-B", "pyqt/start.py"]
