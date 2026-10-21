class GpsToMqtt < Formula
  desc "Plug-and-play GNSS gateway: NMEA receivers to MQTT, HTTP, gpsd and NMEA"
  homepage "https://github.com/askrejans/gps-to-mqtt"
  version "0.7.2"
  license "GPL-3.0-only"

  on_macos do
    on_arm do
      url "https://g86racing.com/packages/mac/gps-to-mqtt_#{version}_macos-arm64.tar.gz"
      sha256 "80e889b45727a98c7ec4b1e87c0a5f2bfde9daa311898be293269ddccf371989"
    end
    on_intel do
      url "https://g86racing.com/packages/mac/gps-to-mqtt_#{version}_macos-x86_64.tar.gz"
      sha256 "9e2b07d1fc7848ef513d4d4c0ec0fbeed7cf3d72e3b2ea26f52cd89e79b0cad1"
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
