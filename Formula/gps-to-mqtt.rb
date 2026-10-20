class GpsToMqtt < Formula
  desc "Plug-and-play GNSS gateway: NMEA receivers to MQTT, HTTP, gpsd and NMEA"
  homepage "https://github.com/askrejans/gps-to-mqtt"
  version "0.7.0"
  license "GPL-3.0-only"

  on_macos do
    on_arm do
      url "https://g86racing.com/packages/mac/gps-to-mqtt_#{version}_macos-arm64.tar.gz"
      sha256 "8252bc6442bdf00232041de319f86aac67eab7f87862526422694c367e0d8e18"
    end
    on_intel do
      url "https://g86racing.com/packages/mac/gps-to-mqtt_#{version}_macos-x86_64.tar.gz"
      sha256 "3df9968bef13454d579eb1e5655850b8a573fe4f3dc93de8efcb362c0242f3f1"
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
