class EcuToMqtt < Formula
  desc "ECU to MQTT bridge (Speeduino, MegaSquirt, CAN profiles)"
  homepage "https://github.com/askrejans/ecu-to-mqtt"
  version "0.3.3"
  license "MIT"

  # Renamed from speeduino-to-mqtt in 0.5.0. The URLs below still point at the
  # last published speeduino-to-mqtt artifacts; update them (and the checksums)
  # when ecu-to-mqtt packages are published.
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
    binary = File.exist?("ecu-to-mqtt") ? "ecu-to-mqtt" : "speeduino-to-mqtt"
    bin.install binary => "ecu-to-mqtt"
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
