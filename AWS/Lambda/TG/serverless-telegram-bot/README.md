## Serverless Telegram bot on AWS Lambda


### Requirements
 1. Python 3
 2. Node.js v6.5.0 or later
 3. AWS account with Admin rights

### Deploying

Install Serverless framework:

`npm install -g serverless`

Export credentials:

```
export AWS_ACCESS_KEY_ID=<Access key ID>
export AWS_SECRET_ACCESS_KEY=<Secret access key>
export TELEGRAM_TOKEN=<Your Telegram Token>
```

Install pip requirements:

`pip install -r requirements.txt -t vendored`

Deploy to AWS:

`serverless deploy`


After deployment you'll have something like that:

```
endpoints:
POST - https://u3ir5tjcsf.execute-api.us-east-1.amazonaws.com/dev/my-custom-url
```
To set a telegram webhook run the command:

```
curl --request POST --url https://api.telegram.org/bot459903168:APHruyw7ZFj5qOJmJGeYEmfFJxil-z5uLS8/setWebhook --header 'content-type: application/json' --data '{"url": "https://u3ir5tjcsf.execute-api.us-east-1.amazonaws.com/dev/my-custom-url"}'
```

And if you did it right you'll have the output like this one:
```
{
  "ok": true,
  "result": true,
  "description": "Webhook was set"
}
```