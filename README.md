## Command Line AWS

I get tired of constantly copying and pasting the public DNS addresses of the hosts in my Amazon Web
Services account.  This gem will do the following things well:

1. It will allow you to get a text based interface of the status of your hosts like you use in the
   AWS console.
1. It will give you a choice of which host to connect to and automatically ssh you to it.

![Screenshot](http://i.imgur.com/m7thC.png)

1. Integrate with Capistrano definitions so that one can filter listings by environment and roles.

I would like to start with the EC2 services but branch out into the others as well like RDS when the
time comes.
