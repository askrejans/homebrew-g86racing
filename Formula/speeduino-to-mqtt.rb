class SpeeduinoToMqtt < Formula
  desc "Speeduino ECU to MQTT bridge"
  homepage "https://github.com/askrejans/speeduino-to-mqtt"
  version "0.3.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://g86racing.com/packages/mac/speeduino-to-mqtt_#{version}_macos-arm64.tar.gz"
      sha256 "9a6435acb26abc00baa90e60598a8b469991b4415cfa0cfa2808baed9923538d"
    end
    on_intel do
      url "https://g86racing.com/packages/mac/speeduino-to-mqtt_#{version}_macos-x86_64.tar.gz"
      sha256 "87ae8a1f7c1b0db4e0b10e690dc679186b7cfbb62ad8c16318132070693c9797"
    end
  end

  def install
    bin.install "speeduino-to-mqtt"
    (etc/"speeduino-to-mqtt").mkpath
    etc.install "settings.toml.example" => "speeduino-to-mqtt/settings.toml.example"
  end

  def caveats
    <<~EOS
      Copy and edit the example config before starting:
        cp #{etc}/speeduino-to-mqtt/settings.toml.example \\
           #{etc}/speeduino-to-mqtt/settings.toml
        $EDITOR #{etc}/speeduino-to-mqtt/settings.toml
    EOS
  end

  service do
    run [opt_bin/"speeduino-to-mqtt",
         "--config", "#{etc}/speeduino-to-mqtt/settings.toml"]
    keep_alive true
    log_path   var/"log/speeduino-to-mqtt.log"
    error_log_path var/"log/speeduino-to-mqtt.log"
  end

  test do
    system "#{bin}/speeduino-to-mqtt", "--help"
  end
end
