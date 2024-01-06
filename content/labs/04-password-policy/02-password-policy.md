---
title: 02 Password Policy
type: docs
---

The first layer of defense, blocking after multiple failed SSH login attempts on the `juiceshop`, is being handled by the `fail2ban` service. The next layer, strong passwords, will add another way to prevent brute-force SSH attacks.

I was able to create the `support` Linux user on `juiceshop` with a weak password: `babygirl`. It was near the top of the wordlist that `hacker` used. And it took a few seconds for the `hydra` login cracker to reach. When I created it, I got a warning that said:
```
BAD PASSWORD: The password fails the dictionary check - it is based on a dictionary word
```

That's because I did it with the `sudo passwd support` command. If I logged in as `support` and tried to change my own password with the

The CentOS Stream 9 operating system running on `juiceshop` uses the [cracklib](https://github.com/cracklib/cracklib) library to check if a password is in a dictionary. You can see the installed packages by running:
```
dnf list installed | grep cracklib
```

There are two packages:
```
cracklib.x86_64                       2.9.6-27.el9                                @anaconda     
cracklib-dicts.x86_64                 2.9.6-27.el9                                @anaconda
```


## Current Password Policy
The Pluggable Authentication Module (PAM) in the operating system is configured to enforce that when users set new passwords, they cannot be found in the dictionary used by `cracklib-dicts`.

This is configured in the `/etc/pam.d/system-auth` file, in one of the lines that begin with `password`:
```
password    requisite       pam_pwquality.so local_users_only
```
This line has several parts:
1. `password`: This is the PAM management group, and is for password management operations. Like updating or changing or setting passwords. 
2. `requisite`: This means that the module (identified next) MUST succeed. So if a user is changing their password, and the module fails, they can't change their password.
3. `pam_pwquality.so`: This is the PAM module used to enforce password quality requirements. It's in here that the `cracklib` library is used to ensure passwords aren't in a dictionary. It used to be `pam_cracklib.so`.
4. `local_users_only`: This applies to local users only, not remote users. Remote users are users that have authentication managed by a seperate system. This can be with a server running Lightweight Directory Access Protocol (LDAP) or Kerberos. Like a user from an Active Directory domain that the CentOS server has joined.

That `pam_pwquality.so` module part, which uses the `cracklib` dictionary to check if the new password might appear in many wordlists used by login crackers, may be enough to prevent the SSH brute force attack that use tools, like the [hydra](https://en.wikipedia.org/wiki/Hydra_(software)) login cracking tool.

However, when I (as the superuser `vmadmin` on `juiceshop`) set the password for that new user `support`, I was able to give it the weak password `babygirl`. It just gave me a warning message that it was found in the dictionary.

I've heard that this is common in smaller and less formal organizations. It's better to give new accounts an easy to type first password, then suggest to the new users that they change it to a stronger one. However, this can be ignored by users, and the weak password can remain a huge vulnerability in the system.

## Change Password Policy
*NOTE: Because you're changing important system settings, it's a good idea to create a snapshot of the `juiceshop` VM first, in case there's a misconfiguration. You can shut it down, go to the View > Snaphots in the menu, and click the plus sign button.*
I want to change the password requirements, so that when a password is changed, it must meet the password requirements I've chosen to use these requirements for passwords:
```
1. At least 10 characters long.
2. At least one digit.
3. At least one uppercase letter.
4. At least one special character.
5. At least one uppercase letter.
6. Must not appear in a dictionary of commonly used passwords. 
```

To do this, I'll need to change the `/etc/pam.d/system-auth` file. There is a line that configures what must happen when a user changes a password. However, because this a very important file for the system, I'll be using the [Authselect](https://github.com/authselect/authselect) service installed on the CentOS operating system. This allows me to create a new custom profile, with a seperate version of important system configuration files (like `system-auth`). When I use that profile, I can make changes to `system-auth` while still having the ability to easily rollback to the previous configuration.

### Create Custom Authselect Profile
The password requirements can be defined in the `/etc/pam.d/system-auth` file. However, that file and authentication configuration files in the `/etc/pam.d` directory are managed by the [Authselect](https://github.com/authselect/authselect) service. It's a tool that standardizes the configuration of sensitive authentication configuration files like the `/etc/pam.d/system-auth` file.

Authselect uses profiles to manage different ways of configuring authentication for a system. I can see a list of profiles with this command:
```
sudo authselect list
```

I see this output:
```
- minimal                	 Local users only for minimal installations
- sssd                   	 Enable SSSD for system authentication (also for local users only)
- winbind                	 Enable winbind for system authentication
```

I can see the current Authselect profile being used:
```
sudo authselect current
```

It's the `sssd` profile.

I want to create a new custom profile so I can add my custom password requirements. I name it `strong-passwords`, and base it on the current profile, `sssd`:
```
sudo authselect create-profile strong-passwords -b sssd
```

I can see a list of available Authselect profiles again:
```
- minimal                	 Local users only for minimal installations
- sssd                   	 Enable SSSD for system authentication (also for local users only)
- winbind                	 Enable winbind for system authentication
- custom/strong-passwords	 Enable SSSD for system authentication (also for local users only)
```

I can change the description for my new custom profile `custom/strong-passwords` by changing the first line of the file `/etc/authselect/custom/strong-passwords/README`:
```
sudo vim /etc/authselect/custom/strong-passwords/README
```

It was copied over from the profile I based my custome profile on, `sssd`.

I can select that new custom profile:
```
sudo authselect select custom/strong-passwords
```

### Edit system-auth
I can then edit the `system-auth` file in my custom profile `strong-passwords`:
```
sudo vim /etc/authselect/custom/strong-passwords/system-auth
```

In that `system-auth` file in my `strong-passwords` authselect profile, I edit this line:
```
password    requisite                                    pam_pwquality.so local_users_only
```

to include my custom password requirements:
```
password    requisite     pam_pwquality.so local_users_only retry=4 minlen=10 dcredit=-1 ucredit=-1 ocredit=-1 lcredit=-1 dictcheck=1
```
The additional settings are:
1. `retry=4`: This gives the user 4 attempts to enter a password that meets the password requirements.
2. `minlen=10`: This requires the password is 10 characters long.
3. `dcredit=-1`: The password needs at least one digit.
4. `ucredit=-1`: The password needs at least one uppercase letter.
5. `ocredit=-1`: The password needs at least one special character.
6. `lcredit=-1`: The password needs at least one uppercase letter.
7. `dictcheck=1`: The password cannot appear in a dictionary of commonly used passwords.

This will require users to choose stronger passwords. However, superusers like `root` can still set weak passwords, or passwords found in dictionaries, and just get a warning. It would be helpful to the `vmadmin` superuser and other new users to communicate the password policy, and provide a way to generate one.

If I decide I want to go back to the previous Authselect profile, `sssd`, I can use the `authselect select` command:
```
sudo authselect select sssd
```

## Communicate New Password Policy
A huge vulnerability in securing systems, like the server `juiceshop`, is humans. They have to remember and type passwords, and it's easier to keep using a simple one if they're not forced to stop.

And coming up with a strong password is a huge hastle. It would be helpful to provide a link to a reputable online password generator that can generate new passwords based on user defined criteria. One password generator is the 1Password Strong Password Generator at [https://1password.com/password-generator](https://1password.com/password-generator). New users to `juiceshop` can be given this link, and the password requirements needed to generate a random strong password to use on `juiceshop`.

I create a bash script at `/usr/local/bin/show_password_policy.sh`:
```
sudo vim /usr/local/bin/show_password_policy.sh
```

This script will print the password requirements using the `echo` command:
```bash
#!/bin/bash
echo "====================================================="
echo "Guess what time it is? That's right. It's change your password time!"
echo "====================================================="
echo "Here's a friendly reminder of the password policy:"
echo "1. Minimum length is 10 characters"
echo "2. At least one number"
echo "3. At least one uppercase letter"
echo "4. At least one lowercase letter"
echo "5. At least one special character"
echo "6. Cannot be a commonly used password or word."
echo "You will get 4 attempts to change the password."
echo "If you're having a hard time thinking of a new one, you can use an online password generator like 1password:"
echo "https://1password.com/password-generator/"
```

I make the bash script executable:
```
sudo chmod +x /usr/local/bin/show_password_policy.sh
```

I want this message to be printed to the console whenever passwords are changed. I edit that file in my Authselect profile:
```
sudo vim /etc/authselect/custom/strong-passwords/system-auth
```

And I add this line to the beginning of the password section:
```
password requisite pam_exec.so stdout /usr/local/bin/show_password_policy.sh
```
The `pam_exec.so` module will execute that `show_password_policy.sh` shell script and the user will see it in the `stdout`. If they're using the `juiceshop` terminal or using SSH to login, it will print on the console.

*NOTE: This will only display when the user logs in with the console. Not when the user first logs in using a graphical desktop environment, like GNOME or KDE. But I think that's fine, because the `juiceshop` VM is configured as a server, is accessed from its direct terminal or via SSH, and doesn't use a desktop environment.*

And, because I changed the custom profile's `system-auth` file, I select it again to reload it:
```
sudo authselect select custom/strong-passwords with-sudo --force
```

I can see the current Authselect profile is the custom one I created:
```
sudo authselect current
```

Now, those authentication configuration files I edited in my custom Authselect profile will be used. If I want to go back, I can select the previous `sssd` profile:
```
sudo authselect select sssd
```

## Test New Password Policy
Previously, I used the superuser `vmadmin` to create a weak password for the new user `support`, and allowed them to keep using it after they logged in. This created an attack surface for `hacker` to exploit, and the password was discovered using a brute force login cracking tool.

This time, I will create a new user with a strong password that follows the password policy I created.

If this was a real life scenario, I would need to securely share that initial password with the new user. Let's say I wrote it on a paper and handed it to them. And they will be required to enter the initial password the first time, then change it to a password matching the requirements.

I create a new user named `jim`:
```
sudo adduser jim
```

Then, I give `jim` a strong initial password.
```
sudo passwd jim
```

For example, a password that matches the password requirements is:
```
*nB-myEfi1
```

NOTE: While I'm setting the password for a user using the `sudo passwd` command, I'm exempt from the password requirements. They will display warnings, but I can give a user any password I want. Even `password1`.

Then, I expire that initial password for `jim`.
```
sudo passwd --expire jim
```

This means that the next time someone logs in with `jim` and that initial password, they will have to immediately change it to a new password that matches those password requirements:

To test it out, you can SSH into `juiceshop` as `jim` using the initial password:
```
ssh jim@juiceshop
```

Because this is the first time, you should see a system message saying you are required to change the password. You'll be asked to re-enter the current password (the initial one):
```
WARNING: Your password has expired.
You must change your password now and login again!
Changing password for user jim.
Current password:
```

You must again enter the initial password you just entered.

Then, you will be asked to enter a new password. You should see the password policy message, giving the requirements for a password, printed:
```
=====================================================
Guess what time it is? That's right. It's change your password time!
=====================================================
Here's a friendly reminder of the password policy:
1. Minimum length is 10 characters
2. At least one number
3. At least one uppercase letter
4. At least one lowercase letter
5. At least one special character
6. Cannot be a commonly used password or word.
You will get 4 attempts to change the password.
If you're having a hard time thinking of a new one, you can use an online password generator like 1password:
https://1password.com/password-generator/
```

If you successfully change your password, you

If you're using SSH, and you are able to change your password, you will still be disconnected. You will need to reconnect, and enter the new password.