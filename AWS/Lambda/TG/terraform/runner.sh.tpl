curl --request POST --url https://api.telegram.org/bot${token}/setWebhook --header 'content-type: application/json' --data '{"url":"${url}/${route}}"}'