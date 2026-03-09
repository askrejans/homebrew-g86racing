class SpeeduinoToMqtt < Formula
  desc "Speeduino ECU to MQTT bridge"
  homepage "https://github.com/askrejans/speeduino-to-mqtt"
  version "0.3.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://g86racing.com/packages/mac/speeduino-to-mqtt_#{version}_macos-arm64.tar.gz"
      sha256 "fb79004be7f8c999c93afd4f5053a77f729fefd339b5c71d72c9bff9b94d9c3c"
    end
    on_intel do
      url "https://g86racing.com/packages/mac/speeduino-to-mqtt_#{version}_macos-x86_64.tar.gz"
      sha256 "c6506d8d15fe03a98bfe67e25ec62e89d90ca423b6b0de309a6b2ecc3227162d"
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
