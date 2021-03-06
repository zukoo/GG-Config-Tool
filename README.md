# Jetson Configuration Utility

## Prerequisites

Install the device with JetPack 3.2 and log-in as **nvidia**. Make sure to uncheck OpenCV from the configuration.

![Jetson configuration][screenshot]

[screenshot]: ./static/images/jetson_config.png "Jetson configuration"

## Installation

The agent stays running all the time and waits for the Vol+ button to be double-pressed.

When the button is pressed it starts a web-ui with options to configure the Greengrass certificates and WiFi.

    git clone https://github.com/zukoo/GG-Config-Tool.git
    cd GG-Config-Tool
    sudo ./install.sh

### Optionally

You can choose to install the agent without the dependencies for ML @Edge like OpenCV and MXNet.

    sudo ./install.sh --no-dependencies

## Post-Install

You can now configure the device from the webUI, just double click on the button Vol+ and connect to it's IP via a web browser. You can then upload your AWS Greengrass certificates, don't forget to hit **Finished** to apply the changes when you're done.

![Jetson Buttons][buttons]

[buttons]: ./static/images/jetson_buttons.png "Jetson Buttons"

*In future versions of the tool this should create a WiFi Network to let you configure the device network configuration without knowing the device's IP address.*

![Jetson configuration][ui]

[ui]: ./static/images/ui.png "Jetson configuration UI"
