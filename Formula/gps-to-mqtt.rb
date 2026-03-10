class GpsToMqtt < Formula
  desc "GPS to MQTT bridge"
  homepage "https://github.com/askrejans/gps-to-mqtt"
  version "0.5.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://g86racing.com/packages/mac/gps-to-mqtt_#{version}_macos-arm64.tar.gz"
      sha256 "0ace64a35df339ae65eb95f5ca021fbf8a07376fa3814a0c173834908da41c59"
    end
    on_intel do
      url "https://g86racing.com/packages/mac/gps-to-mqtt_#{version}_macos-x86_64.tar.gz"
      sha256 "42473995f7c21e9d842b94581d934a0ae54ff898c7673cfcaf2f7cb34a6e679f"
    end
  end

  def install
    bin.install "gps-to-mqtt"
    (etc/"gps-to-mqtt").mkpath
    etc.install "settings.toml.example" => "gps-to-mqtt/settings.toml.example"
  end

  def caveats
    <<~EOS
      Copy and edit the example config before starting:
        cp #{etc}/gps-to-mqtt/settings.toml.example \\
           #{etc}/gps-to-mqtt/settings.toml
        $EDITOR #{etc}/gps-to-mqtt/settings.toml
    EOS
  end

  service do
    run [opt_bin/"gps-to-mqtt",
         "--config", "#{etc}/gps-to-mqtt/settings.toml"]
    keep_alive true
    log_path   var/"log/gps-to-mqtt.log"
    error_log_path var/"log/gps-to-mqtt.log"
  end

  test do
    system "#{bin}/gps-to-mqtt", "--help"
  end
end
