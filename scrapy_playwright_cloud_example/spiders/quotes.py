from scrapy import Request, Spider
from scrapy_playwright.page import PageMethod


class QuotesSpider(Spider):
    name = "quotes"

    def start_requests(self):
        yield Request(
            url="http://quotes.toscrape.com/scroll",
            meta={
                "playwright": True,
                "playwright_page_methods": [
                    PageMethod("wait_for_selector", "div.quote"),
                    PageMethod("evaluate", "window.scrollBy(0, document.body.scrollHeight)"),
                    PageMethod("wait_for_selector", "div.quote:nth-child(11)"),
                    PageMethod(
                        "screenshot",
                        path="quotes_screenshot.png",
                        full_page=True
                    ),
                ],
            },
        )

    async def parse(self, response):
        for quote in response.css("div.quote"):
            yield {
                "text": quote.css("span.text::text").get(),
                "author": quote.css("small.author::text").get(),
                "tags": quote.css("a.tag::text").getall(),
            }
