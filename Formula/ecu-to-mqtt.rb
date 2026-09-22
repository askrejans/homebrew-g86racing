class EcuToMqtt < Formula
  desc "ECU to MQTT bridge (Speeduino, MegaSquirt, CAN profiles)"
  homepage "https://github.com/askrejans/ecu-to-mqtt"
  version "0.5.0"
  license "MIT"

  # Tarballs are published to g86racing.com by
  # infra/deploy/scripts/publish-packages.sh; scripts/bump-formula.sh refreshes
  # the version and checksums below.
  on_macos do
    on_arm do
      url "https://g86racing.com/packages/mac/ecu-to-mqtt_#{version}_macos-arm64.tar.gz"
      sha256 "72fc593ae1cb469d9a1365b196d6860bf8f5abff5415c678b7a35dbbf042189c"
    end
    on_intel do
      url "https://g86racing.com/packages/mac/ecu-to-mqtt_#{version}_macos-x86_64.tar.gz"
      sha256 "3e32deb76418a5a974f2c137ff2b85514b5420e0c582a896d045a2a610466225"
    end
  end

  def install
    bin.install "ecu-to-mqtt"
    (etc/"ecu-to-mqtt").mkpath
    etc.install "settings.toml.example" => "ecu-to-mqtt/settings.toml.example"
  end

  def caveats
    <<~EOS
      Copy and edit the example config before starting:
        cp #{etc}/ecu-to-mqtt/settings.toml.example \\
           #{etc}/ecu-to-mqtt/settings.toml
        $EDITOR #{etc}/ecu-to-mqtt/settings.toml

      Replacing speeduino-to-mqtt? Stop and uninstall it first; the new build
      uses ECU_TO_MQTT_* environment variables and the /ECU/ default topic:
        brew services stop askrejans/g86racing/speeduino-to-mqtt
        brew uninstall askrejans/g86racing/speeduino-to-mqtt
    EOS
  end

  service do
    run [opt_bin/"ecu-to-mqtt",
         "--config", "#{etc}/ecu-to-mqtt/settings.toml"]
    keep_alive true
    log_path   var/"log/ecu-to-mqtt.log"
    error_log_path var/"log/ecu-to-mqtt.log"
  end

  test do
    system "#{bin}/ecu-to-mqtt", "--help"
  end
end
