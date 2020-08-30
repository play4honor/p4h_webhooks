# p4h_webhooks

## Quickstart

### Turn on Webhook

```
sudo -E ~/go/bin/webhook -hooks ~/p4h_webhooks/hooks.json -verbose -template > ~/p4h_webhooks.log &
```

### Command to monitor Webhook

```
tail -F p4h_webhooks.log
```

## Setup

### Create a webhook on Discord

1. If you are using the `notify_dev_latest_image` and `notify_dev_development_image` webhooks, you need to create a webhook that posts to the relevant channel:

    ![image](https://user-images.githubusercontent.com/4514597/91671827-cf503180-eade-11ea-97d5-67cdef4ce75b.png)

2. Copy the webhook url for use in the nextstep (`DISCORD_WEBHOOK_URL`)

### Install Webhook on the deployment machine
1. Install [Webhook](https://github.com/adnanh/webhook) on the deploy machine
    - Make sure you have opened the port that Webhook is going to listen on (e.g., port `9000`)
2. Get the `hooks.json` and deploy script
    - For the main distribution, clone this repo ([here](https://github.com/play4honor/p4h_webhooks))
3. If you are using the `notify_dev_latest_image` and `notify_dev_development_image` webhooks, then you have to specify the **Discord** webhook you want to use and add it as an environment variable:
    ```
    echo 'export DISCORD_DEV_NOTIFICATION_WEBHOOK=[DISCORD_WEBHOOK_URL]' >> ~/.bashrc
    . ~/.bashrc
    ```
4. Run Webhook in terminal
    ```
    sudo -E ~/go/bin/webhook -hooks p4h_webhooks/hooks.json -verbose -template > p4h_webhooks.log &
    ```
### Point your Dockerhub build at the deploy machine
1. Setup a webhook on [Docker Hub](https://cloud.docker.com/repository/docker/cyzhang/discord_quote_bot/webhooks) that points to the deploy machine's endpoints (e.g., `http://ec2-[id].compute.amazonaws.com:9000/hooks/redeploy-quotebot/`)

    ![image](https://user-images.githubusercontent.com/4514597/91671853-058db100-eadf-11ea-8b6a-a2463e7d9919.png)
    
    Currently:
    
    
    - `http://ec2-[id].compute.amazonaws.com:9000/hooks/status/` (for html testing)
    - `http://ec2-[id].compute.amazonaws.com:9000/hooks/redeploy-quotebot/`
    - `http://ec2-[id].compute.amazonaws.com:9000/hooks/notify_dev_latest_image/`
    - `http://ec2-[id].compute.amazonaws.com:9000/hooks/notify_dev_development_image/`
        
## Troubleshooting

- Make sure the deploy machine's port is turned on
- No trailing `/` on the API endpoint
- You can test your hooks directly from terminal using this:
    ```
    # Re-deploy latest image
    curl --header "Content-Type: application/json" \
         --request POST \
         --data '{"push_data":{"tag":"latest"}}' \
         http://ec2-[id].us-west-2.compute.amazonaws.com:9000/hooks/redeploy-quotebot

    # Re-deploy development image
    curl --header "Content-Type: application/json" \
         --request POST \
         --data '{"push_data":{"tag":"development"}}' \
         http://ec2-[id].us-west-2.compute.amazonaws.com:9000/hooks/redeploy-quotebot

    # Notify about latest image
    curl --header "Content-Type: application/json" \
         --request POST \
         --data '{"push_data":{"tag":"latest"}}' \
         http://ec2-[id].us-west-2.compute.amazonaws.com:9000/hooks/notify_dev_latest_image

    # Notify about development image
    curl --header "Content-Type: application/json" \
         --request POST \
         --data '{"push_data":{"tag":"develpment"}}' \
         http://ec2-[id].us-west-2.compute.amazonaws.com:9000/hooks/notify_dev_development_image

    ```
- You can check if Webhook is on using your browser by visiting this URL:
    ```
    http://ec2-[id].compute.amazonaws.com:9000/hooks/status/
    ```
