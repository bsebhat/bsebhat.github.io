---
title: 03 Use Splunk Search
type: docs
---

Currently, the access logs form the web app running on `juiceshop` are being forwarded to the Splunk Enterprise server running on `splunk`.

And I can use the `soc-analyst` VM to log in to the Splunk web portal at `http://splunk:8000` and view the log data using the Search app. It's easier than reading the log files on the `juiceshop` server.

## Splunk Search
TODO: add explanation on searching for juice-shop log data



## Splunk Log Event View
To show how user interaction with the web app shows in the log data on `splunk`, I can use the `customer` VM to submit anonymous feedback. When you go to the `http://splunk:8000`, open the Search app, and search for `index="juiceshop"`, you see the log data. Splunk parses it, and extracts certain fields.

On the `juiceshop` VM, the Splunk Forwarder configuration file that describes the log data being forwarded is `/opt/splunkforwarder/etc/system/local/inputs.conf`. It gives the location of the log files to forward, and the index that they should be added to on the Splunk Enterprise server on the `splunk` VM:
```
[monitor:///opt/juice-shop/logs/access*]
index = juiceshop
```

An example of a single entry in one of the juice-shop access log files in the `/opt/juice-shop/logs/` directory is this:
```
::ffff:192.168.1.100 - - [25/Dec/2023:00:19:00 +0000] "GET /rest/products/search?q= HTTP/1.1" 304 - "http://juiceshop:3000/" "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0"
```

By default, the log file source type is Apache access log:
```
"%h %l %u %t \"%r\" %>s %b"
```
TODO: explain log format parts

When I look at the event via the Splunk web console, it is parsed and easily readable here:
TODO: add screenshot of log event in Splunk

## Improve Splunk Event View
But, more specifically, this is the "combined" log format. That format is:
```
"%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-agent}i\"
```

I can modify the `/opt/splunkforwarder/etc/system/local/inputs.conf` Splunk Forwarder config file on `juiceshop` to say the log data is in the `access_combined` sourcetype:
```
[monitor:///opt/juice-shop/logs/access*]
index = juiceshop
sourcetype = access_combined
```

Now, when I use the juice-shop web app to create new log data, and check the Splunk search app again for the same `juice-shop` index, the new log events have the sourcetype `access_combined`, and they're parsed to look like this:
TODO: insert screenshot of log event with access_combined sourcetype

This helps users to easily see fields in the log events, and they can easily be used to search and create alerts. For example, you can see the HTTP status code is extracted when the sourcetype is `access_combined`. That can be used to filter events for specific error codes during a security incident investigation. If you look on the "Interesting Fields" list on the left, there are options to filter by "Status". There are two types that were found in the search results: [200 OK](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/200) and [401 Unauthorized](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/401). In a situation where a user may have been attempting to gain unauthorized access, or performing reconnasaince, having your log data sourcetypes "fine-tuned" in advance can save you the time of pouring through log data entries or creating regular expression filters.