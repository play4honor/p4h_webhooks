# p4h_webhooks

## Quickstart

### Turn on Webhook

```
sudo -E ~/go/bin/webhook -hooks ~/p4h_webhooks/hooks.json -verbose > ~/p4h_webhooks.log &
```

### Command to monitor Webhook

```
tail -F p4h_webhooks.log
```

## Troubleshooting

- Make sure the deploy machine's port is turned on
- No trailing `/` on the API endpoint

## Setup

1. Install [Webhook](https://github.com/adnanh/webhook) on the deploy machine
    - Make sure you have opened the port that Webhook is going to listen on (e.g., port `9000`)
2. Get the `hooks.json` and deploy script
    - For the main distribution, clone this repo ([here](https://github.com/zhangchuck/p4h_webhooks))
3. Run Webhook in terminal
    ```
    sudo -E ~/go/bin/webhook -hooks p4h_webhooks/hooks.json -verbose > p4h_webhooks.log &
    ```
4. Setup a webhook on [Docker Hub](https://cloud.docker.com/repository/docker/cyzhang/discord_quote_bot/webhooks) that points to the deploy machine's endpoint (e.g., `http://ec2-[id].compute.amazonaws.com:9000/hooks/redeploy-quotebot/`)
