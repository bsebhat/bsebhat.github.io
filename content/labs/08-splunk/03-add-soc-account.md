---
title: 03 Add SOC Account
type: docs
---

The `splunk` server has an admin user account that I can use from `sysadmin`, but I think I'll create a lower-privilege account for the `soc-analyst` to use. They just need to monitor the events, while the `sysadmin` can have the admin account to make important changes to Splunk.

Splunk Enterprise allows you to create [roles](https://docs.splunk.com/Documentation/Splunk/9.1.1/Admin/Aboutusersandroles) that can be granted limited privileges. So if I want to allow SOC staff to search for events when investigating incidents, I can create a low-priviege role with certain capabilities, and create a user accounts that have that role. This can give them the ability to search, and create and edit saved searches, but not full admin privileges.

## Create soc-staff Splunk Role
First, I'll create a new role called for members of the SOC team. I go to the Settings menu and select "Roles". I create a new role, and call it "soc-staff".

I'll give it these capabilities:
1. search
2. list_storage_passwords
3. schedule_search
4. edit_search_schedule_window

I'll also add the juicero index as incuded and default, because that is the main reason they will use it for now.

## Create soc-analyst Splunk User
Now I can create a user called soc-analyst, with the role soc-staff. This gives them the capabilities I gave the soc-staff role.

I can also set their default app to "Search", because that's what they'll be using Splunk for.

## Login As soc-analyst
From the `soc-analyst` VM, I can login using that new account. It asks that I change the password because it's the first time loggin in.

I'm brought to the Search app by default after logging in. I can search the juicero index, and create a report. However, I can't search other indexes, like the "_internal" index. And the "Settings" menu has fewer items than you see for the admin user.