#FROM scrapinghub/scrapinghub-stack-scrapy:2.12
#FROM python:3.11-slim
#
#WORKDIR /app
#
## Install Tailscale and additional tools
#RUN apt-get update && apt-get install -y \
#    curl gnupg iproute2 procps net-tools jq \
#    && curl -fsSL https://pkgs.tailscale.com/stable/debian/bullseye.gpg | gpg --dearmor -o /usr/share/keyrings/tailscale-archive-keyring.gpg \
#    && echo "deb [signed-by=/usr/share/keyrings/tailscale-archive-keyring.gpg] https://pkgs.tailscale.com/stable/debian bullseye main" > /etc/apt/sources.list.d/tailscale.list \
#    && apt-get update && apt-get install -y tailscale \
#    && apt-get clean && rm -rf /var/lib/apt/lists/*
#
## Environment variables
#ENV PLAYWRIGHT_BROWSERS_PATH=/playwright-browsers
#ENV TS_AUTHKEY="tskey-client-kWZGsfej1e11CNTRL-Zv3jx6EpBMcM7FttLEtpLcWGQSYtjCPUK"
#
## Install Python dependencies
#COPY requirements.txt .
#RUN pip install --no-cache-dir --upgrade pip \
#    && pip install --no-cache-dir -r requirements.txt \
#    && playwright install --with-deps chromium \
#    && chmod -Rf 777 $PLAYWRIGHT_BROWSERS_PATH
#
## Set Scrapy settings
#ENV SCRAPY_SETTINGS_MODULE=scrapy_playwright_cloud_example.settings
#
## Copy the application code
#COPY . /app
#RUN python setup.py install
#
## Copy custom start-crawl script
#COPY custom-start-crawl /usr/local/bin/start-crawl
#RUN chmod +x /usr/local/bin/start-crawl


#FROM scrapinghub/scrapinghub-stack-scrapy:2.12
#
#WORKDIR /app
#
## Install required tools and Tailscale
#RUN apt-get update && apt-get install -y \
#    curl gnupg jq iproute2 procps netcat-traditional iputils-ping net-tools \
#    && curl -fsSL https://pkgs.tailscale.com/stable/debian/bullseye.gpg | gpg --dearmor -o /usr/share/keyrings/tailscale-archive-keyring.gpg \
#    && echo "deb [signed-by=/usr/share/keyrings/tailscale-archive-keyring.gpg] https://pkgs.tailscale.com/stable/debian bullseye main" > /etc/apt/sources.list.d/tailscale.list \
#    && apt-get update && apt-get install -y tailscale \
#    && apt-get clean && rm -rf /var/lib/apt/lists/*
#
## Copy application code and install Python dependencies
#COPY requirements.txt .
#RUN pip install --no-cache-dir --upgrade pip \
#    && pip install --no-cache-dir -r requirements.txt
#
#COPY . /app
#RUN python setup.py install
#
## Copy and make the run script executable
#COPY run.sh /app/run.sh
#RUN chmod +x /app/run.sh
#
## Default command for debugging
#CMD ["/bin/bash"]


FROM nginx:bullseye
WORKDIR /app
RUN apt-get update \
    && apt-get install -y curl procps gnupg jq iproute2 netcat-traditional iputils-ping net-tools
RUN curl -fsSL https://pkgs.tailscale.com/stable/debian/bullseye.gpg | gpg --dearmor -o /usr/share/keyrings/tailscale-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/tailscale-archive-keyring.gpg] https://pkgs.tailscale.com/stable/debian bullseye main" > /etc/apt/sources.list.d/tailscale.list
RUN apt-get update \
    && apt-get install -y tailscale
