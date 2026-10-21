class SensorsToMqtt < Formula
  desc "Sensors (I2C, GPIO, serial, TCP bridge) to MQTT, HTTP and a web dashboard"
  homepage "https://github.com/askrejans/sensors-to-mqtt"
  version "0.6.0"
  license "GPL-3.0-only"

  # Tarballs are published to g86racing.com by
  # infra/deploy/scripts/publish-packages.sh; scripts/bump-formula.sh refreshes
  # the version and checksums below.
  on_macos do
    on_arm do
      url "https://g86racing.com/packages/mac/sensors-to-mqtt_#{version}_macos-arm64.tar.gz"
      sha256 "5c4fb6aa7b804a90bc3b6a729228025ca932b7d5967a6fde10abb43a4cf6fc87"
    end
    on_intel do
      url "https://g86racing.com/packages/mac/sensors-to-mqtt_#{version}_macos-x86_64.tar.gz"
      sha256 "19899accbc7b36080d19533519bd41adfebff054a696abcd6bfc24e1c167cc88"
    end
  end

  def install
    bin.install "sensors-to-mqtt"
    (etc/"sensors-to-mqtt").mkpath
    etc.install "settings.toml.example" => "sensors-to-mqtt/settings.toml.example"
  end

  def caveats
    <<~EOS
      Copy and edit the example config before starting:
        cp #{etc}/sensors-to-mqtt/settings.toml.example \\
           #{etc}/sensors-to-mqtt/settings.toml
        $EDITOR #{etc}/sensors-to-mqtt/settings.toml

      On macOS, local I2C and GPIO hardware is not available. Use the TCP
      bridge (io-to-net) for remote sensors, or a serial sensor:
        https://github.com/askrejans/io-to-net
      Try it without hardware: sensors-to-mqtt --simulate
    EOS
  end

  service do
    run [opt_bin/"sensors-to-mqtt", "--headless",
         "--config", "#{etc}/sensors-to-mqtt/settings.toml"]
    keep_alive true
    log_path   var/"log/sensors-to-mqtt.log"
    error_log_path var/"log/sensors-to-mqtt.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sensors-to-mqtt --version")
  end
end
