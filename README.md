# Containerme
Development containers made easy
## Installation
### API
> [!WARNING]
> The API for now has no authentication and should be put behind a VPN (e.g. tailscale)

> API files are located in src/api/

1. Install the necessary dependencies with pip (pip install -r requirements.txt)
2. Run the server (python main.py)

### Docker images
> Docker Images are found in images/

SSH keys must be put in the keys directory relative to the image and will be bundled at build time. Adding new keys is as simple as putting them in /keys in the container and running sh /update-keys.sh

### CLI (Linux)
> The linux CLI is found in src/cli/

1. Add your base API url in ~/.config/containerme.sh (URL=<your_api_url>)
2. Run it :)

### Webui
WIP :) 