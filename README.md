### TextBelt Open Source
Forked from [typpo/textbelt](https://github.com/typpo/textbelt) (unmaintained)

TextBelt Open Source is a REST API that sends outgoing SMS.  It uses a free mechanism for sending texts, different from the more reliable paid version available at https://textbelt.com.

This project uses carrier-specific gateways to deliver your text messages for free, and without ads.  The service is fairly reliable when configured on a private server and has sent over 1 million texts.

Send a text with a simple POST request:

```sh
$ curl -X POST http://my_textbelt_server/text \
   -d number=5551234567 \
   -d "message=I sent this message for free with Textbelt"
```

`number` and `message` parameters are required.

### Success and Failure
Sample success:

```json
{"success":true}
```

Note that success means that the message was sent to Textbelt's list of providers.  We can't guarantee delivery on your network.

Sample failure:

```json
{"success":false,"message":"Exceeded quota for this phone number."}
```


### Usage as a standalone server

Textbelt can be run as a standalone server with [Docker](https://docs.docker.com/engine/install/). There is an example `compose.yml` file in this repo to use with [Docker Compose](https://docs.docker.com/compose/compose-file/). To run the standalone server:

- Install [Docker](https://docs.docker.com/engine/install/)
- (Optional) follow the docker [post-installation steps](https://docs.docker.com/engine/install/linux-postinstall/)
- Clone this repo: `git clone git@github.com:sensor-climate-control/textbelt.git`
- Move into the repo directory: `cd textbelt`
- Create an file named `.env`, like this:
  ```
  SMTP_HOST="smtp.example.com"
  SMTP_PORT="587"
  SMTP_USER="admin@example.com"
  SMTP_PASS="examplepassword"
  SMTP_FROM="'Alerts' <alerts@example.com>"
  ```
  - You can use your own mail server, or use an email service like Gmail as the SMTP relay
  - If you're using Gmail, you have to set up an App Password:
    1. Go to https://myaccount.google.com/security
    2. Under "How you sign in to Google", click on "2-Step Verificiation"
    3. Scroll down to the bottom and click "App passwords"
    4. Under "Select the app and device you want to generate the app password for.", select "Mail" as the app and "Other (custom name)" as the device. Enter an identifiable name. Then click Generate.
    5. Copy this app password and enter it into the `SMTP_PASS` field of `.env`
  - Using Gmail, `.env` would look like this:
  ```
  SMTP_HOST="smtp.gmail.com"
  SMTP_PORT="587"
  SMTP_USER="example@gmail.com"
  SMTP_PASS="exampleapppassword"
  SMTP_FROM="'Alerts' <example@gmail.com>"
  ```
- Start the docker containers: `docker compose up -d`
- Done! The server should be listening at port 9099.


### Usage as a module

Though this repository contains an express server so you may run your own
instance of the web app, you may also use it to send text messages in your
project.

#### Configuration:

This project uses [`nodemailer`](https://www.npmjs.com/package/nodemailer) for sending emails. Set up `lib/config.js` with the following:

- **`transport`** should be a Nodemailer transport [documented here](https://nodemailer.com/plugins/create/#transports)
- **`mailOptions`** fields should include at least include the `from` field, but you can include any of the fields [documented here](https://nodemailer.com/message/).

A sample transport with SMTP sending is included.

For example, to send a text using the default settings:

```js
var text = require('textbelt');

text.send('9491234567', 'A sample text message!', undefined, function(err) {
  if (err) {
    console.log(err);
  }
});
```

You can also supply a region (valid choices are `us`, `intl`, or `canada`)

```js
var text = require('textbelt');

// Canada
text.send('9491234567', 'A sample text message!', 'canada', function(err) {
...
});

// International
text.send('1119491234567', 'Bonjour!', 'intl', function(err) {
...
});
```

### Canadian and International endpoints

The /text endpoint supports U.S. phone numbers (and parts of Canada).

For Canadian texts, curl `http://textbelt.com/canada`.

For international texts, curl `http://textbelt.com/intl`.

Canadian and international support may not be complete.  Refer to the list of supported carriers.

### Textbelt Clients

  * ruby - [djds23/textbelt-gem](https://github.com/djds23/textbelt-gem)
  * go - [dietsche/textbelt](https://github.com/dietsche/textbelt), [lateralusd/textbelt](https://github.com/lateralusd/textbelt)
  * python - [ksdme/py-textbelt](https://github.com/ksdme/py-textbelt)
  * node.js - [minond/textbelt](https://github.com/minond/textbelt), [ajay-gandhi/textbelt](https://github.com/ajay-gandhi/textbelt), [soondobu/mtextbelt](https://github.com/soondobu/mtextbelt)
  * php - [ctrlaltdylan/courier](https://github.com/ctrlaltdylan/courier), [securingsincity/phpsms](https://github.com/securingsincity/phpsms)
  * bash - [cfalk/MessageMe](https://github.com/cfalk/MessageMe)
  * html/js/mobile webpage - [mLuby/SMS](https://github.com/mLuby/smsHR), [daluu/textbelt-clients](https://github.com/daluu/textbelt-clients)
  * Browser extension - [Chrome](https://chrome.google.com/webstore/detail/textbelter/clciehobfheendclpnmbgbalelignpoa), [Firefox](https://addons.mozilla.org/en-US/firefox/addon/textbelter/), [Safari](https://github.com/daluu/textbelt-clients/raw/master/textbelter.safariextz), [Opera](https://addons.opera.com/en/extensions/details/textbelter/?display=en)
  * Windows Phone - [TextBelter](https://www.microsoft.com/en-us/store/apps/textbelter/9nblggh1z2dg)
  * [SendSMS Mac App](https://itunes.apple.com/app/sendsms/id584131262?mt=12)
  * [OSX dashboard widget](https://github.com/daluu/textbelt-clients/releases/download/1.0/TextBelter.wdgt.zip)
  * [Windows 7/Vista gadget](https://github.com/daluu/textbelt-clients/releases/download/1.0/textbelter.gadget.zip)


### Notes and Limitations

 * Some carriers are picky about which messages they deliver. A "success" response from Textbelt means that your message was given to the carrier.

 *  Some carriers may deliver text messages from "txt@textbelt.com", "foo@bar.com", or whatever you have configured as `fromAddress` in `lib/config.js`.

 *  Supported U.S. carriers: Alltel, Ameritech, AT&T Wireless, Boost, CellularOne, Cingular, Edge Wireless, Nex-Tech Wireless, Project Fi, Sprint PCS, Telus Mobility, T-Mobile, Metro PCS, Nextel, O2, Orange, Qwest, Rogers Wireless, Ting, US Cellular, Verizon, Virgin Mobile.

 *  Supported U.S. and Canadian carriers (/canada):  3 River Wireless, ACS Wireless, AT&T, Alltel, BPL Mobile, Bell Canada, Bell Mobility, Bell Mobility (Canada), Blue Sky Frog, Bluegrass Cellular, Boost Mobile, Carolina West Wireless, Cellular One, Cellular South, Centennial Wireless, CenturyTel, Cingular (Now AT&T), Clearnet, Comcast, Corr Wireless Communications, Dobson, Edge Wireless, Fido, Golden Telecom, Helio, Houston Cellular, Idea Cellular, Illinois Valley Cellular, Inland Cellular Telephone, MCI, MTS, Metro PCS, Metrocall, Metrocall 2-way, Microcell, Midwest Wireless, Mobilcomm, Nextel, OnlineBeep, PCS One, President's Choice, Public Service Cellular, Qwest, Republic Wireless, Rogers AT&T Wireless, Rogers Canada, Satellink, Solo Mobile, Southwestern Bell, Sprint, Sumcom, Surewest Communicaitons, T-Mobile, Telus, Tracfone, Triton, US Cellular, US West, Unicel, Verizon, Virgin Mobile, Virgin Mobile Canada, West Central Wireless, Western Wireless

 *  Supported international carriers (/intl):  Chennai RPG Cellular, Chennai Skycell / Airtel, Comviq, DT T-Mobile, Delhi Aritel, Delhi Hutch, Dutchtone / Orange-NL, EMT, Escotel, German T-Mobile, Goa BPLMobil, Golden Telecom, Gujarat Celforce, JSM Tele-Page, Kerala Escotel, Kolkata Airtel, Kyivstar, LMT, Lauttamus Communication, Maharashtra BPL Mobile, Maharashtra Idea Cellular, Manitoba Telecom Systems, Meteor, MiWorld, Mobileone, Mobilfone, Mobility Bermuda, Mobistar Belgium, Mobitel Tanzania, Mobtel Srbija, Movistar, Mumbai BPL Mobile, Netcom, Ntelos, O2, O2 (M-mail), One Connect Austria, OnlineBeep, Optus Mobile, Orange, Orange Mumbai, Orange NL / Dutchtone, Oskar, P&T Luxembourg, Personal Communication, Pondicherry BPL Mobile, Primtel, SCS-900, SFR France, Safaricom, Satelindo GSM, Simple Freedom, Smart Telecom, Southern LINC, Sunrise Mobile, Surewest Communications, Swisscom, Telcel Mexico, T-Mobile Austria, T-Mobile Germany, T-Mobile UK, TIM, TSR Wireless, Tamil Nadu BPL Mobile, Tele2 Latvia, Telefonica Movistar, Telenor, Teletouch, Telia Denmark, UMC, Uraltel, Uttar Pradesh Escotel, Vessotel, Vodafone Italy, Vodafone Japan, Vodafone UK, Wyndtell

### License (MIT)

TextBelt
Copyright (C) 2018 by Ian Webster

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
