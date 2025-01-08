FROM scrapinghub/scrapinghub-stack-scrapy:2.12

WORKDIR /app

RUN apt-get update && apt-get install -y \
    curl gnupg iproute2 \
    && curl -fsSL https://pkgs.tailscale.com/stable/debian/bullseye.gpg | gpg --dearmor -o /usr/share/keyrings/tailscale-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/tailscale-archive-keyring.gpg] https://pkgs.tailscale.com/stable/debian bullseye main" > /etc/apt/sources.list.d/tailscale.list \
    && apt-get update && apt-get install -y tailscale \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Environment variables
ENV PLAYWRIGHT_BROWSERS_PATH=/playwright-browsers
TS_AUTHKEY="placeholder"

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt \
    && playwright install --with-deps chromium \
    && chmod -Rf 777 $PLAYWRIGHT_BROWSERS_PATH

# Set Scrapy settings
ENV SCRAPY_SETTINGS_MODULE=scrapy_playwright_cloud_example.settings

# Copy the application code
COPY . /app
RUN python setup.py install

# Zyte required scripts
COPY start-crawl /app/start-crawl
COPY shub-image-info /app/shub-image-info

RUN ln -s /app/start-crawl /usr/sbin/start-crawl \
    && ln -s /app/shub-image-info /usr/sbin/shub-image-info

# Ensure scripts are executable
RUN chmod +x /app/start-crawl /app/shub-image-info

# Copy and make the entrypoint script executable
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh


ENTRYPOINT ["/app/entrypoint.sh"]
