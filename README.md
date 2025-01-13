# `scrapy-playwright` sample project for Scrapy Cloud

Running [`scrapy-playwright`](https://github.com/elacuesta/scrapy-playwright)
on [Zyte Scrapy Cloud](https://www.zyte.com/scrapy-cloud/).


### Dockerfile

A [Dockerfile](Dockerfile) is provided to build a custom docker image. To keep the
resulting image small, only the `chromium` browser is installed by default.


### Build and deploy

* Make sure you have [`shub`](https://shub.readthedocs.io/en/stable/index.html) installed
* run ./deploy.sh <project-id>
