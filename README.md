# BugTracker (test task)

## RoR

- Ruby 1.9.3p550
- Rails 3.2.21
- MySql Ver 14.14 Distrib 5.5.40, for debian-linux-gnu (x86_64)

You need to set your database settings in `/cofig/database.yml` and smtp.gmail setting in `/config/initializers/setup_mail.rb` before launching. MySql dump is in `db_dump.sql`.

## Interface

### User Does

Root dir is ticket adding form. User fills the form and receives a confirmation email. There are two links in the email: to a current issue ticket (E.G. `/AAA-000000`) and to all his issue tickets (E.G. `/email/em@i.l`). User follows first link and confims the issue ticket. The status of ticket changes on *'Waiting for Staff Response'*. Now, managers can see this ticket.

### Manager Does

Manager should login (`/login`). There are two records in database for managers:

1.
	- login: `foo`
	- password: `bar`
2.
	- login: `bar`
	- password: `foo`

After logining manager are redirected to `/ticket`. It is the main interface of managers. Manager may choose issue tickets using dropdown select or searching it by `key` or `subject`.
*Show* links refer to pages with issue tickets and replies. Manager may wath replies and add another one using this link. If manager adds a reply, user's getting an email.
