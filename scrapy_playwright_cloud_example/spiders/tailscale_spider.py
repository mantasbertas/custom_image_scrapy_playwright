from scrapy import Spider, Request


class MyTailscaleSpider(Spider):
    name = "my_tailscale_spider"

    def start_requests(self):
        url = "https://httpbin.org/ip"
        headers = {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
        }
        yield Request(
            url=url,
            headers=headers,
            callback=self.parse
        )

    def parse(self, response):
        if response.status == 200:
            ip_data = response.json()
            ip_address = ip_data.get("origin")  # For httpbin.org
            if ip_address:
                print(f"Detected IP address: {ip_address}")
            else:
                print("Could not retrieve IP address from response.")
        else:
            print(f"Failed to fetch IP. Status: {response.status}, Response: {response.text}")
