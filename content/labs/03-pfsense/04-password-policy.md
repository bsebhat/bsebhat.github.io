---
title: 04 Password Policy
type: docs
---

The first layer of defense, blocking after multiple failed SSH login attempts, is being handled by the `fail2ban` service. The next layer, strong passwords, will add another way to prevent brute-force SSH attacks.

I was able to create the `support` Linux user with a weak password: `babygirl`. It was near the top of the wordlist that `hacker` used. And it took a few seconds for the `hydra` login cracker to reach. When I created it, I got a warning that said:
```
BAD PASSWORD: The password fails the dictionary check - it is based on a dictionary word
```

The CentOS Stream 9 operating system running on `juiceshop` uses the [cracklib](https://github.com/cracklib/cracklib) library to check if a password is in a dictionary. You can see the installed packages by running:
```
dnf list installed | grep cracklib
```

There are two packages:
```
cracklib.x86_64                       2.9.6-27.el9                                @anaconda     
cracklib-dicts.x86_64                 2.9.6-27.el9                                @anaconda
```


## PAM Password Requirements
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

This alone, requiring that a password pass the `cracklib` check, may be enough to prevent the SSH brute force attack that used the `hydra` login cracking tool.

However, when I (as the superuser `vmadmin` on `juiceshop`) set the password for that new user `support`, I was able to give it the weak password `babygirl`. It just gave me a warning message that it was found in the dictionary.

I've heard that this is common in smaller and less formal organizations. It's better to give new accounts an easy to type first password, then suggest to the new users that they change it to a stronger one. However, this can be ignored by users, and the weak password can remain a huge vulnerability in the system.

## Set Password Strength Requirement
*NOTE: Because you're changing important system settings, it's a good idea to create a snapshot of the `juiceshop` VM first. You can shut it down, go to the View > Snaphots in the menu, and click the plus sign button.*

To change the password requirement to include a minimum length, and require at least one digit and special character (like `*#@&$`) I will change that line in the `/etc/pam.d/system-auth` file:
```
sudo vim /etc/pam.d/system-auth
```

The line is currently this:
```
password    requisite       pam_pwquality.so local_users_only
```

And I will change it to this:
```
password    requisite     pam_pwquality.so local_users_only retry=3 minlen=10 dcredit=-1 ucredit=-1 ocredit=-1 lcredit=-1 dictcheck=1
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

## Communicate Password Policy
A huge vulnerability in securing systems, like the server `juiceshop`, is humans. They have to remember and type passwords, and it's easier to keep using a simple one if they're not forced to stop.

And coming up with a strong password is a huge hastle. It would be helpful to provide a link to a reputable online password generator that can generate new passwords based on user defined criteria. One password generator is the 1Password Strong Password Generator at [https://1password.com/password-generator](https://1password.com/password-generator). New users to `juiceshop` can be given this link, and the password requirements needed to generate a random strong password to use on `juiceshop`.

I create a bash script at `/usr/local/bin/show_password_policy.sh`:
```
sudo vim /usr/local/bin/show_password_policy.sh
```

It will print the password policy using the `echo` command:
```bash
#!/bin/bash
echo "Hello. Here's the password policy:"
echo "Minimum length 10 characters"
echo "At least one number"
echo "At least one uppercase letter"
echo "At least one lowercase letter"
echo "At least one special character"
echo "Cannot be a commonly used password"
echo "You can use an online password generator, like this:"
echo "https://1password.com/password-generator/"
```

I make the bash script executable:
```
sudo chmod +x /usr/local/bin/show_password_policy.sh
```

To get it to run for all accounts with the bash script, I modify the `/etc/profile` file:
```
sudo vim /etc/profile
```

And I add this to the end of the file:
```bash
if [ ! -f $HOME/.first_login ]; then
    /usr/local/bin/show_password_policy.sh
    touch $HOME/.first_login
fi
```

It will execute the `/opt/show_password_policy.sh` when a user logs in the first time. It determines if it's the first time by checking if the `.first_login` emptry file exists in the `$HOME` directory.

This will only display when the user logs in with the console. Not when the user first logs in using a graphical desktop environment, like GNOME or KDE. But I think that's fine, because the `juiceshop` VM is configured as a server, is accessed from its direct terminal or via SSH, and doesn't use a desktop environment.

TODO: Correct this so password policy is called by PAM. Not currently working.

## Test New User Password Policy
Previously, I used the superuser `vmadmin` to create a weak password for the new user `support`, and allowed them to keep using it after they logged in. This created an attack surface for `hacker` to exploit, and the password was discovered using a brute force login cracking tool.

This time, I will create a new user with a strong password that follows the password policy I created in the `/etc/pam.d/system-auth` file. I will share that initial password with the new user (let's say I wrote it on a paper and handed it to them and told them to eat it after using it). And they will be required to enter a new password.

I create a new user named `jim`:
```
sudo adduser jim
```

I give it a strong password I generated online (for example: `*nB-myEfi1`):
```
sudo passwd jim
```

Then, set the password for `jim` to expire, so the user has to change it on next login:
```
sudo passwd --expire jim
```

To test it out, you can SSH into `juiceshop` as `jim`:
```
ssh jim@juiceshop
```

Because this is the first time, you should see the password policy message. Then, you must enter the CURRENT password you just entered, the initial one created. Then, you enter the NEW password.
