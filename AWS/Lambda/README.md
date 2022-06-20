# LAMBDA

## Lambda functions

- [CreateS3Bucket](https://github.com/prankbox/devops_mentorship/tree/lambda/AWS/Lambda/CreateS3Bucket)
- [ListS3Buckets](https://github.com/prankbox/devops_mentorship/tree/lambda/AWS/Lambda/ListS3Buckets)

## Telegram Bot snippet
```
def msgSend(text, chat_id):
    url = URL + "sendMessage?text={}&chat_id={}".format(text, chat_id)
    response = requests.get(url)
    content = response.content.decode("utf8")
    return content


def handle(msg):
    sender = msg['from']['username']
    id_gruppo = msg['chat']['id']
    if sender == NAME:
        testo = msg['text']
        usernames = [x.replace('@','') for x in rx.findall(text)]
        map(foo, usernames)
        msgSend(confirm_mess, id_group)
        return


def main(event, context): 
    response = ast.literal_eval(event['body'])
    handle(response['message'])
    return {
        'something': 'something'
    }
    ```