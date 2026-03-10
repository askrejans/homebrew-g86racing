class SensorsToMqtt < Formula
  desc "Multi-sensor to MQTT bridge with TUI (I2C, GPIO, serial, TCP bridge)"
  homepage "https://github.com/askrejans/sensors-to-mqtt"
  version "0.4.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://g86racing.com/packages/mac/sensors-to-mqtt-0.4.1-aarch64-apple-darwin.tar.gz"
      sha256 "f5387582d1e4f5a35da4f1781cae8c3b08a7f37dd91221d99146881bb280cab1"
    end
    on_intel do
      url "https://g86racing.com/packages/mac/sensors-to-mqtt-0.4.1-x86_64-apple-darwin.tar.gz"
      sha256 "7df04d767f68a79c8eeb452507c2871ac8447812b426e618ab7608c8c6928be5"
    end
  end

  def install
    bin.install "sensors-to-mqtt"
    (etc/"sensors-to-mqtt").mkpath
    (etc/"sensors-to-mqtt").install "settings.toml.example"
  end

  def caveats
    <<~EOS
      Configuration example: #{etc}/sensors-to-mqtt/settings.toml.example
      Copy and edit:
        cp #{etc}/sensors-to-mqtt/settings.toml.example #{etc}/sensors-to-mqtt/settings.toml

      On macOS, local I2C and GPIO hardware is not available.
      Use the TCP bridge (io-to-net) to connect to remote sensors:
        https://github.com/askrejans/io-to-net
    EOS
  end

  test do
    assert_match "sensors-to-mqtt", shell_output("#{bin}/sensors-to-mqtt --help")
  end
end
