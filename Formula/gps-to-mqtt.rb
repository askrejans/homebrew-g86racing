class GpsToMqtt < Formula
  desc "Plug-and-play GNSS gateway: NMEA receivers to MQTT, HTTP, gpsd and NMEA"
  homepage "https://github.com/askrejans/gps-to-mqtt"
  version "0.7.1"
  license "GPL-3.0-only"

  on_macos do
    on_arm do
      url "https://g86racing.com/packages/mac/gps-to-mqtt_#{version}_macos-arm64.tar.gz"
      sha256 "eba7d8811551bf31c9369e626d4ea906365a1c8067d5dcb51245d66a3f55c8de"
    end
    on_intel do
      url "https://g86racing.com/packages/mac/gps-to-mqtt_#{version}_macos-x86_64.tar.gz"
      sha256 "82f11f58c53f743ec8f39a7b5cd3935d8c85929d8a212e63f774a8de60fd284a"
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
    run [opt_bin/"gps-to-mqtt", "--headless",
         "--config", "#{etc}/gps-to-mqtt/settings.toml"]
    keep_alive true
    log_path   var/"log/gps-to-mqtt.log"
    error_log_path var/"log/gps-to-mqtt.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gps-to-mqtt --version")
  end
end
